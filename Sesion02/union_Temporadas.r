library(dplyr)
library(lubridate)

setwd("C:/Users/nacho/OneDrive/Documentos/GitHub/DataScienceBEDU/Sesion02/csv")

##Lee los 3 archivos .csv correspondientes a las temporadas 2017/2018, 2018/2019, 2019/2020
##Descargados previamente de https://www.football-data.co.uk/spainm.php

lista <- lapply(dir(), read.csv)

##Estructura de la lista y dataframes
str(lista)
head(lista)

##Seleccionamos en los 3 dataframes las columnas mencionadas
temporadas <- lapply(lista, select, c("Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR"))

##Volvemos a checar estructura para verificar la fecha esta en buen formato
str(temporadas)

##Cambiamos el formato de caracter a fecha en Date
temporadas <- lapply(temporadas, mutate, Date = as.Date(Date, "%d/%m/%Y"))

##Ahora podemos ver que si es fecha
str(temporadas)

##Unimos los dataframes en uno solo
union_Temporadas <- do.call(rbind,temporadas)

print(union_Temporadas)

##Pudimos notar que el primer dataframe su formato fue mal puesto ya que en lugar de poner 2017 solo esta el 17, 
##Entonces para tener todos nuestros registros con el mismo formato vamos a cambiarle para que este bien de la siguiente manera
year(union_Temporadas$Date[year(union_Temporadas$Date)==17]) <- 2017
year(union_Temporadas$Date[year(union_Temporadas$Date)==18]) <- 2018

print(union_Temporadas)
