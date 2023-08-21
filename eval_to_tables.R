args = commandArgs(trailingOnly=TRUE)
input_file = args[1]
output_dir = args[2]

library(dplyr)

# input_file <- '/data/iGUIDE/analysis/KPW49/output/iguide.eval.KPW49.rds'

eval_data <- readRDS(input_file)

samples_to_analyze <- names(eval_data$ft_data)

samples_to_analyze <- unlist(samples_to_analyze)

df_spec_info <- data.frame(eval_data$spec_info$combo_overview)%>%
  dplyr::select(specimen, annotation)

df_all <- data.frame()
for (sample in samples_to_analyze){
  dfx <- eval_data$ft_data[[`sample`]]
  df_all <- rbind(df_all, dfx)
}

df_all <- merge(
  df_all,
  df_spec_info,
  by = 'annotation'
)

write.csv(df_all, file.path(output_dir,'eval_table.csv'), row.names = FALSE)