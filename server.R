if (("shiny" %in% rownames(installed.packages())) == FALSE){
  install.packages("shiny")
}

source("players_data.R")
source("get_shots.R")

load("active_players.Rdata")


library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  #dynamically updates the seasons in which player was active into a select Input box
  output$season <- renderUI({
    startyear = players$from_year[players$display_first_last == input$player]
    endyear = players$to_year[players$display_first_last == input$player]
    seasons = c(startyear:endyear)
    seasons_1 = seasons+1
    seasons_choices = mapply(function(x,y) paste0(x,"-",substr(y,3,4)) , x=seasons, y=seasons_1)
    selectInput("season", "Select Season:", seasons_choices)
  })
  
  
  
  observeEvent(input$gen_plot, {
    #obtains JSON pull for shot data based on player and season input
    shots = reactive({
      player_id = players$person_id[players$display_first_last == input$player]
      a=get_shots(player_id, input$season)
      if (input$regulation=="regulation"){
        a=a[a$minute>=input$time[1] & a$minute<=input$time[2],]
      }
      if (input$regulation=="overtime"){
        a=a[a$minute>=48,]
      }
      return(a)
    })
    
    tablelocation=reactive({
      a=shots()
      percentage=NULL
      location=NULL
      shots_made=NULL
      shots_attempted=NULL
      df=NULL
      for (i in unique(a$shot_zone_basic)){
        b=filter(a, a$shot_zone_basic==i)
        percentage=c(percentage, sum(b$shot_made_flag)/length(b$shot_made_flag))
        location=c(location, i)
        shots_made=c(shots_made, sum(b$shot_made_flag))
        shots_attempted=c(shots_attempted, length(b$shot_made_flag))
        df=data.frame(location, percentage, shots_made, shots_attempted)
      }
      return(df)
    })
    
    
    tableaction=reactive({
      a=shots()
      percentage=NULL
      action=NULL
      shots_made=NULL
      shots_attempted=NULL
      df=NULL
      for (i in unique(a$action_type)){
        b=filter(a, a$action_type==i)
        percentage=c(percentage, sum(b$shot_made_flag)/length(b$shot_made_flag))
        action=c(action, i)
        shots_made=c(shots_made, sum(b$shot_made_flag))
        shots_attempted=c(shots_attempted, length(b$shot_made_flag))
        df=data.frame(action, percentage, shots_made, shots_attempted)
        ans=head(df[order(-df$shots_attempted), ], n=10)
      }
      return(ans)
    })
    
    
    #plots the court and shot by categorization of shot
    output$shot_plot <- renderPlot({
      ggplot(shots(), aes(x=loc_x, y=loc_y)) + 
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
    })
    
    output$shottable=renderTable({
      tablelocation()
      
      
    })
    output$actiontable=renderTable({
      tableaction()
      
      
    })
    
    output$pieshot= renderPlot({
      ggplot(data=tablelocation(),
             aes(x= shots_made,fill = factor(location))) + geom_bar(width = 1) + 
        coord_polar(theta="y") + xlab("Percent of Made Shots")
    }
    )
    
    output$pieaction= renderPlot({
      ggplot(data=tableaction(),
             aes(x= shots_made,fill = factor(action))) + geom_bar(width = 1) + 
        coord_polar(theta="y") + xlab("Percent of Made Shots")
    }
    )
  })
  
  
  observeEvent(input$gen_plot_comp, {
    # First, filter datasets by selected schools:
    school1_subset <- reactive({active_players %>% 
        filter(school == input$school1)})
    school2_subset <- reactive({active_players %>%  
        filter(school == input$school2)})
    school1=reactive({
      j=school1_subset() %>% summarize(School = as.character(input$school1), Avg_games_played = mean(as.numeric(games)),
                                       FG_percent = mean(as.numeric(FG_per)), FT_percent = mean(as.numeric(FT_per)), Minutes_pergame = mean(as.numeric(MP_pg)), PPG = mean(as.numeric(PTSpg)), RPG = mean(as.numeric(TRB_pg)), APG = mean(as.numeric(AST_pg)))
      return(j)
    })
    school2=reactive({
      j=school2_subset() %>% summarize(School = as.character(input$school2), Avg_games_played = mean(as.numeric(games)),
                                       FG_percent = mean(as.numeric(FG_per)), FT_percent = mean(as.numeric(FT_per)), Minutes_pergame = mean(as.numeric(MP_pg)), PPG = mean(as.numeric(PTSpg)), RPG = mean(as.numeric(TRB_pg)), APG = mean(as.numeric(AST_pg)))
      return(j)
    })
    
    
    
    # Can display a table maybe?
    if({input$choices == "Individual Player Stats"}) {
      output$school1table <- renderTable({school1_subset() %>% select(Name = display_first_last, drafted = from_year, team_city, team_name, game_played = games,
                                                                      FG_percent = FG_per, FT_percent = FT_per, Minutes_pergame = MP_pg, PPG = PTSpg, RPG = TRB_pg, AST = AST_pg) })
      output$school2table <- renderTable({school2_subset() %>% select(Name = display_first_last, drafted = from_year, team_city, team_name, game_played = games,
                                                                      FG_percent = FG_per, FT_percent = FT_per, Minutes_pergame = MP_pg, PPG = PTSpg, RPG = TRB_pg, AST = AST_pg)})
    }
    if({input$choices == "School-Aggregated Stats"}) {
      output$school1table <- renderTable({school1()})
      output$school2table <- renderTable({school2() })
    }
    
    
    output$visual2=renderPlot({
      if (input$checkbox==TRUE){
        
        a=barplot(rbind(as.numeric(school1()%>%select(FG_percent, FT_percent)), as.numeric(school2()%>%select(FG_percent, FT_percent))), beside=TRUE, names=c("FG_percent", "FT_percent"), col=c("blue", "red"), legend = c(input$school1, input$school2), 
                  main=paste0(input$school1, " vs ", input$school2))
        return(a)
      }
    })
    output$visual1=renderPlot({
      if (input$checkbox==TRUE){
        
        a=barplot(rbind(as.numeric(school1()%>%select(PPG,APG, RPG)), as.numeric(school2()%>%select(PPG,APG, RPG))), beside=TRUE, names=c("PPG", "APG", "RPG"), col=c("blue", "red"), legend = c(input$school1, input$school2), 
                  main=paste0(input$school1, " vs ", input$school2))
        
        return(a)
      }
    })
    
    
  })
  
})

