pacman::p_load(ccaPP, lsa, minerva, Rfast)

multi.cor <- function(x, y) {
  c(
    cor = cor(x, y), 
    dcor = dcor(x, y),
    cosine = cosine(x, y), 
    maxCor = maxCorProj(x, y), 
    mine (x, y) 
  )
}

x <- runif (1000, 0, 10)
y <- 5 - 1.7*x

plot(x, y)

corList <- multi.cor(x, y)
names(corList)
corList <- corList[c(1,5,6,7, 15)]
corList

y1 <- y - runif(1000, 0, 1)

corList1 <- multi.cor(x, y1)
corList1 <- corList1[c(1,5,6,7, 15)]
corList1
plot(x, y1)

y2 <- y - runif(1000, 0, 2)

corList2 <- multi.cor(x, y2)
corList2 <- corList2[c(1,5,6,7, 15)]
corList2
plot(x, y2)

k <- runif(1000, -10, 10)
l <- 5 - 1.7*k + k^2

corList <- multi.cor(k, l)
names(corList)
corList <- corList[c(1,5,6,7, 15)]
corList

plot(k, l)

l1 <- l - runif(1000, -1, 1)

corList3 <- multi.cor(k, l1)
corList3 <- corList3[c(1,5,6,7, 15)]
corList3
plot(k, l1)

l2 <- l - runif(1000, -2, 2)

corList4 <- multi.cor(k, l2)
corList4 <- corList4[c(1,5,6,7, 15)]
corList4
plot(k, l2)

