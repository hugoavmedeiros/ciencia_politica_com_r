pacman::p_load(cluster, ggplot2)

iris_cluster <- iris[, -5]
str(iris_cluster)

set.seed(1)

cls <- kmeans(x = iris_cluster, centers = 3)
iris_cluster$cluster <- as.character(cls$cluster)
head(iris_cluster)

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


clusplot(iris_cluster, cls$cluster, xlab = 'Fator1', ylab = 'Fator2', main = 'Agrupamento Estudantes', lines = 0, shade = F, color = TRUE, labels = 2)

iris_cluster$Species <- iris$Species
