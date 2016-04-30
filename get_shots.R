library(jsonlite)
library(dplyr)
get_shots = function(player_id, season){
  #TEST: James Harden player_id= "201935", season = "2014-15"
  #query JSON url using specified player_id and season
  shots_url = paste0('http://stats.nba.com/stats/shotchartdetail?CFID=33&CFPAR',
  'AMS=', season,'&ContextFilter=','&ContextMeasure=FGA', '&DateFrom=', '&DateTo=',
  '&GameID=', '&GameSegment=', '&LastNGames=0', '&LeagueID=00', '&Location=',
  '&MeasureType=', 'Base&Month=0', '&OpponentTeamID=0', '&Outcome=', '&PaceAdjust=N',
  '&PerMode=', 'PerGame&Period=0', '&PlayerID=', player_id, '&PlusMinus=N',
  '&Position=', '&Rank=N', '&RookieYear=', '&Season=', season, '&SeasonSegment=',
  '&SeasonType=Regular+Season','&TeamID=0', '&VsConference=', '&VsDivision=',
  '&mode=Advanced', '&showDetails=0', '&showShots=1','&showZones=0')
  
  #pull JSON data
  shots_data = fromJSON(shots_url)
  #create dataframe from JSON data
  if(length(shots_data)!=0){
    shots = tbl_df(data.frame(shots_data$resultSets$rowSet[[1]], stringsAsFactors = FALSE))
    names(shots) = tolower(shots_data$resultSets$headers[[1]])
    #convert all distance/time/binaries to numerics
    #NBA full court is 50 ft. from sideline to sideline
    #and 94 ft. end to end (47 ft. for half court)
    #data is in 1/10th of a foot from center so... X-Axis: -250 to 250, Y-Axis: -50 in. to 420 in.
    #divide loc_x and loc_y by 10 so we get it in feet
    #add 5 to loc_y so we can avoid negative y axis / make plotting easier
    shots = mutate(shots,
                   loc_x = as.numeric(as.character(loc_x))/10,
                   loc_y = as.numeric(as.character(loc_y))/10+5,
                   shot_distance = as.numeric(as.character(shot_distance)),
                   shot_made_numeric = as.numeric(as.character(shot_made_flag)),
                   shot_attempted_flag = as.numeric(as.character(shot_attempted_flag)),
                   shot_made_flag = as.numeric(as.character(shot_made_flag)),
                   minutes_remaining = as.numeric(as.character(minutes_remaining)),
                   seconds_remaining = as.numeric(as.character(seconds_remaining))
                   )
  }
  #spit out empty dataframe if no results matched
  else{
    col_names = tolower(shots_data$resultSets$headers[[1]])
    shots = data.frame(matrix(nrow = 0, ncol = length(col_names)))
  }
  
  
}

#https://gist.github.com/edkupfer/6354404

library(ggplot2)

ggplot(shots, aes(x=loc_x, y=loc_y)) + 
  #outer borders
  geom_path(data=data.frame(x=c(25,-25,-25,25,25),y=c(0,0,47,47,0)),aes(x=x,y=y)) +
  #top freethrow semicircle
  geom_path(data=data.frame(x=c(-6000:(-1)/1000,1:6000/1000),y=c(19+sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2))),aes(x=x,y=y))+
  #bottom freethrow semicircle
  geom_path(data=data.frame(x=c(-6000:(-1)/1000,1:6000/1000),y=c(19-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2))),aes(x=x,y=y),linetype='dashed')+
  #key
  geom_path(data=data.frame(x=c(-8,-8,8,8,-8),y=c(0,19,19,0,0)),aes(x=x,y=y))+
  #box inside key
  geom_path(data=data.frame(x=c(-6,-6,6,6,-6),y=c(0,19,19,0,0)),aes(x=x,y=y))+
  #restricted area semicircle
  geom_path(data=data.frame(x=c(-4000:(-1)/1000,1:4000/1000),y=c(5.25+sqrt(4^2-c(-4000:(-1)/1000,1:4000/1000)^2))),aes(x=x,y=y))+
  #halfcourt semicircle
  geom_path(data=data.frame(x=c(-6000:(-1)/1000,1:6000/1000),y=c(47-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2))),aes(x=x,y=y))+
  #rim
  geom_path(data=data.frame(x=c(-750:(-1)/1000,1:750/1000,750:1/1000,-1:-750/1000),y=c(c(5.25+sqrt(0.75^2-c(-750:(-1)/1000,1:750/1000)^2)),c(5.25-sqrt(0.75^2-c(750:1/1000,-1:-750/1000)^2)))),aes(x=x,y=y))+
  #backboard
  geom_path(data=data.frame(x=c(-3,3),y=c(4,4)),aes(x=x,y=y),lineend='butt')+
  #3 pt. line
  geom_path(data=data.frame(x=c(-22,-22,-22000:(-1)/1000,1:22000/1000,22,22),y=c(0,169/12,5.25+sqrt(23.75^2-c(-22000:(-1)/1000,1:22000/1000)^2),169/12,0)),aes(x=x,y=y))+
  #shot type identifier based on color and shape
  geom_point(aes(colour = shot_zone_basic, shape = event_type)) +
  xlim(-25, 25) +
  ylim(-5, 47)

#JPEG overlay method, faster but less accurate...
#library(grid)
#library(jpeg)
#library(RCurl)
#
#points(shots$loc_x, shots$loc_y, pch =".")
##code from https://thedatagame.com.au/2015/09/27/how-to-create-nba-shot-charts-in-r/
#courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
#court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
#                    width=unit(1,"npc"), height=unit(1,"npc"))
#ggplot(shots, aes(x=loc_x, y=loc_y)) + 
#  annotation_custom(court, -25, 25, -5, 42) +
#  geom_point(aes(colour = shot_zone_basic, shape = event_type)) +
#  xlim(-25, 25) +
#  ylim(-5, 42)


