library(jsonlite)
library(dplyr)
get_shots = function(player_id, season){
  #TEST: James Harden player_id= "201935", season = "2014-15"
  #TEST: Michael Jordan player_id = "893"season = "1990-91"
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
  if(length(shots_data$resultSets$rowSet[[1]])!=0){
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
                   seconds_remaining = as.numeric(as.character(seconds_remaining)),
                   minute=12*(as.numeric(period)-1)+12-(minutes_remaining)-(seconds_remaining)/60.0
    )
    
    shots = data.frame(shots)
  } else{
    #otherwise spits out an empty data frame
    shots = data.frame(matrix(nrow = 0, ncol = length(col_names)))
    names(shots) = tolower(shots_data$resultSets$headers[[1]])
  }
}


