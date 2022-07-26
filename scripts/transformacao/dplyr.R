library(dplyr)

facebook <- read.table("https://raw.githubusercontent.com/hugoavmedeiros/cd_com_r/master/bases_originais/dataset_Facebook.csv", sep=";", header = T)

# sumários
count(facebook, Type) 

# sumários com agrupamentos
facebook %>% group_by(Type) %>% summarise(avg = mean(like))

### Transformação de Casos

# seleção de casos
facebook %>%  filter(Type != "Photo") %>% summarise(avg = mean(like))
facebook %>%  filter(Type != "Photo") %>% group_by(Type, Paid) %>% summarise(avg = mean(like))

# ordenar casos
arrange(facebook, like) # ascendente
arrange(facebook, desc(like)) # descendente

### Transformação de Variáveis

# seleção de colunas
facebook %>% select(like, Type, Paid) %>% arrange(like)

# novas colunas
facebook %>% mutate(likePerLifeTime = like/Lifetime.Post.Total.Reach)

# renomear
facebook %>% rename(Reach = Lifetime.Post.Total.Reach)
