library(data.table)
library(dplyr)

irisDT <- iris %>% setDT()
class(irisDT)

irisDT[species == 'setosa', ] #i, j, by

irisDT[species != 'setosa', ]

irisDT[Sepal.Length > 5 & species == 'setosa', ]

irisDT[.N]

irisDT[(.N-3)]

irisDT[ , Species]

cols <- c("Species", "Petal.Width")
irisDT[ , ..cols]

irisDT[Species == 'setosa', ][Sepal.Length > 5, ]

irisDT[ , .(Sepal.Length = mean(Sepal.Length, na.rm = T))]

irisDT[ , lm(formula = Sepal.Length ~ species + Sepal.Width + Petal.Length + Petal.Width)]

irisDT[ , .(Sepal.Length = mean(Sepal.Length, na.rm = T)), by = species]
