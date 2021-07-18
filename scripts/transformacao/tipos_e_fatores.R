# Códigos do livro An Introduction to data cleaning with R

class(c("abc", "def"))
class(1:10)
class(c(pi, exp(1)))
class(factor(c("abc", "def")))

vrNumeric <- c("7", "7*", "7.0", "7,0")
is.numeric(vrNumeric)
as.numeric(vrNumeric)
as.integer(vrNumeric)
as.character(vrNumeric)

is.na(as.numeric(vrNumeric))

vrFactor <- factor(c("a", "b", "a", "a", "c"))
levels(vrFactor)

gender <- c(2, 1, 1, 2, 0, 1, 1)
recode <- c(male = 1, female = 2)
(gender <- factor(gender, levels = recode, labels = names(recode)))

(gender <- relevel(gender, ref = "female"))

age <- c(27, 52, 65, 34, 89, 45, 68)
(gender <- reorder(gender, age))

attr(gender, "scores") <- NULL
gender
