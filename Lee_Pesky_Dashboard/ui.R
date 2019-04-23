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
                list("Kindergarten" = "Kindergarten", 
                     "Pre-K" = "Pre-K")
    ),
    selectInput("classroom", "Classroom:",
                #create a vector teacher classrooms
               NULL
    )
  ),
  mainPanel(
    
    # UI output
    
    uiOutput("plots")
    
    
    # map(.x =  function(.x) {
    #   plotOutput(paste0(.x))
    # })
  )
)
)