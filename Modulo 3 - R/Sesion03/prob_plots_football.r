library(ggplot2)
library(plotly)

##Ocuparemos la funcion creada en el postWork 
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

##Cargamos el postwork 2 ya que con ese dataframe vamos a trabajar
source("C:/DataScienceBEDU/PostWorks/Sesion02/union_Temporadas.r")

####################################################################
##Todo esto es lo mismo que realizamos en el postwork 1, solo que ahora
##con el nuevo dataframe obtenido en el postWork2

homeTeam <- table(union_Temporadas$HomeTeam, union_Temporadas$FTHG)
awayTeam <- table(union_Temporadas$AwayTeam, union_Temporadas$FTAG)


prob_HomeTeam <- prob_Goal(homeTeam)
prob_AwayTeam <- prob_Goal(awayTeam)

colnames(prob_HomeTeam) <- c("No Anotado L","Anotado L", "Prob NoA L", "Prob A L")
colnames(prob_AwayTeam) <- c("No Anotado V","Anotado V", "Prob NoA V", "Prob A V")

union_Score <- mutate(union_Temporadas, 
                      Prob_Local_Goal = prob_HomeTeam[union_Temporadas$HomeTeam, "Prob A L"],
                      Prob_Visitante_Goal = prob_AwayTeam[union_Temporadas$AwayTeam, "Prob A V"])

union_final_probabilities <- mutate(union_Score,Prob_Conjunta = union_Score$Prob_Local_Goal * union_Score$Prob_Visitante_Goal)
###########################################################################

local_plot <- ggplot(union_final_probabilities, aes(x = HomeTeam, y = Prob_Local_Goal, fill = HomeTeam)) +
              geom_bar(stat = 'identity') +
              ggtitle("Probabilidades de Goal Local") +
              xlab("Equipo") +
              ylab("Probabilidad") +
              theme_dark() + 
              theme(axis.text.x = element_text(face = "bold", color="#0a7c93" , 
                                               size = 10, angle = 45, 
                                                hjust = 1),
                    axis.text.y = element_text(face = "bold", color = "#0a7c93"),
                    legend.position = "none")
                    

away_plot <- ggplot(union_final_probabilities, aes(x = AwayTeam, y = Prob_Visitante_Goal)) +
             geom_bar(stat = 'identity') +
             ggtitle("Probabilidades de Goal Visitante") +
             xlab("Equipo") +
             ylab("Probabilidad") +
             theme_dark() + 
             theme(axis.text.x = element_text(face = "bold", color="#0a7c93" , 
                                   size = 10, angle = 45, 
                                   hjust = 1),
                  axis.text.y = element_text(face = "bold", color = "#0a7c93"),
                  legend.position = "none")

conjunta_plot <- ggplot(union_final_probabilities, aes(x = HomeTeam, y = AwayTeam, fill = Prob_Conjunta)) +
                geom_tile() +
                ggtitle("Probabilidad Conjunta De Goal") + 
                scale_fill_viridis_c() + 
                theme(axis.text.x = element_text(face = "bold", color="#0a7c93" , 
                                   size = 10, angle = 45, 
                                   hjust = 1),
                      axis.text.y = element_text(face = "bold", color = "#0a7c93"))

conjunta_Matrix <- table(union_final_probabilities$HomeTeam,union_final_probabilities$AwayTeam)

View(union_final_probabilities)
