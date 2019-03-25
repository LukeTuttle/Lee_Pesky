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
library(purrr)
prek_df <- readRDS("prek_fid_checklist_cleaned.Rds")


# Define UI for Pre-k fidelity checklist app
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Pre-k Checklist Fidelity"),
  
  sidebarPanel(
    selectInput("dataset", "Dataset:", 
                list("Pre-K" = "Pre-K")
    ),
    selectInput("classroom", "Classroom:",
                #create a named list of teacher classrooms
                unique(prek_df$classroom)
                
    ),
    selectInput("question_type", "Question Type:",
                c("All", unique(prek_df$question_type))
    )
  ),
    mainPanel(
     # plotOutput("classroom_plots"),
     # tableOutput("table"),
      plotOutput("test_plot")
    )
  ))