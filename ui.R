library(shiny)
library(ggplot2)
library(dplyr)
library(jsonlite)


shinyUI(
  navbarPage("NBA App",
             tabPanel("Shot Chart Generator",
                      sidebarPanel(
                        selectInput("player", "Player:",players$display_first_last, selected = "Stephen Curry"),
                        hr(),
                        uiOutput("season"),
                        actionButton("gen_plot", "Generate Shot Chart")
                      ),
                      
                      mainPanel(
                        h4("Results"),
                        plotOutput("shot_plot"),
                        hr()
                      )
             ),
             tabPanel("Compare your school!",
                      sidebarPanel(
                        selectInput("school1", "Select First School:", sort(unique(active_players$school)), selected = "Duke University"),
                        hr(),
                        selectInput("school2", "Select Second School:", sort(unique(active_players$school)), selected = "University of North Carolina"), # Maybe make so you can't select same school?
                        radioButtons("choices", "Display:", c("School-Aggregated Stats", "Individual Player Stats")),
                        actionButton('gen_plot_comp', "Compare Alumni NBA Stats!")
                      ),
                      
                      mainPanel(
                        h4(),
                        tableOutput('school1table'),
                        hr(),
                        tableOutput('school2table')
                      )
  )
)
)
