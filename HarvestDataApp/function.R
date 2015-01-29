library(dplyr)
library(lubridate)

#create database connection
DBConnection <- function(){
  library(RPostgreSQL)
  drv <- dbDriver("PostgreSQL")
  creds <- scan('C:Users/cflhxk/Dropbox/Hymmi_Summer2014/KiwifruitDBLogin.txt',what='character',sep=",")
  con <- dbConnect(drv, host='aklpdb22.pfr.co.nz', port='5432', dbname='kiwifruitdatadev',user=creds[[1]], password=creds[[2]])
  return(con)
}

#retrieve all data from table HarvestData_2014
Read_Table <- function(){
  con <- DBConnection()
  dt <- dbReadTable(con,"HarvestData_2014")
  dt <- dt %>% mutate(HvDate=(parse_date_time(HvDate, "dmy")))
  return(dt)
}

#retrieve data list from column species from alldata
SearchSpecies <- function(){
  AllData() %>% 
    select(Species) %>%
      distinct()
}

FF_Data <- function(week,MeanFF) {
  colStr <- paste('X',week,'.wk.Frt',sep="")
  
  df<- AllData() %>%
    select (UID, ID,HvDate, contains(colStr)) %>%
    gather(var,val,-UID,-ID,-HvDate) %>%
    separate(col=var,into=c('Frt','Flat_Edge'),sep='_') %>%
    mutate(Frt =gsub("^.*\\.","",Frt)) %>%
    mutate(Frt =gsub("Frt","",Frt)) %>%
    mutate(Flat_Edge=gsub('FF',"",Flat_Edge)) %>%
    arrange(UID)
    
    if (MeanFF==TRUE)
    {df <- df %>%
        group_by(UID)%>%
        summarise(MeanFF=mean(val))
    }
  return(df)
}