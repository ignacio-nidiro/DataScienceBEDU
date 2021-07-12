library(mongolite)

match <- mongo(collection = "match",
               db = "match_games", 
               url = "mongodb+srv://totopo:twip9suw8GAUH_krup@cluster0.ae9wx.mongodb.net/test?authSource=admin&replicaSet=atlas-lpbwf9-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true")

print(paste("El numero de registros de la base de datos es : ", match$count()))

## Real Madrid el 20/Dic/2015, el equipo contrario y marcador 

match$find(query = '{"home.team": "Real Madrid", "date": "2015-12-20"}')

##Podemos darnos cuenta de que el Real Madrid goleo al Vallecano 
##ganando el partido con una diferencia de 8 goles (Resultado final : 10-2)

match$disconnect()

