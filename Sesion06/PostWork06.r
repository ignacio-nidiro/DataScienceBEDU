library(dplyr)
 
data <- read.csv("https://raw.githubusercontent.com/Forever-D14/DataScienceBEDU/main/Sesion06/match.data.csv")

##SUMAMOS LOS GOLES DEL VISITANTE CON LOS DEL LOCAL POR CADA PARTIDO
data <- data %>% mutate(sumagoles = home.score + away.score)

##AGRUPAMOS POR MES Y POR AÑO Y LUEGO SUMAMOS LOS GOLES TOTALES DIARIOS
agrupamiento <- data %>% 
          group_by(year(date),month(date)) %>%
          summarise(Mensual = mean(sumagoles))

##GENERAMOS LA SERIE DE TIEMPO, EMPEZANDO EN AGOSTO DE 2010 Y TERMINA EN DICIEMBRE 2019
golesMensuales.ts <- ts(agrupamiento$Mensual,start = c(2010,08), end = c(2019,12), frequency = 12)
?as.Date
str(golesMensuales.ts)

#PLOTEAMOS
plot(golesMensuales.ts, 
     main = "Promedio de Goles por Mes", 
     xlab = "Tiempo",
     sub = "Agosto de 2010 - Diciembre de 2019")
