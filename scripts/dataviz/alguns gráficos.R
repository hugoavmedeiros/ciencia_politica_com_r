pacman::p_load(corrplot, ggplot2, grid, gridExtra)

g1 <- ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + geom_point() + geom_smooth(method=lm, se=FALSE)

g2 <- ggplot(iris, aes(x=Petal.Length, y=Sepal.Width)) + geom_point() + geom_smooth(method=lm, se=FALSE)

g3 <- ggplot(iris, aes(x=Petal.Length, y=Sepal.Length)) + geom_point() + geom_smooth(method=lm, se=FALSE)

grid.arrange(g1, g2, g3, nrow = 1, ncol = 3)

corrplot(cor(mtcars))
