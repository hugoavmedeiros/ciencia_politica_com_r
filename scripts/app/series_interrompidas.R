pacman::p_load(
  CausalImpact,
  ggplot2,
  janitor,
  MASS,
  readxl,
  strucchange,
  tidyverse,
  zoo)

data("Nile")
y <- as.numeric(Nile)  # Fluxo do rio Nilo
years <- 1871:1970   

bp <- breakpoints(y ~ years)  # Detectar pontos de quebra
summary(bp)

optimal_bp <- bp$breakpoints
fitted_values <- fitted(bp, breaks = length(optimal_bp))

# Preparar os dados para o plot
data_plot <- data.frame(
  Year = years,
  Flow = y,
  Fitted = fitted_values
)

# Plot com os resultados
ggplot(data_plot, aes(x = Year, y = Flow)) +
  geom_point(color = "blue", alpha = 0.7) +  # Pontos originais
  geom_line(aes(y = Fitted), color = "red", size = 1.2) + # Reta de ajuste por segmentos
  geom_vline(xintercept = years[optimal_bp], color = "green", linetype = "dashed", size = 1) + # Pontos de quebra
  labs(
    title = "Quebra estrutural estimada no fluxo do Rio Nilo",
    x = "Ano",
    y = "Fluxo do Rio Nilo"
  ) +
  theme_minimal()

data <- cbind(y)

# Definir os períodos pré e pós-quebra
pre.period <- c(1, 27)
post.period <- c(28, 100)

impact <- CausalImpact(data, pre.period, post.period)

# Resumo dos resultados
summary(impact)

# Plotar os resultados
plot(impact)

#### energia rural ----
energia_pe <- readxl::read_excel(
  'bases_originais/consumo_energia_pe.xlsx'
) %>%
  clean_names() %>%
  mutate(
    indice = seq_along(ano)
  )

energia_bp <- breakpoints(energia_pe$rural_mwh ~ energia_pe$indice)  # Detectar pontos de quebra
summary(energia_bp)

energia_bp$breakpoints

energia_previsao <- fitted(energia_bp, breaks = length(energia_bp$breakpoints))

# Preparar os dados para o plot
energia_previsao_df <- data.frame(
  tempo = energia_pe$ano,
  real = energia_pe$rural_mwh,
  previsto = energia_previsao
) %>%
  mutate(
    segment = cut(
      seq_along(tempo), 
      breaks = c(0, energia_bp$breakpoints, Inf),
      labels = FALSE, include.lowest = TRUE
    )
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

#### MVI ----
mvi_pe <- readxl::read_excel(
  'bases_originais/MVI E APREENSÃO DE ARMAS - PERNAMBUCO.xlsx'
) %>%
  clean_names() %>%
  mutate(
    mes_ano = as.yearmon(paste(mes, ano), "%b %Y")
  )

mvi_armas <- mvi_pe %>%
  filter(
    objeto_utilizado_na_vitima == 'ARMA DE FOGO'
  ) %>%
  group_by(
    mes_ano
  ) %>%
  summarise(
    mvi = sum(total)
  ) %>%
  mutate(
    indice = seq_along(mes_ano)
  )

mvi_bp <- breakpoints(mvi_armas$mvi ~ mvi_armas$indice)  # Detectar pontos de quebra
summary(mvi_bp)

mvi_bp$breakpoints

mvi_previsto <- fitted(mvi_bp, breaks = length(mvi_bp$breakpoints))

# Preparar os dados para o plot
mvi_df_predicao <- data.frame(
  tempo = mvi_armas$mes_ano,
  real = mvi_armas$mvi,
  previsto = mvi_previsto
) %>%
  mutate(
    segment = cut(
      seq_along(tempo), 
      breaks = c(0, mvi_bp$breakpoints, Inf),
      labels = FALSE, include.lowest = TRUE
    )
  )

# rótulos
breakpoints_labels <- data.frame(
  tempo = mvi_armas$mes_ano[mvi_bp$breakpoints],
  label = format(mvi_armas$mes_ano[mvi_bp$breakpoints], "%b %Y"),
  y_position = max(mvi_armas$mvi) + 20
)

# Plot com os resultados
ggplot(mvi_df_predicao, aes(x = tempo, y = real)) +
  geom_point(
    aes(color = "MVI"), 
    alpha = 0.7) +
  geom_smooth(
    aes(y = previsto, color = "Previsão"),
    method = "loess", 
    span = 0.2, 
    se = TRUE, 
    size = 1.2, 
    fill = "gray70") +
  geom_vline(
    xintercept = mvi_armas$mes_ano[mvi_bp$breakpoints], 
    color = "grey", 
    linetype = "dashed", 
    size = 1, 
    aes(linetype = "Quebras detectadas")) +
  geom_label(
    data = breakpoints_labels, 
    aes(x = tempo, y = y_position, label = label), 
    fill = "grey", 
    color = "black", 
    size = 3, 
    fontface = "bold",
    label.padding = unit(0.5, "lines"), 
    label.r = unit(0.5, "lines"),
    label.size = 0) +  # Rótulos das quebras
  scale_color_manual(
    values = c("MVI" = "blue", "Previsão" = "red", "Quebras detectadas" = 'grey'),
    name = NULL
  ) +
  labs(
    title = "Série de MVI - Pernambuco",
    subtitle = 'Quebras estruturais na série',
    x = NULL,
    y = "Total de MVI",
    color = NULL,
    linetype = NULL
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.box = "horizontal"
  )

mvi_bp$breakpoints

dados_q1 <- mvi_armas %>%
  filter(
    indice < mvi_bp$breakpoints[2]
  ) %>%
  pull(mvi)

pre.period <- c(1, (mvi_bp$breakpoints[1]-1))
post.period <- c(mvi_bp$breakpoints[1], (mvi_bp$breakpoints[2]-1))

mvi_impacto_q1 <- CausalImpact(dados_q1, pre.period, post.period)

mvi_impacto_q1 %>% summary()

mvi_contrafactual_q1 <- data.frame(mvi = mvi_impacto_q1$series$point.pred)

dados_q2 <- mvi_armas %>%
  filter(
    indice >= mvi_bp$breakpoints[1] & indice < mvi_bp$breakpoints[3]
  ) %>%
  pull(mvi)

pre.period_q2 <- c(
  1, 
  (mvi_bp$breakpoints[2]-mvi_bp$breakpoints[1]-1))
post.period_q2 <- c(
  (mvi_bp$breakpoints[2]-mvi_bp$breakpoints[1]), 
  length(dados_q2))

mvi_impacto_q2 <- CausalImpact(
  dados_q2, 
  pre.period_q2, 
  post.period_q2)

mvi_impacto_q2 %>% summary()

mvi_contrafactual_q2 <- data.frame(
  mvi = mvi_impacto_q2$series$point.pred,
  indice = )

mvi_contrafactual <- bind_rows(
  mvi_contrafactual_q1,
  mes
)

