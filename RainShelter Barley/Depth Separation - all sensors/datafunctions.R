source('dbconnections.R')
library(dplyr)


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


allSensorInfo <- function (){
  con <- DBConnection()
  sensor_info <- dbReadTable(con, "alphasensorinfo")
  sensor_info$sensorid <- chartr("(),", "...", sensor_info$sensorid)
  closeDBConnection(con)
  return(sensor_info)
}

sensorList <-function () {
  sensor_list<- allSensorInfo()%>%
    select(measurement)%>%
    distinct()
  return (sensor_list)
}

list <-sensorList()
class(list$measurement)

mergeData <- function (start_date, end_date, sensor_type) {
  subset_data <- allData() %>%
    filter(Time >= as.POSIXct(start_date) & Time < as.POSIXct(end_date))%>%
    gather("sensorid", "value", RECORD:CS650.192.6.)
  subset_sensorinfo <- allSensorInfo()%>%
    filter(measurement==sensor_type)
  merge_data <- merge(subset_data, subset_sensorinfo, by=c('sensorid'))%>%
    select(Time, value, cultivar, irrigation, depth, plot)
  merge_data$Group <-c(paste(merge_data$cultivar, merge_data$irrigation,sep=" "))
  merge_data$value<-as.numeric(as.character(merge_data$value))
  return (merge_data)
  
}

calculateFieldCapacity <- function(){
  start_date = '2014-11-05'
  end_date = '2014-11-06'
  sensor_type ="VolumetricWaterContent"
  fc_data <- mergeData(start_date, end_date, sensor_type)
  
  field_capacity <- calculateProfileWater(fc_data)%>%
    group_by(Group, plot)%>%
    summarise(fieldcapacity=max(profilewater, na.rm=TRUE)+40) 
  
  return(field_capacity)
}


<<<<<<< HEAD:RainShelter Barley/Depth Separation - all sensors/datafunctions.R

=======
<<<<<<< HEAD
>>>>>>> 57e5deb6739518e7e27abc9553305e225f562a98:RainShelter Barley/Depth Separation/datafunctions.R
calculateLayerWater <- function(data) {
  layer_water<-data %>% 
    mutate(layerwater= ifelse(depth=='D1I', value*150/2, 
                              ifelse(depth=='D1B', value*150/2,
                                     ifelse(depth=='D2', value*150, value*300)))) %>%
  group_by(Time, Group, depth) 

  return(layer_water)
<<<<<<< HEAD:RainShelter Barley/Depth Separation - all sensors/datafunctions.R
}
=======
=======
calculateProfileWater <- function(data) {
  profile_water<-data %>% 
    mutate(layerwater= ifelse(depth=='D1I', value*150/2, 
                              ifelse(depth=='D1B', value*150/2,
                                     ifelse(depth=='D2', value*150, value*300))))%>%
                                group_by(Time, Group, depth) %>%
                                  summarise(profilewater=mean(layerwater, na.rm=TRUE))
  
  return(profile_water)
>>>>>>> 95d89e4280bdbbc3b1b6b55986b18c025e85c997
>>>>>>> 57e5deb6739518e7e27abc9553305e225f562a98:RainShelter Barley/Depth Separation/datafunctions.R

calculateProfileWater <- function(data) {
  profile_water<-data %>% 
    mutate(layerwater= ifelse(depth=='D1I', value*150/2, 
                              ifelse(depth=='D1B', value*150/2,
                                     ifelse(depth=='D2', value*150, value*300))))%>%
                                group_by(Time, Group, depth) %>%
                                  summarise(profilewater=mean(layerwater, na.rm=TRUE))
  
  return(profile_water)
}

calculateSoilWaterDeficit <- function(data) {
  profile_water <- calculateProfileWater(data)
  field_capacity <- calculateFieldCapacity()  
  soil_water_deficit <- merge(profile_water, field_capacity, by=c('Group', 'plot')) %>%
    mutate(soilwaterdeficit = -(fieldcapacity-profilewater))
  return(soil_water_deficit)
}

