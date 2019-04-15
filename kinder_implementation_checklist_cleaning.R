library(tidyverse)
library(siverse)

og_kinder_df <- read_excel("Kinder Instructional Notes1.xlsx", sheet = "Form1") %>% clean_names()



# These are the question groupings I tooks from the (Microsoft) office form I was given by Lee Pesky.
# The commented out questions are present in the excel file but not in the form for some reason. 
# Futhermore, most of the commented out questions/columns dont contain any values except for 1 or 2 lines with older time stamps.
# My guess is they had they questions included on the form early on and then deleted them but the columns were retained in the excel file. 
# I left them in as commented out lines just in case they decide to put them back on the form down the road. Doesn't hurt I figure  
q_list <- list(
  "Daily Language/Opening Routines" = c(
    "district_adopted_materials_used", 
    "prioritized_2_3_routines_including_pa", 
    "delivered_instructional_routines_as_intended_by_the_program",
    "x90_100_percent_of_students_are_participating_80_90_percent_rate_moderate",
    "pacing_kept_lesson_within_parameters_10_15_minutes_rate_strong_6_9_or_13_15_minutes_rate_moderate_5_and_under_or_over_15_minutes_rate_weak",
    "teacher_redirects_and_encourages_students_to_participate_as_needed", 
    # "used_a_variety_of_engagement_strategies",
    "delivered_in_whole_group_setting"
  ),
  "Word Work (phonemic awareness, phonics, and high-frequency words)" = c(
    "used_instuctional_routines_as_intended_by_program",
    "district_adopted_materials_used_or_aligned_supplemental_materials_to_score_strong_must_use_te",
    "delivered_decoding_instruction_as_described_in_the_graphic_organizer",
    "x90_100_percent_of_students_are_participating_80_90_percent_rate_moderate_2",
    "pacing_kept_lesson_within_10_15_min_a_b_teachers_are_teaching_2_lessons",
    "teacher_redirects_and_encourages_students_to_participate_as_needed2",
    "used_a_variety_of_engagement_strategies_2_3_rate_strong_1_rate_moderate_0_rate_weak",
    "delivered_in_whole_group_setting2",
    "followed_daily_lesson_sequence_in_the_te"
  ),
  "Skills and Strategies (reading, fluency, text-based comprehension)" = c(
    "days_1_3_taught_the_comprehension_strategy_and_or_skill_and_modeled_fluency_skill_for_that_week_according_to_the_program",
    "days_3_4_students_are_reading_student_book_for_fluency_4_times_strong_2_3_times_moderate_1_time_weak",
    "questions_are_asked_to_support_comprehension_skills_emphasized_vocabulary_from_the_program_3_4_times",
    "x90_100_percent_of_students_have_opportunities_to_respond_80_90_percent_rate_moderate",
    "pacing_kept_lesson_within_10_15_min_a_b_teachers_are_teaching_2_lessons_2",
    "teacher_redirects_and_encourages_students_to_participate_as_needed3",
    # "used_a_variety_of_engagement_strategies3",
    "delivered_in_whole_group_setting3",
    # "followed_daily_lesson_sequence_in_the_program2",
    "used_a_variety_of_engagement_and_student_response_strategies",
    "used_the_district_adopted_materials"
  ),
  # x4 = c(
  #   "used_writing_scope_and_sequence_from_district_adopted_program",
  #   "grammar_lesson_is_incorporated_in_the_writing_activity",
  #   "phonics_skills_are_incorporated_into_writing_lesson",
  #   "x90_100_percent_of_students_are_participating_80_90_percent_rate_moderate_4",
  #   "pacing_kept_lesson_within_15_20_min_a_b_teachers_are_teaching_2_lessons_and_time_is_doubled3",
  #   "teacher_redirects_and_encourages_students_to_participate_as_needed4",
  #   "delivered_in_whole_group_setting4",
  #   "used_a_variety_of_engagement_strategies_2"
  # ),
  "Small Group/Independent Practice" = c(
    "differentiated_instruction_is_supporting_whole_group_instruction",
    "district_adopted_materials_or_supplemental_materials_that_are_aligned",
    # "teacher_uses_a_variety_of_instructional_strategies_to_address_student_needs",
    # "x90_100_percent_of_students_are_participating_80_90_percent_rate_moderate_5",
    # "if_needed_teacher_adjusts_pace_based_on_children_s_participation",
    # "teacher_redirects_and_encourages_students_to_participate_as_needed5",
    "students_not_working_with_teacher_in_small_group_are_enaged_in_activities_that_reinforce_weeks_focus",
    "teacher_can_focus_on_instruction_because_groups_are_well_managed",
    "small_group_time_does_not_compromise_whole_group_instruction"
  ),
  "Positive Climate" = c(
    "positive_affect_smiling_laughter_enthusiasm",
    "relationships_proximity_shared_activities_social_conversations",
    "positive_communication_high_expectations",
    "respect_respectful_language_cooperation_sharing_encouraged"
    ),
  "Behavior Management" = c(
    "proactive_anticipates_problem_behavior",
    "clear_behavior_expectations",
    "redirection_of_misbehavior",
    "monitors"
  ),
  "Productivity" = c(
    "maximizes_learning_time",
    "routines_children_know_what_to_do_clear_instructions",
    "transitions_brief_follow_through_learning_opportunities",
    "preparation_materials_are_ready_teacher_prepared_for_lesson"
  )
  # x9 = c(
  #   "classroom_dynamics_please_mark_as_many_as_apply",
  #   "schedule_shows_recommended_amount_of_ela_instruction_60_minute_half_day_90_minute_for_full_day_every_day_120_minutes_for_every_other_day",
  #   "the_scheduled_components_match_the_journeys_te_and_the_time_guidelines_from_the_training_whole_group_components_are_delivered_whole_group_additional_time_is_added_for_small_group"
  # )
)


kinder_df <- og_kinder_df %>% 
  select(teacher_last_name, school, date_of_observation, observation, unlist(q_list, use.names = FALSE)) %>% 
  gather(key = "question", value = "performance", unlist(q_list, use.names = FALSE)) %>% 
  unite("classroom", school, teacher_last_name, sep = " -- ") %>%
  mutate(question_type = case_when(
    question %in% q_list$`Daily Language/Opening Routines` ~ "Daily Language/Opening Routines", 
    question %in% q_list$`Word Work (phonemic awareness, phonics, and high-frequency words)` ~ "Word Work (phonemic awareness, phonics, and high-frequency words)", 
    question %in% q_list$`Skills and Strategies (reading, fluency, text-based comprehension)` ~ "Skills and Strategies (reading, fluency, text-based comprehension)", 
    question %in% q_list$`Small Group/Independent Practice` ~ "Small Group/Independent Practice", 
    question %in% q_list$`Positive Climate` ~ "Positive Climate", 
    question %in% q_list$`Behavior Management` ~ "Behavior Management", 
    question %in% q_list$Productivity ~ "Productivity", 
    TRUE ~ identity(question)
    )
  )

#This is to use with ggplot alpha to show that they actually had a reason for not entering the value. 
kinder_df <- kinder_df %>% 
  mutate(reason_not_entered = case_when(
    performance %in% c(
      "Instruction does not happen this day in the program", 
      "Not mandatory because it is a half-day program", 
      "Did not include this component even though it is a full day program"
    ) ~ "1",
    TRUE ~ "0"
  )
  )

# Make performance contain only 0-3 
kinder_df <- kinder_df %>% 
  mutate_at(.vars = vars(performance), .funs = funs(case_when(
    is.na(.) ~ "0",
    . %in% c(paste0(6:9), 
             "Instruction does not happen this day in the program", 
             "Not mandatory because it is a half-day program", 
             "Did not include this component even though it is a full day program"
    ) ~ "0",
  . %in% c("No", "Low 1") ~ "1",
  . == "Medium 2" ~ "2",
  . %in% c("Yes", "High 3") ~ "3",
  TRUE ~ as.character(.)
  )
  )
  )

# Get rid of underscores in questions
kinder_df <- kinder_df %>% 
  mutate(question = str_replace_all(question, "_", " "))

# Eliminate NA lines
kinder_df <- kinder_df %>% 
  filter(classroom != "NA -- NA")

saveRDS(kinder_df, file = "Lee_Pesky_Dashboard/kinder_fid_checklist_cleaned.rds")

