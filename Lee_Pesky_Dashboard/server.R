#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(siverse)
library(purrr)
library(gridExtra)

prek_df <- readRDS("prek_fid_checklist_cleaned.Rds")
# kinder_df <- readRDS("place_holder")

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  
# Using if statement incase we end up using the kindergarten data frame as well    
datasetInput <- reactive({
  if (input$dataset == "Pre-K") {
    prek_df %>% 
      filter(classroom == input$classroom) %>% 
      filter(question_type == input$question_type)
  } else {
    kinder_df %>% 
      filter(classroom == input$classroom) %>% 
      filter(question_type == input$question_type)
  }
  
})
  
  
# output$table <- renderTable({ 
#     datasetInput()
#   })


# output$classroom_plot <- renderPlot({
#   datasetInput() %>% 
#     ggplot(aes(x = question, y = performance, fill = as.factor(date_of_visit))) +
#       geom_col(position = "dodge") +
#       scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#       scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
#       labs(
#         title = input$classroom,
#         subtitle = str_to_upper(input$question_type),
#         x = paste0(str_to_title(input$question_type), " Question"),
#         y = "Performance"
#       )
#       
#   })



plot1 <- reactive({
  datasetInput() %>% 
  ggplot(aes(x = question, y = performance, fill = as.factor(date_of_visit))) +
  geom_col(position = "dodge") +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
  labs(
    title = input$classroom,
    subtitle = str_to_upper(input$question_type),
    x = paste0(str_to_title(input$question_type), " Question"),
    y = "Performance"
  )
})

plot2 <- reactive({
  datasetInput() %>% 
    ggplot(aes(x = question, y = performance, fill = as.factor(date_of_visit))) +
    geom_col(position = "dodge") +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
    scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
    labs(
      title = input$classroom,
      subtitle = str_to_upper(input$question_type),
      x = paste0(str_to_title(input$question_type), " Question"),
      y = "Performance"
    )
})


  

output$classroom_plots <- renderPlot({
  plot_list <- list(plot1(), plot2())
  grid.arrange(grobs = plot_list, ncol = length(plot_list))
  })

})
