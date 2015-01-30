source('dbconnections.R')

getData <- function(start_date, end_date, sensor_type) {
  
  con <- DBConnection()
  sql_select= paste("Select a.time, a.key, a.value, b.cultivar, b.irrigation, b.depth, b.plot from (Select time as time, (each(data)). * from hstorealphadata where time BETWEEN", start_date, "AND", end_date, ") a inner join alphasensorinfo b on a.key=b.sensorid where b.measurement= ", sensor_type, sep=" ")
  data <- dbGetQuery(con, sql_select)
  data$value<-as.numeric(as.character(data$value))
  data$group <-c(paste(data$cultivar, data$irrigation,sep=" "))
  closeDBConnection(con)
  return (data)
} 


calculateFieldCapacity <- function() {
  start_date = "'2014-11-05'"
  end_date = "'2014-11-06'"
  sensor_type ="'VolumetricWaterContent'"
  fc_data <- getData(start_date, end_date, sensor_type)
  
  field_capacity <- calculateProfileWater(fc_data)%>%
    group_by(group, plot)%>%
    summarise(fieldcapacity=max(profilewater, na.rm=TRUE)+40) 
  
  return(field_capacity)
}


calculateProfileWater <- function(data) {
  profile_water<-data %>% 
    mutate(layerwater= ifelse(depth=='D1I', value*150/2, 
                              ifelse(depth=='D1B', value*150/2,
                                     ifelse(depth=='D2', value*150, value*300))))%>%
    group_by(time, group, plot) %>%
    summarise(profilewater=sum(layerwater, na.rm=TRUE))
  return (profile_water)
}

calculateSoilWaterDeficit <- function(data) {
  profile_water <- calculateProfileWater(data)
  field_capacity <- calculateFieldCapacity()  
  soil_water_deficit <- merge(profile_water, field_capacity, by=c('group', 'plot')) %>%
    mutate(soilwaterdeficit = -(fieldcapacity-profilewater))
  return(soil_water_deficit)
}