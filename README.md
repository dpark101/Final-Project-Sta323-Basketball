# Final-Project-Sta323-Basketball
Team: Michael Gao, Daniel Park, Justin Wang, Kaila Perez, Christopher Kehan Zhang
##File explanation
Players_data.R pulls all NBA players in history into a dataframe. 
Get_shots.R gets JSON data for every shot made by a specific player in a specific season then converts it into a tidy dataframe.
Server.R sources players_data.R and get_shots.R to pull the required data for the Shiny App.
UI.R is the front-end for the Shiny App.

The three Rdata files we used are playercolleges.Rdata, players.Rdata and active_players.Rdata. playercolleges provides a complete of all players as well as their colleges. It also includes other stats such as the minutes played, points scored and season played. players.Rdata and active_players.Rdata in that they both contain data about only current players except active_players.Rdata is a subset that only contains players that went to college. 

## Shotmap
In server.R after the user selects player and season a ggplot of that player's shots that season is shown. To draw the court, a series of geom_paths were used. We used a lot of guidance from Ed Kupfer's Half-Court drawing code to specifically fit our data.
The link to Ed Kupfer's code is here https://gist.github.com/edkupfer/6354404 .

##Analysis on shot taking
We had 2 ways to analyze the shots of each player. We created a table that calcualted the percentage of made shots at certain positions of the court as shown by the colors of the shotmap. We also allowed analysis on the time of the game by allowing users to chose a range of time in which the player has played during the season. This allows us to see whether a player is a good clutch player by assesing his accuracy late in the game and generalize on the best type of shot and location of shot. 

##College comparison
Lastly we made a tab to compare two colleges to see which one was better. We implemented comparisons between two colleges by taking data from all active_players in their respective college as well as providing a comprehensive list of all the players from those colleges. 