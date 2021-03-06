# Sélectionner plusieurs éléments

## Joindre des dataframes qui commencent par df
mget(ls(pattern="^df\\.\\d+")) %>%
              bind_rows()

## Mettre des valeurs disparates dans un df
tibble::enframe(mget(ls(pattern = "^Nombre")))

## Regrouper les csv en un seul df en créant une colonne avec le nom
 AppendMe <- function(dfNames) {
  do.call(rbind, lapply(dfNames, function(x) {
    cbind(get(x), departement = x)
  }))
}                
 TauxBruts<-AppendMe(c("D75_tb", "D77_tb","D78_tb",
                      "D91_tb", "D92_tb","D93_tb",
                      "D94_tb", "D95_tb","D60_tb","idf_tb","france_tb"))
             
## Sélectionner des colonnes dont le nom est dans une lsite.
desired_columns<-c("coucou","bonjour")
extract_columns <- function(data) {
    extracted_data <- data %>%
        select_(.dots = desired_columns)
    return(extracted_data)
}
extract_columns(jeudedonneesaveclescolonnescoucouetbonjouretautrechose)
extract_columns(df)


# Côté cartographie

## Extraire une geometry
aaa_coords <- do.call(rbind, st_geometry(aaa)) %>% 
  as_tibble() %>% setNames(c("lon","lat"))

## Crop polygones selon coord
st_intersection(subdivisions, st_set_crs(st_as_sf(as(raster::extent(-20, 40,20, 70), "SpatialPolygons")), st_crs(subdivisions)))
               
## From geometry to lat long
st_x = function(x) st_coordinates(x)[,2]
st_y = function(x) st_coordinates(x)[,1]
SF%>%mutate(centre=st_centroid(geometry),
                            latitude=st_x(centre),
                            longitude=st_y(centre))

## Cropping on Mapshaper
mapshaper -clip bbox=1.4473,48.1205,3.5557,49.2374 

## Ne garder que l'exlusion entre deux polygones
CommunessansParcs<-st_difference(Communes,st_union(PasParis))

## Delaunay triangle
vtess=deldir(Geo_2018_centroids$longitude,Geo_2018_centroids$latitude)
tl = triang.list(vtess)
polys = SpatialPolygons(
  lapply(1:length(tl),
         function(i){
           Polygons(
             list(
               Polygon(tl[[i]][c(1:3,1),c("x","y")])
             ),ID=i)
         }
  )
)

polys_sf<-st_as_sf(polys)
polys_sf%>%ggplot()+geom_sf(colour="red")  
  
# Côté graphiques

## Reorder ggplot bar
group_by(Pays)%>%
  mutate(TotalVente=sum(KgParMillionDHectares,na.rm=T))%>%
  ungroup()%>%
  mutate(Pays=fct_reorder(Pays,TotalVente))%>%
  ...

## Limiter la largeur des textes dans une facet
facet_wrap(~ grp, labeller = label_wrap_gen(width=10))
                
## Légende sur deux lignes
guides(fill=guide_legend(nrow=2,byrow=TRUE))
                
## Légende plus large
guides(fill = guide_colourbar(barwidth = 20, barheight = 3))

## Plus de clés dans la légende
  scale_fill_viridis_c(option = "inferno",    breaks = c(0, 1, 3, 6,20,25,30),    guide = guide_legend()  ) 

# Divers

## changer le mode scientifique de l'écriture
options(scipen=999)

## Créer Jpeg
jpeg(filename = "GNAGNA.jpg", width=624, height = 450, quality=100, units = "px",type="cairo")
dev.off()
          
## Calculer un âge entre deux périodes
library(lubridate)
get_age <- function(from_date,to_date = lubridate::now(),dec = FALSE){
  if(is.character(from_date)) from_date <- lubridate::as_date(from_date)
  if(is.character(to_date))   to_date   <- lubridate::as_date(to_date)
  if (dec) { age <- lubridate::interval(start = from_date, end = to_date)/(lubridate::days(365)+lubridate::hours(6))
  } else   { age <- lubridate::year(lubridate::as.period(lubridate::interval(start = from_date, end = to_date)))}
  age
}

# Manipulation de données

## Faire la somme des colonnes qui commencent par XXX
Paris$A2014 <- Paris %>% 
  select(starts_with("2014")) %>% 
  rowSums()

## dédoublonner
verfi1<-verifdedoublon[!duplicated(verifdedoublon), ]


## Compter selon conditions
coucou%>%
mutate(count4 = length(value[week<=2]),
       sum2 = sum(value[week<=2]))

## Compter les NA dans chaque colonne
Data%>%
purrr::map_df(~.sum(is.na(.)))

## Transformer en NA les ""
Data%>%
na_if("")%>%
count(Variable)

## Examiner les colonnes numériques
data%>%
select_if(is.numeric)%>%
skimr::slengkim()

## Toutchanger 
mtcars %>%
  mutate_all(as.character)                 

## Si plusieurs éléments par ligne, pour spliter, compter et trier par nombre
data%>%
mutate(nouvelleentite=str_split(entiteavecvirgule,","))%>%
select(nouvelleentite)%>%
unnest()%>%
count(nouvelleentite)%>%
mutate(nouvelleentite = forcats::fct_reorder(nouvelleentite,n))
                  
## Reshape
aql <- reshape2::melt(airquality, id.vars = c("month", "day"),   variable.name = "climate_variable",    value.name = "climate_value") 

## taux devol
evol <- function(x) {(last(x) - first(x)) / first(x) * 100 }
Pourevolution%>%
  group_by(insee_comm,variable)%>%
  filter(!is.na(valeur))%>%
  filter(!is.na(insee_comm))%>%
  arrange(insee_comm,variable,annee) %>%
  summarise_at(.vars = "valeur", .funs = evol)


 ## Creation dataframe avec dimesions fixes 
data.frame(matrix(NA, nrow = 2, ncol = 3))

## Not in
`%!in%` = function(x,y) !(x %in% y)
         
## Transformer les facteurs en caractères
mutate_if(is.factor, as.character)
        
mtcars %>%
  mutate_all(as.character)
                
##Remplacer les trous

a<-c("1000",NA,"1000",NA)
b<-c("mille","millions","mille","sabords")
coalesce(a,b)
ifelse(is.na(a), b,a)

      
## Sortie en csv avec probleme d'encode list
df <- apply(tempfile,2,as.character)
write.csv(df,"file.csv",fileEncoding = "UTF-8",row.names = F)

## Créeer une bloucle for qui ne s'interrompt pas à chaque erreur
for (i in 1:10) {
  tryCatch({
    print(i)
    if (i==7) stop("Urgh, the iphone is in the blender !")
  }, error=function(e){})
}

     
## Changer le nom de colonnes selon un autre tableau
names(df) <- name$NomComplet[match(names(df), name$Short)]

## Changer le nombre de caractères tronqués dans la console.
glue_collapse(DF$LongString, width = 1000)

