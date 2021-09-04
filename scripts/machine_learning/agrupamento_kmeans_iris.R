# carregar as bibliotecas
pacman::p_load(cluster, ggplot2)

# pré-processamento
iris_cluster <- iris[ , -5]
str(iris_cluster)

# setar semente aleatória
set.seed(1)

# Agrupamento com kmeans
cls <- kmeans(x = iris_cluster, centers = 3) # aprendizagem ns
iris_cluster$cluster <- as.factor(cls$cluster) # passamos os clusters para a base original
head(iris_cluster)

# plot nativo do R
plot(iris_cluster)

# plot com função própria do pacote
clusplot(iris_cluster, cls$cluster, xlab = 'Fator1', ylab = 'Fator2', main = 'Agrupamento Estudantes', lines = 0, shade = F, color = TRUE, labels = 2)

# plot com ggplot
ggplot() +
  geom_point(data = iris_cluster, 
             mapping = aes(x = Sepal.Length, 
                           y = Petal.Length, 
                           colour = cluster)) +
  geom_point(mapping = aes_string(x = cls$centers[, "Sepal.Length"], 
                                  y = cls$centers[, "Petal.Length"]),
             color = "red", size = 4) +
  geom_text(mapping = aes_string(x = cls$centers[, "Sepal.Length"], 
                                 y = cls$centers[, "Petal.Length"],
                                 label = 1:3),
            color = "black", size = 4) +
  theme_light()

## comparação
iris_cluster$Species <- iris$Species
