setwd('C:/GitHubRepos/Summer Project - R/RainShelter Barley/Depth Separation')

library(dplyr)
library(ggplot2)
source('datafunctions.R')


start_date <-'2014-11-05'
end_date <- '2014-11-30'
sensor_type <- "VolumetricWaterContent"
data <- mergeData(start_date, end_date, sensor_type)

df<-calculateProfileWater(data)


  
profile_water <- data %>% 
    mutate(layerwater= ifelse(depth=='D1I', value*150, 
                            ifelse(depth=='D1B', value*150,
                                   ifelse(depth=='D2', value*150, value*300)))) %>%
  group_by(Time, Group, depth) %>%
    summarise(avg=mean(layerwater, na.rm=TRUE))


ggplot(profile_water)+
  geom_line(aes(x=Time, y=avg, colour=Group, group=Group))+
    facet_wrap(~ depth, ncol=2, scales="free_y")

