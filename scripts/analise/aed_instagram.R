#### PREPARAÇÃO ####
### PACOTES ###
pacman::p_load(
  #ETL
  data.table, dplyr, lubridate, tidyr,
  # Gráficos
  GGally, ggcorrplot, ggplot2, gt, gtExtras, gtsummary, plotly, 
  # Renderização
  kableExtra
)

### ETL ###
instagram_unifafire <- fread('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/instagram_unifafire.csv')

str(instagram_unifafire)

instagram_unifafire <- instagram_unifafire %>% mutate_at(
  c('mes', 'turno'), 
  as.factor)

instagram_unifafire$Data <- mdy(instagram_unifafire$Data)

### AED ###
## NUMÉRICA ##
instagram_unifafire %>% select(Curtidas, Comentários, Visualizações, mes, turno) %>% tbl_summary()

## MISTA ##
instagram_unifafire%>% select(Curtidas, Comentários, Visualizações, mes, turno) %>% gt_plt_summary() %>% 
  cols_label(
    name = "Variável",
    value = "Gráfico",
    type = "", 
    n_missing = "Valores Ausentes", 
    Mean = "Média",
    Median = "Mediana",
    SD = "Desvio"
  ) %>% 
  tab_header(
    title = "Posts no Instagram da UniFAFIRE",
    subtitle = "https://www.instagram.com/unifafire/"
  )

## GRÁFICA ##
# BOX PLOT #
bp_curtidas_turno <- instagram_unifafire %>% ggplot(aes(x=turno, y=Curtidas, color=turno)) + geom_boxplot()
ggplotly(g_curtidas_turno)

# HISTOGRAMA #
hist_curtidas_turno <- instagram_unifafire %>% ggplot(aes(x=Curtidas, color=turno)) +  geom_histogram(fill="white", position="identity")
ggplotly(hist_curtidas_turno)

# DENSIDADE
dens_curtidas_turno <- instagram_unifafire %>% ggplot(aes(x=Curtidas, color=turno)) +  geom_density()
ggplotly(dens_curtidas_turno)

# BARRAS
barras_curtidas_mes <- instagram_unifafire %>% ggplot(aes(turno)) +  geom_bar(aes(weight = Curtidas, fill = turno))
ggplotly(barras_curtidas_mes)

# SÉRIE TEMPORAL
st_curtidas_data <- instagram_unifafire %>% ggplot(aes(x = Data, y = Curtidas)) + geom_line(aes(color = turno))
ggplotly(st_curtidas_data)

# DISPERSÃO
sct_curtidas_comentarios <- instagram_unifafire %>% ggplot(aes(x=Curtidas, y=Comentários)) + geom_point() + geom_smooth()
ggplotly(sct_curtidas_comentarios)

bolha_curtidas_comentarios <- instagram_unifafire %>% ggplot(aes(x=Curtidas, y=Comentários)) + geom_point(aes(size=Visualizações)) + geom_smooth()
ggplotly(bolha_curtidas_comentarios)
