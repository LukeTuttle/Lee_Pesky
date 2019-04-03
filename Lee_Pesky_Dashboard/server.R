
library(shiny)
library(siverse)
library(tidyverse)
library(purrr)


prek_df <- readRDS("~/Github/Lee_Pesky/Lee_Pesky_Dashboard/prek_fid_checklist_cleaned.Rds")
kinder_df <- readRDS("~/Github/Lee_Pesky/Lee_Pesky_Dashboard/kinder_fid_checklist_cleaned.rds")


# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

#q_list <- unique(prek_df$question_type)

# Using if statement incase we end up using the kindergarten data frame as well    
df <- reactive({
  if (input$dataset == "Pre-K") {
    prek_df %>% filter(classroom == input$classroom)
  } else {
   NULL # this is where kinder_df will go
  }
})



output$list <- renderUI({
  list <- unique(df()$question_type)
  paste0(list, collapse = ", ")
})


q_list <- observe(
  unique(df()$question_type)
)



# map(.x = q_list, .y = 1:9, .f = function(.x, .y) {
#   output[[paste0(.y)]] <- renderPlot({
#     df2 <- df()
#     x <- enquo(.x)
#     df2 %>%
#       filter(question_type == !! x) %>%
#       ggplot(aes(x = question, y = performance, group = as.factor(date_of_visit), fill = as.factor(date_of_visit))) +
#       geom_col(position = "dodge2") +
#       scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
#       scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
#       coord_cartesian(ylim = c(0,3.5)) +
#       labs(title = NULL,
#            subtitle = str_to_upper(.x),
#            x = paste0(str_to_title(.x), " Question"),
#            y = "Performance")
#   })
#   }
#   )
})

