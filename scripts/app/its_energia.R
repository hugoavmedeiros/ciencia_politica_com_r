#### pacotes ----
pacman::p_load(CausalImpact, janitor, readxl, strucchange, tidyverse)

#### etl ----
energia_pe <- readxl::read_excel(
  'bases_originais/consumo_energia_pe.xlsx'
) %>% clean_names() %>%
  mutate(
    indice = seq_along(ano)
  )

#### série interrompida ----
energia_bp <- breakpoints(energia_pe$rural_mwh ~ energia_pe$indice)  # Detectar pontos de quebra

summary(energia_bp)

energia_q1 <- energia_bp$breakpoints[1]
energia_q2 <- energia_bp$breakpoints[2]

#### impacto ----
##### quebra 1 ----
pre_energia_q1 <- c(1, energia_q1-1)
pos_energia_q1 <- c(energia_q1, energia_q2-1)

dados_q1 <- energia_pe %>%
  filter(
    indice < energia_q2
  ) %>%
  pull(rural_mwh)

impact_energia_q1 <- CausalImpact(dados_q1, pre_energia_q1, pos_energia_q1)

# Resumo dos resultados
summary(impact_energia_q1)

# Plotar os resultados
plot(impact_energia_q1)

##### quebra 2 ----
pre_energia_q2 <- c(
  1, 
  energia_q2-energia_q1-1)

pos_energia_q2 <- c(
  energia_q2-energia_q1, 
  energia_pe %>% nrow()-energia_q1)

dados_q2 <- energia_pe %>%
  filter(
    indice >= energia_q1+1
  ) %>%
  pull(rural_mwh)

impact_energia_q2 <- CausalImpact(dados_q2, pre_energia_q2, pos_energia_q2)

# Resumo dos resultados
summary(impact_energia_q2)

# Plotar os resultados
plot(impact_energia_q2)

#### gráfico customizado ----
energia_previsao <- fitted(energia_bp, breaks = length(energia_bp$breakpoints))

# Preparar os dados para o plot
energia_previsao_df <- data.frame(
  tempo = energia_pe$ano,
  real = energia_pe$rural_mwh,
  previsto = energia_previsao
)

# rótulos
energia_labels <- data.frame(
  tempo = energia_pe$ano[energia_bp$breakpoints],
  label = energia_pe$ano[energia_bp$breakpoints],
  max_y = max(energia_pe$rural_mwh) + max(energia_pe$rural_mwh)*0.075,
  min_y = min(energia_pe$rural_mwh)
)

# Plot com os resultados
ggplot(energia_previsao_df, aes(x = tempo, y = real)) +
  geom_point(
    aes(color = "Consumo Rural"), 
    alpha = 0.7) +
  geom_smooth(
    aes(y = previsto, color = "Tendência"),
    method = "loess", 
    span = 0.2, 
    se = TRUE, 
    size = 1.2, 
    fill = "gray70") +
  geom_vline(
    xintercept = energia_pe$ano[energia_bp$breakpoints], 
    color = "grey", 
    linetype = "dashed", 
    size = 1, 
    aes(linetype = "Quebras detectadas")) +
  geom_label(
    data = energia_labels, 
    aes(x = tempo, y = max_y, label = label), 
    fill = "grey", 
    color = "black", 
    size = 3, 
    fontface = "bold",
    label.padding = unit(0.5, "lines"), 
    label.r = unit(0.5, "lines"),
    label.size = 0) +  # Rótulos das quebras
  scale_color_manual(
    values = c("Consumo Rural" = "blue", "Tendência" = "red", "Quebras detectadas" = 'grey'),
    name = NULL
  ) +
  labs(
    title = "Consumo Rural de Energia",
    subtitle = 'Quebras estruturais na série',
    x = NULL,
    y = "Mwh",
    color = NULL,
    linetype = NULL
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.box = "horizontal"
  )
