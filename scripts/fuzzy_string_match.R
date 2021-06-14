# Exemplo universidade de princeton
baseA <- read.csv("http://www.princeton.edu/~otorres/sandp500.csv")
baseB <- read.csv("http://www.princeton.edu/~otorres/nyse.csv") 

# Advanced
baseC <- fuzzyjoin::stringdist_join(baseA, baseB, mode='left')
baseC <- fuzzyjoin::distance_join(baseA, baseB, mode='left')
