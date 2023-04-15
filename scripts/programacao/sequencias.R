pacman::p_load(corrplot, tidyverse)

# instruções para criar o gráfico de correlações da base de dados iris

# criando objetos
iris2 <- iris[ , -5] # retirar a coluna Species (fator)
irisCor <- cor(iris2)
corrplot(irisCor, method  = 'circle')

# funções aninhadas
corrplot(cor(iris[, -5]), method = 'square')

# pipe antigo %>%
iris %>% select(-Species) %>% cor() %>% corrplot(method = 'ellipse')

# pipe novo |>
iris |> select(-Species) |> cor() |> corrplot(method = 'shade')

# ctrl + shift + m       %>% 