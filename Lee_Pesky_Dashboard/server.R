
library(shiny)
library(siverse)
library(tidyverse)
library(purrr)



prek_df <- readRDS("~/Github/Lee_Pesky/Lee_Pesky_Dashboard/prek_fid_checklist_cleaned.Rds")
kinder_df <- readRDS("~/Github/Lee_Pesky/Lee_Pesky_Dashboard/kinder_fid_checklist_cleaned.rds")


# Define server logic required to plot various variables against mpg
shinyServer(function(input, output, session) {

#q_list <- unique(prek_df$question_type)

# Using if statement incase we end up using the kindergarten data frame as well    
df <- reactive({
  if (input$dataset == "Pre-K") {
    prek_df 
  } else {
    kinder_df
  }
})


observe({
  updateSelectInput(session, inputId = "classroom",
                    choices = unique(df()$classroom))
})




output$list <- renderUI({
  list <- unique(df()$question_type)
  paste0(list, collapse = ", ")
})





q_list <- reactive({
  unique(df()$question_type)
})

df2 <- reactive({
  df() %>% filter(classroom == input$classroom)
})



output$plots <- renderUI({
  plot_output_list <- lapply(1:length(q_list), function(i) {
    plotname <- paste("plot", i, sep = "")
    plotOutput(plotname)
  })
  
  do.call(tagList, plot_output_list)
})


for (i in 1:length(q_list)) {
  local({
    my_i <- i
    plotname <- paste("plot", my_i, sep = "")
   reactive({
     q_type <- q_list[my_i]
   })
    output[[plotname]] <- renderPlot({
      df3 <- df2()
      
      x <- enquo(q_type())
      df3 %>%
        filter(question_type == !! x) %>%
        ggplot(aes(x = question, y = performance, group = as.factor(date_of_visit), fill = as.factor(date_of_visit))) +
        geom_col(position = "dodge2") +
        scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
        scale_fill_discrete(palette = viridis, guide = guide_legend("Visit Date")) +
        coord_cartesian(ylim = c(0,3.5)) +
        labs(title = NULL,
             subtitle = str_to_upper(.x),
             x = paste0(str_to_title(.x), " Question"),
             y = "Performance")
    })
  })
}

# map(.x = q_list, .f = function(.) {
#   output[[paste0(.)]] <- renderPlot({
#     df3 <- df2()
#     x <- enquo(.)
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

