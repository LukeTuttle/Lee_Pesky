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
library(tidyverse)
library(purrr)
library(gridExtra)

prek_df <- readRDS("~/Github/Lee_Pesky/Lee_Pesky_Dashboard/prek_fid_checklist_cleaned.Rds")
# kinder_df <- readRDS("place_holder")

q_list_names <- unique(prek_df$question_type)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  
# Using if statement incase we end up using the kindergarten data frame as well    
df <- reactive({
  if (input$dataset == "Pre-K") {
    prek_df %>% filter(classroom == input$classroom)
  } else {
   NULL # this is where kinder_df will go
  }
})


# df2 <- reactive({
#   if (input$question_type != "All") {
#     df() %>% 
#       filter(classroom == input$classroom) %>% 
#       filter(question_type == input$question_type)
#   } else {
#     if (input$question_type == "All") {
#     df() %>% filter(classroom == input$classroom)
#     }
#   }
# })  

  
# output$table <- renderTable({
#   head(df2(), 20)
#   })







# 
# plot_list <- reactive({
#   if (input$question_type != "All") {
#    my_plot <-  df2() %>% 
#       ggplot(aes(x = question, y = performance, fill = as.factor(date_of_visit))) +
#       geom_col(position = "dodge") +
#       scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#       scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
#       labs(
#         title = input$classroom,
#         subtitle = str_to_upper(input$question_type),
#         x = paste0(str_to_title(input$question_type), " Question"),
#         y = "Performance"
#       )
#    return(my_plot)
#   } else {
#     get_all_plots <- function(classroom) {
#       q_list_names <- unique(df2$question_type) # THIS MAY BE CAUSING PROBLEMS
#       output <- list()
#       
#       for (i in q_list_names) {
#         class <- enquo(classroom)
#         type <- enquo(i)
#         
#         output[[i]] <- df2 %>% 
#           filter(classroom == !! class) %>% 
#           filter(question_type == !! type) %>% 
#           ggplot(aes(x = question, y = performance, fill = visit_number)) + 
#           geom_col(position = "dodge") +
#           scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#           scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Number")) +
#           labs(title = classroom,
#                subtitle = str_to_upper(question_type),
#                x = paste0(str_to_title(question_type), " Question"),
#                y = "Performance") 
#         
#       }
#       return(output)
#     }
#     get_all_plots(input$classroom)
#   }
# })
#   
# 
# output$classroom_plots <- renderPlot({
#   grid.arrange(grobs = plot_list(), ncol = length(plot_list))
#   })

# output$test_plot <- renderPlot({
#   if (input$question_type != "All") {
#     df2() %>% 
#       ggplot(aes(x = question, y = performance, fill = as.factor(date_of_visit))) +
#       geom_col(position = "dodge") +
#       scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#       scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
#       labs(
#         title = input$classroom,
#         subtitle = str_to_upper(input$question_type),
#         x = paste0(str_to_title(input$question_type), " Question"),
#         y = "Performance"
#       )
#   } else {
#     get_all_plots <- function(classroom_x) {
#       df3 <- df2()
#       q_list_names <- unique(df2()$question_type) # THIS MAY BE CAUSING PROBLEMS
#       output <- list()
#       
#       for (i in q_list_names) {
#         class <- enquo(classroom_x)
#         type <- enquo(i)
#         
#         p <- df3 %>% 
#           filter(classroom == !! class) %>% 
#           filter(question_type == !! type) %>% 
#           ggplot(aes(x = question, y = performance, fill = visit_number)) + 
#           geom_col(position = "dodge") +
#           scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#           scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Number")) +
#           labs(title = classroom_x,
#                subtitle = str_to_upper(i),
#                x = paste0(str_to_title(i), " Question"),
#                y = "Performance") 
#         output[[i]] <- p
#       }
#       return(output)
#     }
#     grid.arrange(grobs = get_all_plots(input$classroom), 
#                  ncol = 1)
#   }
# })


# get_all_plots <- function(classroom_x) {
#   df3 <- df2()
#   output <- list()
#   
#   for (i in q_list_names) {
#     class <- enquo(classroom_x)
#     type <- enquo(i)
#     
#     p <- df3 %>% 
#       filter(classroom == !! class) %>% 
#       filter(question_type == !! type) %>% 
#       ggplot(aes(x = question, y = performance, fill = visit_number)) + 
#       geom_col(position = "dodge") +
#       scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#       scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Number")) +
#       labs(title = classroom_x,
#            subtitle = str_to_upper(i),
#            x = paste0(str_to_title(i), " Question"),
#            y = "Performance") 
#     output[[i]] <- p
#   }
#   return(output)
# }



map(.x = q_list_names[1:3], .f = function(.x) {
  output[[paste0(.x)]] <- renderPlot({
    df2 <- df()
    x <- enquo(.x)
    df2 %>% 
      filter(question_type == !! x) %>% 
      ggplot(aes(x = question, y = performance,  fill = as.factor(date_of_visit))) + 
      geom_col(position = "dodge") +
      scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
      scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
      labs(title = NULL,
           subtitle = str_to_upper(.x),
           x = paste0(str_to_title(.x), " Question"),
           y = "Performance") 
  })
  }
  )
})

