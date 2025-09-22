install.packages("terra")
install.packages("ggplot2")

library(terra)
library(ggplot2)

data_path <- "Z:/Data/PoPS Runs/Spotted Lanternfly/spotted_latternfly/whole_usa/5km"
map_data <- rast(file.path(data_path, "probability_30_year.tif"))


plot(map_data[[1]])


df_data <- file.path(data_path, "crop_risk2.csv")

ggplot(df_data)
