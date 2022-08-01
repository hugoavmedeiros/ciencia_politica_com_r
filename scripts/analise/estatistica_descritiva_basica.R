### Estatística Descritiva com R

## Tabela de frequência absoluta da variável Species da base iris
table(iris$Species)

## Tabela de frequência relativa da variável Species da base iris
prop.table(table(iris$Species))

## Média da variável Sepal.Length da base iris
mean(iris$Sepal.Length)

## Mediana da variável Sepal.Length da base iris
median(iris$Sepal.Length)

## Separatrizes da variável Sepal.Length da base iris
quantile(iris$Sepal.Length, probs=0.75)
quantile(iris$Sepal.Length, probs=0.10)
quantile(iris$Sepal.Length, probs=0.95)

## Desvio-padrão da variável Sepal.Length da base iris
sd(iris$Sepal.Length)

## Sumário descritivo básico das variáveis
summary(iris)

## Sumário descritivo completo das variáveis usando o pacote fBasics
pacman::p_load(fBasics)
basicStats(iris[ , c(1:4)])
