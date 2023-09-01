pacman::p_load(data.table, digest)

ps_nomes <- read.csv2("G:/Meu Drive/ps_nomes.csv", encoding = 'Latin-1')
View(ps_nomes)

cols_to_mask <- c("nome")

anonymize <- function(x, algo="crc32") {
  sapply(x, function(y) if(y == "" | is.na(y)) "" else digest(y, algo = algo))
}

setDT(ps_nomes)
ps_nomes[, (cols_to_mask) := lapply(.SD, anonymize), .SDcols = cols_to_mask]

data.table::fwrite(ps_nomes,"ps_nomes.csv", sep = ";")
