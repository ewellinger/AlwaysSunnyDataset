# This is a sample call to the OMDB API for filling in the general episode info
# Created Wed Jun 17 2015 by Erich Wellinger

# We will need both the JSONlite and curl packages to do this...
library(jsonlite); library(curl)

# We now need to load in the currently empty generalInfo.csv file
setwd("/Users/ewellinger/Git/AlwaysSunnyDataset")
generalInfo <- read.csv('generalInfo.csv')


# This will loop through all episodes of the series (given that there are 113 episodes at the time of creating this)
seaNum <- 1; epiNum <- 1
for (n in 1:113) {
  absNum <- n
  episodeURL <- paste("http://www.omdbapi.com/?t=It's%20Always%20Sunny%20in%20Philadelphia&Season=",
                      seaNum, "&Episode=", epiNum, sep="")
  jsonInfo <- fromJSON(episodeURL)
  # This tests to see if we have moved into the next season.  If so, it updates the the seaNum value and resets the epiNum value and then retrieves the correct JSON information
  if (jsonInfo$Response == 'False') {
    seaNum <- seaNum+1; epiNum <- 1
    episodeURL <- paste("http://www.omdbapi.com/?t=It's%20Always%20Sunny%20in%20Philadelphia&Season=",
                        seaNum, "&Episode=", epiNum, sep="")
    jsonInfo <- fromJSON(episodeURL)
  }
  generalInfo[absNum, 1] <- absNum
  generalInfo[absNum, 2] <- jsonInfo$Season
  generalInfo[absNum, 3] <- jsonInfo$Episode
  generalInfo[absNum, 4] <- jsonInfo$Title
  generalInfo[absNum, 5] <- jsonInfo$Released
  generalInfo[absNum, 6] <- jsonInfo$Writer
  generalInfo[absNum, 7] <- jsonInfo$Director
  generalInfo[absNum, 8] <- jsonInfo$Plot
  generalInfo[absNum, 9] <- jsonInfo$imdbRating
  generalInfo[absNum, 10] <- jsonInfo$imdbVotes
  generalInfo[absNum, 11] <- jsonInfo$Runtime
  epiNum <- epiNum+1
}

# We now want to remove the string "Rob McElhenney (developer), Glenn Howerton (developer), Rob McElhenney (creator), " from the WritBy
replacePattern <- "Rob McElhenney \\(developer\\), Glenn Howerton \\(developer\\), Rob McElhenney \\(creator\\), "
WritBy  <- as.data.frame(mapply(gsub, replacePattern, "", generalInfo$WritBy))
generalInfo[,6] <- WritBy
# Now do the same with the string "Rob McElhenney (developed by), Glenn Howerton (developed by), Rob McElhenney (created by), " which shows up only in Season 10 Writen By information...
replacePattern <- "Rob McElhenney \\(developed by\\), Glenn Howerton \\(developed by\\), Rob McElhenney \\(created by\\), "
WritBy  <- as.data.frame(mapply(gsub, replacePattern, "", generalInfo$WritBy))
generalInfo[,6] <- WritBy

# Now that we have the table made, we can save it back as a CSV file
write.csv(generalInfo, file="generalInfo.csv")

# Clean up
rm(list = ls())
detach("package:jsonlite", unload=TRUE)
detach("package:curl", unload=TRUE)
setwd("~/R")
 