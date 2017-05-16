#Laurent Cesaro
#Date 10/01/2017

#Création table de pivot

#Met les valeurs manquantes dans la variable input_na_omit
input_na_omit <- na.omit(input)


colname <- names(input_na_omit)
#Met dans une variable les colonnes qui seront inutiles
coldrop <- colname[-c(1,3,4,11,12,13)]

#Crée la table de pivot avec la fonction reshape
pvtable<-reshape(input_na_omit, direction = "wide", v.names = "Bin_calc",
                 timevar = "Bin_Type_calc", idvar = c("LOT_ID","WAFER_NO","SPLIT","Yield_calc"),
                 drop = coldrop)

#rename column without Bin_calc.
names(pvtable) <- gsub("Bin_calc.","",names(pvtable))

#fill NA cells with 0
pvtable[is.na(pvtable)] <- 0