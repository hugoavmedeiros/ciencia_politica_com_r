# carregar as bibliotecas
pacman::p_load(cluster, factoextra, ggplot2, plotly)

facebook <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/cd_com_r/master/bases_tratadas/facebook_2021.csv')

facebook_cluster <- facebook[ , -(1:4)]

# setar semente aleatória
set.seed(1)

# elbow method
fviz_nbclust(facebook_cluster, kmeans, method = "wss")

# Agrupamento com kmeans
cls <- kmeans(facebook_cluster, centers = 5) # aprendizagem ns
facebook_cluster$cluster <- as.factor(cls$cluster) # passamos os clusters para a base original

# plot com ggplot
clusterPlot <- ggplot() +
  geom_point(data = facebook_cluster, 
             mapping = aes(x = num_comments, 
                           y = num_shares, 
                           colour = cluster)) +
  geom_point(mapping = aes_string(x = cls$centers[ , "num_comments"], 
                                  y = cls$centers[ , "num_shares"]),
             color = "red", size = 4) +
  geom_text(mapping = aes_string(x = cls$centers[ , "num_comments"], 
                                 y = cls$centers[ , "num_shares"],
                                 label = 1:5),
            color = "white", size = 2) +
  theme_light()

# gráfico interativo
ggplotly(clusterPlot)
