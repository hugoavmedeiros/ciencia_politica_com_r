# carrega as bibliotecas
pacman::p_load(
  caret, corrplot, data.table, dplyr, fastDummies, ggplot2, SmartEDA, tidyverse)

# preparação

particaoIris = createDataPartition(iris$Sepal.Length, p=.7, list = F) # cria a partição 70-30
treinoIris = iris[particaoIris, ] # treino
testeIris = iris[-particaoIris, ] # - treino = teste

iris_formula <- Sepal.Length ~ . 

lista_modelos <- c('lm', 'glmnet', 'glmboost', 'rpart', 'cforest')

total_cv <- 10

train.control <- trainControl(method = "cv", number = total_cv, verboseIter = T) # controle de treino

pacman::p_load(caretEnsemble, doParallel)

registerDoParallel(cores = detectCores() - 1)

# modelagem

iris_modelos <- caretList(
  iris_formula, 
  data = treinoIris, 
  methodList = lista_modelos, 
  metric = "RMSE",
  trControl = train.control,
  tuneLength = 5)

pacman::p_load(DALEX, iml, pdp)

# importância

idepe_varImp <- varImp(iris_modelos$cforest)

idepe_varImp_df <- as.data.frame(as.matrix(idepe_varImp$importance))

idepe_varImp_df <- idepe_varImp_df %>% mutate(
  variável = c('Sepal Width ', 'Petal Length ', 'Petal Width', 'Versicolor?', 'Virgínica?')
)

grafico_varImp <- ggplot(data=idepe_varImp_df, aes(x=reorder(variável, -Overall), y=Overall)) + geom_bar(stat="identity", fill='#007095') + theme_minimal() + 
  coord_flip() + 
  labs(
    title  = ~ underline("Importância das variáveis usadas no modelo"), 
    subtitle = "Iris",
    caption = 'Modelo: Floresta Aleatória',
    x = '',
    y = 'Importância Relativa') + theme(
      plot.title = element_text(face = 'bold', lineheight = 1, size = 16, color = "#007095"),
      plot.subtitle = element_text(face = 'italic', size = 12, color = "#007095") ,
      plot.caption = element_text(size = 10, color = "#007095") ,
      strip.text = element_text(size = 10, color = "white") ,
      axis.title.x = element_text(hjust=0, color = "#007095"),
      axis.text.x = element_text(face = 'bold', colour = '#5bc0de', size = 12, angle = 75, vjust = .5),
      axis.title.y = element_text(hjust=0, color = "#007095"),
      axis.text.y = element_text(face = 'bold', colour = '#5bc0de', size = 12),
      legend.position="bottom", 
      legend.box = "horizontal",
      legend.background = element_rect(fill="#dee2e6", colour ="white")
    )

grafico_varImp

# perfil parcial

treinoIris_x <- dplyr::select(treinoIris, -Sepal.Length)
testeIris_x <- dplyr::select(testeIris, -Sepal.Length)

explainer_rf <- DALEX::explain(model = iris_modelos$cforest, data = testeIris_x, y = testeIris$Sepal.Length, label = "Random Forest")

pdp_rf_species <- model_profile(explainer = explainer_rf, variables = "Petal.Length", groups = "Species")

grafico_pdp <- plot(pdp_rf_species, geom = "profiles") +  
  labs(
    title  = ~ underline("Perfis de dependência parcial para PETAL LENGTH e SPECIES"), 
    subtitle = "Iris",
    caption = 'Modelo: Florestas Aleatórias',
    tag = '',
    x = 'Petal Length',
    y = 'Sepal Length',
    colour = "Species") + 
  scale_colour_manual(
    values = c('#f68d7c', '#8ecda6', 'blue'),
    name = "Species") + 
  theme(
    plot.title = element_text(face = 'bold', lineheight = 1, size = 16, color = "#007095"),
    plot.subtitle = element_text(face = 'italic', size = 12, color = "#007095") ,
    plot.caption = element_text(size = 10, color = "#007095") ,
    strip.text = element_text(size = 10, color = "white") ,
    axis.title.x = element_text(hjust=0, color = "#007095"),
    axis.text.x = element_text(face = 'bold', colour = '#5bc0de', size = 12),
    axis.title.y = element_text(hjust=0, color = "#007095"),
    axis.text.y = element_text(face = 'bold', colour = '#5bc0de', size = 12),
    legend.position="bottom", 
    legend.box = "horizontal",
    legend.background = element_rect(fill="#dee2e6", colour ="white")
  )

grafico_pdp
