#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(siverse)
library(tidyverse)
library(purrr)
prek_df <- readRDS("~/Github/Lee_Pesky/Lee_Pesky_Dashboard/prek_fid_checklist_cleaned.Rds")

#q_list <- unique(prek_df$question_type)


# Define UI for Pre-k fidelity checklist app
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Pre-k Checklist Fidelity"),
  
  sidebarPanel(
    selectInput("dataset", "Dataset:", 
                list("Pre-K" = "Pre-K")
    ),
    selectInput("classroom", "Classroom:",
                #create a vector teacher classrooms
                unique(prek_df$classroom)
    )
  ),
  mainPanel(
    
    # UI output
    
    q <- uiOutput("list"),
   
    
    map(.x = 1:9, function(.x) {
      plotOutput(paste0(.x))
    })
  )
)
)