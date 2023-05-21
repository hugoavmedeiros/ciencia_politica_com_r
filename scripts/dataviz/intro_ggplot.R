## Carregar pacotes que serão usados
pacman::p_load(dplyr, ggplot2)

defesaBrasilLong <- readRDS('bases_tratadas/orcamento_defesa_brasil.rds')

# Gráfico de Caixas Univariado

iris %>% ggplot(aes(y = Sepal.Length)) + geom_boxplot()

# Gráfico de Caixas Univariado

iris %>% ggplot(aes(y = Sepal.Length, x = Species)) + geom_boxplot()

# Histograma

iris %>% ggplot(aes(x = Sepal.Length)) + geom_histogram()

# Densidade

iris %>% ggplot(aes(x = Sepal.Length)) + geom_density()

# Barras
iris %>% ggplot(aes(y = Species, x = Sepal.Length)) + geom_bar(stat = "identity")

# Séries Temporais
defesaBrasilLong %>% ggplot(aes(x = Ano, y = Valor)) + geom_line()

# Dispersão
defesaBrasilLong %>% ggplot(aes(x = Ano, y = Valor)) + geom_point()
