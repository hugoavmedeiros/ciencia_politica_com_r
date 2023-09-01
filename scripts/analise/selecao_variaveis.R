subsets <- c(1:13)
ctrl <- rfeControl(functions = lmFuncs,
                   method = "repeatedcv",
                   repeats = 5,
                   verbose = FALSE)

lmProfile <- rfe(ENEM_ESCOLA[, 2:14], ENEM_ESCOLA[, 1],
                 sizes = subsets,
                 rfeControl = ctrl)
lmProfile
predictors(lmProfile)


# regressão com caret
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino
regENEMCV <- train(nota ~ ., data = ENEM_ESCOLA, method = "lm", trControl = train.control)
summary(regENEMCV)

regENEMCV$finalModel