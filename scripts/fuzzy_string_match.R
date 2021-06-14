# Exemplo universidade de princeton
baseA <- read.csv("http://www.princeton.edu/~otorres/sandp500.csv")
baseB <- read.csv("http://www.princeton.edu/~otorres/nyse.csv") 

# Advanced
baseC <- fuzzyjoin::stringdist_join(baseA, baseB, mode='left')
baseC <- fuzzyjoin::distance_join(baseA, baseB, mode='left')

# Fuzzy Match
baseC <- baseB
baseC$Name.b <- baseC$Name
baseC$Name <- lapply(baseC$Name, function(pattern, x) x[which.min(adist(pattern, x, partial=TRUE))], baseA$Name)
baseD <- merge(baseA, baseC)
