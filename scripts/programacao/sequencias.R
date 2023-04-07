pacman::p_load(corrplot, tidyverse)

## exemplo 1 - simples, com duas funções ##

# criando objetos
irisSpecies <- group_by(iris, Species)
summary(irisSpecies)

# funções aninhadas
summary(group_by(iris, Species))

# pipe antigo %>%
iris %>% group_by(Species) %>%  summary()

# pipe novo |>
iris |> group_by(Species) |>  summary()

## exemplo 2 - complexo, com várias funções ##

# criando objetos
iris2 <- iris %>% select(-Species)
irisCor <- cor(iris2)
corrplot(irisCor, method  = 'circle')

# funções aninhadas
corrplot(cor(iris %>% select(-Species)), method = 'square')

# pipe antigo %>%
iris %>% select(-Species) %>% cor() %>% corrplot(method = 'ellipse')

# pipe novo |>
iris |> select(-Species) |> cor() |> corrplot(method = 'shade')
