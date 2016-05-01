if (("shiny" %in% rownames(installed.packages())) == FALSE){
  install.packages("shiny")
}
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  output$season <- renderUI({
    startyear = players$from_year[players$display_first_last == input$player]
    endyear = players$to_year[players$display_first_last == input$player]
    seasons = c(startyear:endyear)
    seasons_1 = seasons+1
    seasons_choices = mapply(function(x,y) paste0(x,"-",substr(y,3,4)) , x=seasons, y=seasons_1)
    selectInput("season", "Select Season:", seasons_choices)
  })
  
  shots = reactive({
    player_id = players$person_id[players$display_first_last == input$player]
    get_shots(player_id, input$season)
  })
  
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
  
})