#Laurent Cesaro
#Date 12/12/2016
#=================================================================================================================
#Code qui permet d'obtenir une table avec le p-values mais avec le nom du paramètre pour le test de Brown Forsythe

#Récupère dans nbCol le nombre de colonnes dans la table
nbCol<-ncol(table)
#Déclare un vecteur NULL où l'on va stocker la valeur de la p-value
resultat<-NULL
#Déclare un vecteur pour stocker le nom de SITE_VLAUE
nameCol<-NULL

#Crée une bouble afin de passer dans chaque colonne de la table
for (i in 5:nbCol){
  # Met dans la variable ble res.bf.test le résultat du test de BF avec 
  # value = table[,i] et groupe = table$SPLIT
  res.bf.test<-bf.test(table[,i],table$SPLIT)
  #Concataine résultat avec la valeur de la p-value
  resultat<-c(resultat,res.bf.test$p.value)
  #Forme un vecteur avec le nom des colonnes
  nameCol<-c(nameCol,names(table[i]))
}

#Créer un nouveau tableau de 2 colonnes 
output<-data.frame(cbind(nameCol,resultat))

#Rename de le nom des colonnes (variables)
names(output)<-c("parametre","pvalue")