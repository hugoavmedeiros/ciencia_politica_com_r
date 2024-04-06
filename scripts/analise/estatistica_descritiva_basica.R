pacman::p_load(
  tidyverse
)

### Estatística Descritiva com R
## Tabela de frequência absoluta da variável Species da base iris
iris %>% select(Species) %>% table() 

## Tabela de frequência relativa da variável Species da base iris
iris %>% select(Species) %>% table() %>% prop.table()

## Média da variável Sepal.Length da base iris
iris$Sepal.Length %>% mean()

## Mediana da variável Sepal.Length da base iris
iris$Sepal.Length %>% median()

## Separatrizes da variável Sepal.Length da base iris
iris$Sepal.Length %>% quantile(probs=0.75)
iris$Sepal.Length %>% quantile(probs=0.10)
iris$Sepal.Length %>% quantile(probs=0.99)
iris$Sepal.Length %>% boxplot() # boxplot - gráfico que resume as sepatrizes

## Desvio-padrão da variável Sepal.Length da base iris
iris$Sepal.Length %>% sd()
iris$Sepal.Length %>% plot()

## Sumário descritivo básico das variáveis
iris %>% summary()

## Sumário descritivo completo das variáveis usando o pacote fBasics
pacman::p_load(fBasics)
iris %>% select(1:4) %>% basicStats()
iris$Sepal.Length %>% hist() # histograma - gráfico que permite conhecer a curva dos dados
