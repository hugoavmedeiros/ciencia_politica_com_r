#### pacotes ----
pacman::p_load(cobalt, data.table, MatchIt, rbounds, sensemakr, tidyverse)

#### etl ----
escolas_integrais <- fread(
  'bases_tratadas/idepe_par.csv',
  dec = ',',
  encoding = 'UTF-8') %>%
  mutate(
    TP_LOCALIZACAO = as.factor(TP_LOCALIZACAO)
  )

escolas_integrais %>% glimpse()

escolas_integrais %>%
  count(ano, tratamento)

escolas_integrais_2008 <- escolas_integrais %>%
  filter(ano == 2008)

#### pareamento ----
pareamento_integrais <- matchit(
  tratamento ~ tdi_3em + TP_LOCALIZACAO + IN_INTERNET + IN_NOTURNO + IN_EJA,
  data = escolas_integrais_2008,
  method = "nearest"
)

#### diagnóstico ----
# combinar dados
integrais_pareadas <- match.data(pareamento_integrais)

# análise gráfica do ajuste
love.plot(pareamento_integrais)

# análise gráfica da sobreposição
ggplot(integrais_pareadas, aes(x = distance, fill = as.factor(tratamento))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("red", "blue"), 
                    labels = c("Controle", "Tratado")) +  # Cores
  labs(
    title = "Distribuição dos Escores de Propensão",
    x = "Escore de Propensão",
    y = "Densidade",
    fill = "Grupo"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# análise numérica do ajuste
summary(pareamento_integrais)$sum.matched