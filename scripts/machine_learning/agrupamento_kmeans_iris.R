# carregar as bibliotecas
pacman::p_load(cluster, dplyr, factoextra, ggplot2)

# pré-processamento
iris_cluster <- iris[ , -5]
str(iris_cluster)

# definir semente aleatória
set.seed(1)

# Método do Cotovelo
fviz_nbclust(iris_cluster, kmeans, method = "wss")

# Agrupamento com kmeans
cls <- kmeans(x = iris_cluster, centers = 3) # aprendizagem ns
iris_cluster$cluster <- as.factor(cls$cluster) # passamos os clusters para a base original
head(iris_cluster)

# plot com função própria do pacote
clusplot(iris_cluster, cls$cluster, xlab = 'Fator1', ylab = 'Fator2', main = 'Agrupamento Estudantes', lines = 0, shade = F, color = TRUE, labels = 2)
