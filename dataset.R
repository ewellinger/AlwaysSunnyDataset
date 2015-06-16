# We want to impliment a hashtable in R for looking up alligences of characters given an episode
# The list of keys will be...
keys <- c('dee', 'dennis', 'mac', 'charlie', 'frank')

# Then we would set up a map for S01E01 as follows?
S01E01 <- new.env(hash=T, parent=emptyenv())

# S01E01: Starts with Dennis and Charlie being alligned in support of being a gay bar, while Mac and Dee are against it
# Dennis and Charlie alliance...
S01E01[[keys[2]]] <- keys[4]
S01E01[[keys[4]]] <- keys[2]
# Dee and Mac alliance...
S01E01[[keys[1]]] <- keys[3]
S01E01[[keys[3]]] <- keys[1]

# See what alligience dee has...
S01E01[['dee']]
