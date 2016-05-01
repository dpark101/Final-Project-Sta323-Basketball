library(shiny)
library(ggplot2)
library(dplyr)
library(jsonlite)

source("players_data.R")
source("get_shots.R")

shinyUI(
  fluidPage(
    titlePanel(
      "NBA Player Shot Map & Stats"
    ),
    
    sidebarPanel(
      selectInput("player", "Player:",players$display_first_last, selected = "Stephen Curry"),
      hr(),
      uiOutput("season")
      ),
    
    mainPanel(
      h4("Results"),
      plotOutput("shot_plot"),
      hr()
    )
  )
)