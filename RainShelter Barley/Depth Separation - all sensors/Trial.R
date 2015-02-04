setwd('C:/GitHubRepos/Summer Project - R/RainShelter Barley/Depth Separation')

library(dplyr)
library(ggplot2)
source('datafunctions.R')

<<<<<<< HEAD:RainShelter Barley/Depth Separation - all sensors/Trial.R

=======
<<<<<<< HEAD
>>>>>>> 57e5deb6739518e7e27abc9553305e225f562a98:RainShelter Barley/Depth Separation/Trial.R
allData <- function() {
  library(tidyr)
  con <- DBConnection()
  header_data <- dbReadTable(con, "headerversion")
  raw_data<- dbReadTable(con, "rawcsvdata")
  closeDBConnection(con)
  header_names <- names(read.csv(textConnection(header_data$HeaderLine)))
  all_data <- separate(raw_data, line, into=header_names, sep=",")  
  return(all_data)  
}

start_date <-'2015-01-01'
end_date <- '2015-01-31'
sensor_type <- "VolumetricWaterContent"
data <- mergeData(start_date, end_date, sensor_type)

df<-calculateLayerWater(data)
<<<<<<< HEAD:RainShelter Barley/Depth Separation - all sensors/Trial.R

=======
=======
>>>>>>> 57e5deb6739518e7e27abc9553305e225f562a98:RainShelter Barley/Depth Separation/Trial.R

start_date <-'2014-11-05'
end_date <- '2014-11-30'
sensor_type <- "VolumetricWaterContent"
data <- mergeData(start_date, end_date, sensor_type)

df<-calculateProfileWater(data)
<<<<<<< HEAD:RainShelter Barley/Depth Separation - all sensors/Trial.R

=======
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
>>>>>>> 57e5deb6739518e7e27abc9553305e225f562a98:RainShelter Barley/Depth Separation/Trial.R


  
profile_water <- data %>% 
    mutate(layerwater= ifelse(depth=='D1I', value*150, 
                            ifelse(depth=='D1B', value*150,
                                   ifelse(depth=='D2', value*150, value*300)))) %>%
  group_by(Time, Group, depth) %>%
    summarise(avg=mean(layerwater, na.rm=TRUE))


ggplot(profile_water)+
  geom_line(aes(x=Time, y=avg, colour=Group, group=Group))+
<<<<<<< HEAD:RainShelter Barley/Depth Separation - all sensors/Trial.R
    facet_wrap(~ depth, ncol=2, scales="free_y")+
    ylab("Layer Water (mm)")
    facet_wrap(~ depth, ncol=2, scales="free_y")

=======
<<<<<<< HEAD
    facet_wrap(~ depth, ncol=2, scales="free_y")+
    ylab("Layer Water (mm)")
=======
    facet_wrap(~ depth, ncol=2, scales="free_y")
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
>>>>>>> 57e5deb6739518e7e27abc9553305e225f562a98:RainShelter Barley/Depth Separation/Trial.R

