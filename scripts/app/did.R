# Instale os pacotes necessários, caso ainda não tenha feito
install.packages("did")
install.packages("readxl")
install.packages("tidyverse")

# Carregue os pacotes
library(did)
library(readxl)
library(tidyverse)

data(mpdta)

mpdta %>%
  distinct(countyreal, first.treat) %>%
  count(first.treat)

out <- att_gt(
  yname = "lemp",
  gname = "first.treat",
  idname = "countyreal",
  tname = "year",
  xformla = ~1,
  data = mpdta
)

summary(out)

ggdid(out)
