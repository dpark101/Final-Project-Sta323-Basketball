library(shiny)
library(ggplot2)
library(dplyr)
library(jsonlite)
load("players.Rdata")
load("active_players.Rdata")

shinyUI(
  navbarPage("NBA App",
             tabPanel("Shot Chart Generator",
                      sidebarPanel(
                        selectInput("player", "Player:",players$display_first_last, selected = "Kobe Bryant"),
                        hr(),
                        uiOutput("season"),
                        actionButton("gen_plot", "Generate Shot Chart"),
                        hr(),
                        
                        
                        selectInput("regulation", "regulation time:",c("regulation", "overtime"), selected="regulation"),
                        conditionalPanel(
                          
                          condition= "input.regulation=='regulation'",
                          sliderInput("time", label = h3("Minutes"), min = 0, 
                                      max = 48, value = c(0, 48))
                        ),
                        conditionalPanel(
                          condition="input.regulation=='overtime'"
                          
                        )
                        
                      ),
                      
                      mainPanel(
                        h4("Results"),
                        plotOutput("shot_plot"),
                        hr(),
                        h4("Location of Shots"),
                        tableOutput("shottable"),
                        h4("Action of Shots"),
                        tableOutput("actiontable"),
                        h4("Breakdown of Location of Made Shots"),
                        plotOutput("pieshot"),
                        h4("Breakdown of Type of Made Shots"),
                        plotOutput("pieaction")
                      )
             ),
             tabPanel("Compare your school!",
                      sidebarPanel(
                        selectInput("school1", "Select First School:", sort(unique(active_players$school)), selected = "Duke University"),
                        hr(),
                        selectInput("school2", "Select Second School:", sort(unique(active_players$school)), selected = "University of North Carolina"), # Maybe make so you can't select same school?
                        radioButtons("choices", "Display:", c("School-Aggregated Stats", "Individual Player Stats")),
                        actionButton('gen_plot_comp', "Compare Alumni NBA Stats!"),
                        
                        
                        checkboxInput("checkbox", label = "show plots", value = FALSE)
                        
                      ),
                      
                      mainPanel(
                        h4(),
                        tableOutput('school1table'),
                        hr(),
                        tableOutput('school2table'),
                        plotOutput('visual1'),
                        plotOutput('visual2')
                      )
             )
  )
)
