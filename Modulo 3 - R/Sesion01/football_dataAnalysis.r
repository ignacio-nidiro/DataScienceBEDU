library(tidyverse)
library(dplyr)
setwd("C:/DataScienceBEDU/Postworks/Sesion01")

prob_Goal <- function(team_Table){
  ##Anexamos una nueva columna que sera la suma de los partidos en donde metio 1 o mas goles y la llamamos Anotado
  team_Table <- cbind(team_Table, Anotado = rowSums(team_Table[,-1]))
  
  ##Ocuparemos la tranpuesta de la tabla para poder obtener la probabilidad con "prop.table"
  team_Table <- t(team_Table[,c("0","Anotado")])
  
  ##OBTENEMOS PROBABILIDAD DE CADA UNO DE LOS EQUIPOS COMO VISITANTE DE METER GOL 
  probs <- apply(team_Table, 2, prop.table)
  
  ##Ahora ya teniendo las probabilidades simples de cada equipo en nuestra tabla auxiliar
  ##vamos a acomodar la tabla para que cada equipo tenga su probabilidad junta y sea intuitivo,
  ##por lo que agregamos como fila la ultima parte de la tabla auxiliar generada, ya que cuando se termine el for
  ##tendremos una tabla el doble de grande, si la partimos por la mitas y la empatamos nos queda bien ordenado.
  ##Como habiamos transpuesto la tabla ahora vamos a revertir el proceso y listo
  final <- t(rbind(team_Table ,probs)) 
  
  return(final)
}


spain_Soccer2021 <- read.csv("SP1.csv")

spain_Score <- spain_Soccer2021[,c("HomeTeam","AwayTeam","FTHG","FTAG")]
View(spain_Score)


############
##VISITANTES
############
##Creamos tabla reducida con nombres como Filas y la cantidad de goles por partido de columnas
##El contenido de la tabla hace referencia a las veces que haya anotado esa cantidad de goles en cada partido
##Osea si en solo un partido de toda la temporada metio 6 goles, ese equipo en la columna 6 tendrÃ¡ un 1.
awayTeam_table <- table(spain_Score$AwayTeam,spain_Score$FTAG)

homeTeam_table <- table(spain_Score$HomeTeam,spain_Score$FTHG)

probs_AwayTeam <- prob_Goal(awayTeam_table)
##Nombramos las columnas para saber a que se refiere cada una
##No Anotado V : Veces en las que el equipó no metio goles en un partido siendo visitante
##Anotado V: Veces en las que el equipo metio 1 o más goles siendo visitante
##Prob NoA V : Probabilidad de No anotar goles siendo Visitante
##Prob A V: Probabilidad de anotar goles siendo visitante
colnames(probs_AwayTeam) <- c("No Anotado V","Anotado V", "Prob NoA V", "Prob A V")

probs_HomeTeam <- prob_Goal(homeTeam_table)
##Nombramos las columnas para saber a que se refiere cada una
##No Anotado V : Veces en las que el equipó no metio goles en un partido siendo local
##Anotado V: Veces en las que el equipo metio 1 o más goles siendo local
##Prob NoA V : Probabilidad de No anotar goles siendo local
##Prob A V: Probabilidad de anotar goles siendo local
colnames(probs_HomeTeam) <- c("No Anotado L","Anotado L", "Prob NoA L", "Prob A L")

#######
###PROBABILIDAD CONJUNTA 
######
###Se obtiene de multiplicar ambas probabilidades 

spain_Score <- mutate(spain_Score, 
                      Prob_Local_Goal = probs_HomeTeam[spain_Score$HomeTeam, "Prob A L"],
                      Prob_Visitante_Goal = probs_AwayTeam[spain_Score$AwayTeam, "Prob A V"])

spain_final_probabilities <- mutate(spain_Score,Prob_Conjunta = spain_Score$Prob_Local_Goal * spain_Score$Prob_Visitante_Goal)
print(spain_final_probabilities)


