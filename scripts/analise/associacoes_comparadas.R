pacman::p_load(ccaPP, lsa, Rfast)

multi.cor <- function(x, y) {
  c(cor = cor(x, y), maxCor = maxCorProj(x, y), dcor = dcor(x, y), cosine = cosine(x, y)
  )
}

x <- rnorm (200, 4, 1)
y <- 5 - 1.7*x

plot(x, y)

corList <- multi.cor(x, y)
names(corList)
corList <- corList[c(1,2,13,14)]
corList

y1 <- y - rnorm(200, 0, 0.5)

corList1 <- multi.cor(x, y1)
corList1 <- corList1[c(1,2,13,14)]
corList1
plot(x, y1)

y2 <- y - rnorm(200, 0, 1.5)

corList2 <- multi.cor(x, y2)
corList2 <- corList2[c(1,2,13,14)]
corList2
plot(x, y2)

k <- rnorm (1000, 4, 1)
l <- 5 - 1.7*k + k^2

corList <- multi.cor(k, l)
names(corList)
corList <- corList[c(1,2,13,14)]
corList

plot(k, l)

l1 <- l - rnorm(200, 0, 0.5)

corList3 <- multi.cor(k, l1)
corList3 <- corList3[c(1,2,13,14)]
corList3
plot(k, l1)
