#### PREPARAÇÃO ####
### PACOTES ###
pacman::p_load(
  # ETL
  data.table, dplyr, lubridate, tidyr,
  # Gráficos
  GGally, ggcorrplot, ggplot2, gt, gtExtras, gtsummary, plotly, 
  # Renderização
  kableExtra
)

### ETL ###
instagram_unifafire <- fread('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/instagram_unifafire.csv')

instagram_unifafire %>% str()

# mudar o tipo de dado das colunas mes e turno para fator 
instagram_unifafire <- instagram_unifafire %>% 
  mutate_at( 
  c('mes', 'turno'), 
  as.factor) 

# mudar o tipo de dado da coluna "Data" para date
instagram_unifafire <- instagram_unifafire %>%
  mutate_at( 
    c('Data'), 
    mdy) 

# converter mes para 
instagram_unifafire <- instagram_unifafire %>%
  mutate(
    mes = month(Data, label = TRUE)
  )

### AED ###
## AED NUMÉRICA ##
# tabela com sumário dos dados
instagram_unifafire %>% 
  select(Curtidas, Comentários, Visualizações, mes, turno) %>% 
  tbl_summary() # cria o sumário

## AED MISTA ##
# cria tabela com gráficos e sumários
instagram_unifafire %>% 
  select(Curtidas, Comentários, Visualizações, mes, turno) %>% gt_plt_summary() %>% #função para gerar a tabela
  cols_label( # customizações
    name = "Variável", # troca o nome da coluna 1
    value = "Gráfico", # troca o nome da coluna 2
    type = "", # remove o tipo
    n_missing = "Valores Ausentes",  # troca o nome da coluna 3
    Mean = "Média", # troca o nome da coluna 4
    Median = "Mediana", # troca o nome da coluna 5
    SD = "Desvio" # troca o nome da coluna 6
  ) %>% 
  tab_header(
    title = "Posts no Instagram da UniFAFIRE", # troca o tículo
    subtitle = "https://www.instagram.com/unifafire/" # troca o subtítulo
  )

## AED GRÁFICA ##
## Gráficos que resumem os dados #
# BOX PLOT #
# gráfico para visualizar a separação dos dados, inclusive por categoria
# x deve ser um fator, y uma métrica e cor o fator usado em x
bp_curtidas_turno <- instagram_unifafire %>% 
  ggplot(aes(x=mes, y=Curtidas, color=mes)) +
  geom_boxplot()

bp_curtidas_turno %>% ggplotly() # torna o gráfico interativo

# HISTOGRAMA #
# gráfico de frequência, inclusive por categoria
# x deve ser numérico e color deve ser um fator
# podemos colocar a cor da linha com fill e a posição
hist_curtidas_turno <- instagram_unifafire %>% 
  ggplot(aes(x=Curtidas, color=turno)) + 
  geom_histogram(fill="white", position="identity") 
hist_curtidas_turno %>% ggplotly() # torna o gráfico interativo

# DENSIDADE
# gráfico de frequência suavizada, inclusive por categoria
# x deve ser numério e color deve ser um fator
dens_curtidas_turno <- instagram_unifafire %>% 
  ggplot(aes(x=Curtidas, color=turno)) +
  geom_density()
dens_curtidas_turno %>% ggplotly() # torna o gráfico interativo

# BARRAS
# gráfico que apresenta os totais de uma categoria
# x deve ser uma categoria, weight deve ser numério e fill deve ser a mesma categoria de x
barras_curtidas_mes <- instagram_unifafire %>% 
  ggplot(aes(turno)) +
  geom_bar(aes(weight = Curtidas, fill = turno)) + coord_flip()
barras_curtidas_mes %>% ggplotly() # torna o gráfico interativo

# SÉRIE TEMPORAL
# gráfico que apresenta um número ao longo do tempo
# X deve ser date e y deve ser numérico, color deve ser uma categoria
st_curtidas_data <- instagram_unifafire %>% 
  ggplot(aes(x = Data, y = Curtidas)) + 
  geom_line(aes(color = turno))
st_curtidas_data %>% ggplotly() # torna o gráfico interativo

# DISPERSÃO
# a primeira versão associa duas variáveis
# x e y devem ser numéricos
sct_curtidas_comentarios <- instagram_unifafire %>% 
  ggplot(aes(x=Curtidas, y=Comentários)) + 
  geom_point() + # cria os pontos
  geom_smooth() # cria a curva de associação

sct_curtidas_comentarios %>% ggplotly() # torna o gráfico interativo

# a segunda versão associa três variáveis, com a terceria indicando o tamanho da circunferência dos pontos
bolha_curtidas_comentarios <- instagram_unifafire %>% 
  ggplot(aes(x=Curtidas, y=Comentários)) + 
  geom_point(aes(size=Visualizações)) + # tamanho dos pontos
  geom_smooth() # cria a curva de associação
bolha_curtidas_comentarios %>% ggplotly() # torna o gráfico dinâmico
