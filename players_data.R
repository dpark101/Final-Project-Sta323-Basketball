library(jsonlite)
library(dplyr)
#get all players ever in NBA history into a nice tidy dataframe
players_url = "http://stats.nba.com/stats/commonallplayers?LeagueID=00&Season=2015-16&IsOnlyCurrentSeason=0"
players_data = fromJSON(players_url)
players = tbl_df(data.frame(players_data$resultSets$rowSet[[1]], stringsAsFactors = FALSE))
names(players) = tolower(players_data$resultSets$headers[[1]])

# Only get active players

players <- players %>% filter(rosterstatus != 0)
save(players, file="players.Rdata")

