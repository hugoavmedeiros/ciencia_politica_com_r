pacman::p_load(dplyr, ggplot2, plotly, readxl, tidyr)

baseArtigo <- read_excel("bases_originais/base_artigo_v1.xlsx")

View(baseArtigo)
str(baseArtigo)

baseArtigo$casos <- as.factor(baseArtigo$casos)

baseArtigo2 <- baseArtigo %>% 
  select(casos, Ano, v_positive_e_ios , v_negative_e_ios) %>% 
  pivot_longer(cols=c('v_positive_e_ios', 'v_negative_e_ios'), names_to='avaliacao', values_to="valor")

## 
gCasos <- ggplot(
  data = baseArtigo2, # base utilizada
  mapping = aes(x = Ano, # eixo x
                y = valor, # eixo y
                fill=avaliacao) # cor das variáveis
  ) + 
  geom_bar(stat='identity', position='dodge') + # identity soma y e agrupa por x, e dodge coloca lado a lado
  facet_wrap(facets = vars(casos), scales = "free") + # cria facetas, ou seja, minigráficos de acordo com a variável indicada
  theme_classic() # tema clássico, para ficar mais legível

gCasos

ggplotly(gCasos)
