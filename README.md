# Final-Project-Sta323-Basketball
##File explanation
Players_data.R pulls all NBA players in history into a dataframe. 
Get_shots.R gets JSON data for every shot made by a specific player in a specific season then converts it into a tidy dataframe.
Server.R sources players_data.R and get_shots.R to pull the required data for the Shiny App.
UI.R is the front-end for the Shiny App.
Explanation for the various Rdata files and how it's used?


## Shotmap
In server.R after the user selects player and season a ggplot of that player's shots that season is shown. To draw the court, a series of geom_paths were used. We used a lot of guidance from Ed Kupfer's Half-Court drawing code to specifically fit our data.
The link to Ed Kupfer's code is here https://gist.github.com/edkupfer/6354404 .

##Other Parts of the Projects...etc.
