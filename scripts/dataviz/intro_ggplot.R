## Carregar pacotes que serão usados
pacman::p_load(dplyr, ggplot2)

# Gráfico de Caixas Univariado
iris %>% ggplot(aes(y = Sepal.Length)) + geom_boxplot()

# Gráfico de Caixas Multivariado
iris %>% ggplot(aes(y = Sepal.Length, x = Species)) + geom_boxplot()

# Histograma
iris %>% ggplot(aes(x = Sepal.Length)) + geom_histogram()

# Densidade
iris %>% ggplot(aes(x = Sepal.Length)) + geom_density()

## Leitura base orçamento defesa brasil
defesaBrasilLong <- readRDS('bases_tratadas/orcamento_defesa_brasil.rds')

# Séries Temporais
defesaBrasilLong %>% group_by(Ano) %>% summarise(Valor = sum(Valor)) %>% ggplot(aes(x = Ano, y = Valor)) + geom_line()

# Barras
defesaBrasilLong %>% ggplot(aes(x = Ano, y = Valor)) + geom_bar(stat = "identity")

# Dispersão
defesaBrasilLong %>% ggplot(aes(x = Ano, y = Valor)) + geom_point()
