install.packages("fbRanks")

library(dplyr)
library(fbRanks)

##Llamamos as nuestro Postwork2 desde URL para que nos genere el dataframe ya antes realizado
source("https://raw.githubusercontent.com/Forever-D14/DataScienceBEDU/main/Sesion02/union_Temporadas.r")

## Con PIPE realizamos una seleccion de nuestra union de temporadas
SmallData <- union_Temporadas %>% select(Date, HomeTeam, AwayTeam, FTHG, FTAG)

##Como la funcion que vamos a ocupar necesita que las columnas se llamen de la siguiente manera
names(SmallData) <- c("date", "home.team", "away.team", "home.score", "away.score")

## Creamos el archivo donde se va a guardar 
write.csv(x = SmallData, file = "soccer.csv", row.names = FALSE)

?create.fbRanks.dataframes

## Creamos la lista de los rankings de los equipos
listasoccer <- create.fbRanks.dataframes("soccer.csv")


##Dentro de esta lista se guardan los datasets de goles y equipos
anotaciones <- listasoccer$scores
equipos <- listasoccer$teams

##Obtenemos las fechas diferentes del dataset
n <- unique(listasoccer$scores$date)

##Creamos ranking con solo las fechas diferentes que obtuvimos
ranking <- rank.teams(scores = anotaciones, teams = equipos, max.date = n[length(n)], min.date = n[1])

?rank.teams

?predict

##Realizamos una prediccion de la ultima fecha, para obtener las probabilidades
x <- predict(object = ranking, date = n[length(n)])
                       