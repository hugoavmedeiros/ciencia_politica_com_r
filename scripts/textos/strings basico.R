exString1 <- "EAG 6/1996 => PEC 33/1995"

sub(" =>.*", "", exString1)

sub(".*=> ", "", exString1)
