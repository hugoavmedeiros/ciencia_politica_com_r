#### pacotes ----
pacman::p_load(data.table, ggcorrplot, rdd, tidyverse)

corte = 3.2

#### etl ----
escolas_reforco <- fread(
  'bases_tratadas/idepe_rdd.csv',
  dec = ',',
  encoding = 'UTF-8') %>%
  mutate(
    TP_RURAL = ifelse(TP_LOCALIZACAO == "Rural", 1, 0),
    tratamento = ifelse(idepe_2014 > corte, 0, 1)
  )

escolas_reforco %>% glimpse()

escolas_reforco %>%
  count(ano, tratamento)

#### regressão descontínua ----
mc_test <- DCdensity(
  escolas_reforco$idepe_2014, 
  cutpoint = corte)

mc_test

covariaveis <- escolas_reforco %>%
  select(tdi_3em, TP_RURAL, IN_NOTURNO, IN_EJA, IN_INTERNET)

# Calcular a matriz de correlação
matriz_correlacao <- cor(covariaveis, use = "complete.obs")

ggcorrplot(
  matriz_correlacao, 
  type = "full", 
  lab = TRUE, 
  title = "Matriz de Correlação das Covariáveis"
)

#### rdd ---
escolas_rdd_padrao <- RDestimate(
  idepe_2015 ~ idepe_2014,
  data = escolas_reforco, 
  cutpoint = corte)

summary(escolas_rdd_padrao)

escolas_rdd_cov <- RDestimate(
  idepe_2015 ~ idepe_2014 | tdi_3em + TP_RURAL + IN_NOTURNO + IN_EJA + IN_INTERNET + tp_escola,
  data = escolas_reforco, 
  cutpoint = corte)

summary(escolas_rdd_cov)

ggplot(escolas_reforco, aes(x = idepe_2014, y = idepe_2015, color = as.factor(tratamento))) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess") +
  geom_vline(xintercept = corte, linetype = "dashed", color = "red") +
  labs(
    title = "Visualização da Regressão Descontínua",
    x = "IDEP de 2014 (Running Variable)",
    y = "IDEP de 2015 (Desfecho)",
    color = "Grupo"
  ) +
  theme_minimal()
