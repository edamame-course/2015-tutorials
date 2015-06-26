########
### Toy matrix example

# This command clears any data, variables, etc. from the workspace
# Doing this before starting a session helps things run smoothly
rm(list=ls())

# Load and view simple matrix
data=as.matrix(read.table("Table1.txt",header=TRUE,sep="\t",row.names=1))
data

# look at dimensions of matrix and example contents
dim(data)
data[1,]
data[,3]

# Create a presence-absence transformed version of the toy matrix
dataPA=(data>0)*1
dataPA

rich=colSums(dataPA)
rich

# Create a standardized (sample sequence recovery sums to one) version of the toy matrix
# Slow method
dataREL=matrix(0,5,4)
dataREL[,1]=data[,1]/sum(data[,1])
dataREL[,2]=data[,2]/sum(data[,2])
dataREL[,3]=data[,3]/sum(data[,3])
dataREL[,4]=data[,4]/sum(data[,4])

# Faster method using a for loop
dataREL2=data*0
for(i in 1:4){
	dataREL2[,i]=data[,i]/sum(data[,i])
}
dataREL2

colSums(dataREL2)

#transposing a matrix can be useful if running a function that requires the matrix in a particular orientation
dataREL2
t(dataREL2)

# loading the package used for most multivariate analyses
library(vegan)

# calculating pairwise distance matrix
samplePA.dist=vegdist(t(dataPA),method="jaccard")
samplePA.dist

otuPA.dist=vegdist(dataPA,method="jaccard")
otuPA.dist

sampleREL.dist=vegdist(t(dataREL2),method="bray")
sampleREL.dist

# visualization of toy matrix
samplePA.pcoa=cmdscale(samplePA.dist)
samplePA.pcoa

sampleREL.pcoa=cmdscale(sampleREL.dist)
sampleREL.pcoa

#hierarchical clustering
samplePA.clust=hclust(samplePA.dist)
sampleREL.clust=hclust(sampleREL.dist)

plot(samplePA.pcoa[,1],samplePA.pcoa[,2],cex=0,main="PA sample PCOA")
text(samplePA.pcoa[,1],samplePA.pcoa[,2],seq(1,4),cex=1.5)
plot(sampleREL.pcoa[,1],sampleREL.pcoa[,2],cex=0,main="standardized sample PCOA")
text(sampleREL.pcoa[,1],sampleREL.pcoa[,2],xeq(1,4),cex=1.5)
plot(samplePA.clust,main="PA samples")
samplePA.dist
plot(sampleREL.clust,main="standardized samples")
sampleREL.dist

# generate a heatmap of data
heatmap(dataREL2,scale="none",labCol=c('S1','S2','S3','S4'))

########
### Real data, example 1
### LTER - Effects of land-use (AG vs. DF)

# This command clears any data, variables, etc. from the workspace
# Doing this before starting a session helps things run smoothly
rm(list=ls())


# Reads in file, and divides it into two datasets (dimensions are known from original file)
# lter3 - OTU definition set at 97%
# lter10 - OTU definition set at 90%
# Here we are reading in a tab-delimited text file, to read a comma delimited file it would look like:
# lter<-as.matrix(read.table("LTERsoil_otus.txt", sep=",", header=TRUE)
# header=TRUE means that the first row contains names for the variables/samples contained in columns
lter=as.matrix(read.table("LTERsoil_otus.txt", sep="\t", header=TRUE))
lter3=lter[2:302, 1:6]
lter10=lter[2:114, 7:12] 

# This reduces count data to presence-absence data using a True/False statement (lter3>0),
# and creates new matrices to hold the presence-absence data
lter3PA=(lter3>0)*1
lter10PA=(lter10>0)*1

# This creates two new matrices, to hold relative abundance data (about to be calculated)
# Another option for creating these matrices with appropriate dimensions would look like:
# lter3REL=matrix(0, nrow(lter3), ncol(lter3))
lter3REL=lter3
lter10REL=lter10

# This for loop converts all count data to relative abundance data by dividing each count by the total count for that sample
# Note that all data for a sample are contained within a column, if data for samples were in rows it would look like:
# lter3REL[i,]=lter3[i,]/sum(lter3[i,])
for(i in 1:6){
	lter3REL[,i]=lter3[,i]/sum(lter3[,i])
	lter10REL[,i]=lter10[,i]/sum(lter10[,i])
	}

# This calculates a bray-curtis distance matrix (using vegdist) on the transposed (i.e. where samples are in rows, not columns) relative abundance data
# (NB - vegdist can also be used to calulate distance matrices using: Chao, Jaccard, and Euclidean methods)
lter3REL.dist=vegdist(t(lter3REL), method="bray")
lter10REL.dist=vegdist(t(lter10REL), method="bray")

# This calculates PCoA coordinates from the distance matrix (if you want it to return Eigenvalues also the code is: cmdscale(lter3REL.dist, eig=TRUE))
lter3REL.pcoa=cmdscale(lter3REL.dist)
lter10REL.pcoa=cmdscale(lter10REL.dist)

# Here we plot the results from the PCoA (the .pcoa matrix includes both x and y variables)
# cex specifies the magnification of points and text on the plot
# pch specifies the type of point to use (15 = black, filled, squares; 21 = open circles)
# rep(15, 3) specifies that the first 3 pairs of coordinate values should be graphed as filled squares
plot(lter3REL.pcoa, cex=2, pch=c(rep(15,3), rep(21,3)),main="97% OTUs standardized samples PCOA")
legend('bottomleft', c('AG', 'DF'), pch=c(15,21))
plot(lter10REL.pcoa, cex=2, pch=c(rep(15,3), rep(21,3)),main="90% OTUs standardized samples PCOA")
legend('bottomleft', c('AG', 'DF'), pch=c(15,21))

# Here we plot the output from a heirarchical cluster analysis (hclust)
# The default for hclust is to use the 'complete' clustering method which looks for similar clusters (as opposed to compact clusters or minimum tree spread)
plot(hclust(lter3REL.dist),main="97% OTUs standardized samples")
plot(hclust(lter10REL.dist),main="97% OTUs standardized samples")

# This returns the results and scores for a canonical correspondence analysis (CA) on the transposed lter3REL matrix
# cca() returns the Eigenvalues from the CA, while scores() returns the coordinates for each sample as a matrix
lter3REL.ca=cca(t(lter3REL))
lter3REL.sc=scores(lter3REL.ca, display='sites')

plot(lter3REL.pcoa, cex=2, pch=c(rep(15,3), rep(21,3)), xlab="PCOA1", ylab="PCOA2",main="97% OTUs standardized samples PCOA")
legend('topleft', c('AG', 'DF'), pch=c(15,21))
plot(lter3REL.sc[,1], lter3REL.sc[,2], cex=2, pch=c(rep(15,3), rep(21,3)), xlab="CA1", ylab="CA2",main="97% OTUs standardized samples CA")
legend('topleft', c('AG', 'DF'), pch=c(15,21))


# anosim performs an analysis of simliarities on a distance matrix
# The default distance measure is bray-curtis, but other measures (Chao, Jaccard, Euclidean) can be used when specified
# Example specifying distance measure: anosim(lter3REL.dist, grouping=c(rep(1,3), rep(2,3)), distance="euclidean", permutations=1000)
# The grouping argument used here specifies what group (1 or 2) each sample belongs to (here the first 3 samples belong to group 1)
anosim(lter3REL.dist, grouping=c(rep(1,3), rep(2,3)), permutations=1000)
anosim(lter10REL.dist, grouping=c(rep(1,3), rep(2,3)), permutations=1000)

# mrpp performs a multi-response permutation procedure to test for within vs. among group differences
# The default distance measure is euclidean, but other measures (Chao, Jaccard, Bray-Curtis) can be used when specified
mrpp(t(lter3REL), grouping=c(rep(1,3), rep(2,3)), distance="bray", permutations=1000)

# adonis runs a permanova (Created by Marti J. Anderson) this is very similar to ANOVA but for multivariate data. You can make very complex
# experimental designs with it.
# The default distance measure is bray-curtis, but other measures (Chao, Jaccard, Euclidean) can be used when specified
adonis(lter3REL.dist~c(rep(1,3), rep(2,3)), method="bray", permutations=1000)



########
### Real data, example 2
### Centralia data
### Effects of environmental parameters on community composition

rm(list=ls())

#Reading in tables
soils=read.table("otu_table_mc2_w_tax_even4711_CollapseReps_forR.txt",header=TRUE,sep="\t",row.names=1)
#remove the last column, the Consensus Lineage
soils= soils[,-ncol(soils)]
dim(soils)
#24364 18
colSums(soils)
#C01  C02  C03  C04  C05  C06  C07  C08  C09  C10  C11  C12  C13  C14  C15  C16  C17  C18 
#4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 4711 

env=read.table("Centralia_Collapsed_Map_ForR.txt",header=TRUE,sep="\t",row.names=1, check.names=FALSE,stringsAsFactors=FALSE)

colnames(soils)
#[1] "C01" "C02" "C03" "C04" "C05" "C06" "C07" "C08" "C09" "C10" "C11" "C12" "C13" "C14" "C15" "C16" "C17" "C18"

colnames(env)
#[1] "Sample"                 "Replicate"              "Extraction"             "collection_date"       
#[5] "latitude"               "longitude"              "AirTemperature_C"       "SoilTemperature_to10cm"
#[9] "FireFront"              "Classification"         "DateFire_Elick2011"     "OrganicMatter_500"     
#[13] "NO3N_ppm"               "NH4N-ppm"               "pH"                     "SulfateSulfur_ppm"     
#[17] "K_ppm"                  "Ca_ppm"                 "Mg_ppm"                 "Fe_ppm"                

#Relativize dataset
soilsREL=soils
for(i in 1:ncol(soils)){soilsREL[,i]=soils[,i]/sum(soils[,i])}
#Sanity check - column sums should add up to 1
colSums(soilsREL)

#Make resembance matrix
soilsREL.dist=vegdist(t(soilsREL),method="bray")
#Make PCoA and plot
soilsREL.pcoa=cmdscale(soilsREL.dist)
                          
plot(soilsREL.pcoa,cex=0,main="standardized soil samples PCOA")
text(soilsREL.pcoa[,1],soilsREL.pcoa[,2],rownames(soilsREL.pcoa))
#Class=env[,"Classification"]
unique(env$Classification)
Class=rep('black',nrow(env))
Class[env$Classification=="Recovered"]='red'
Class[env$Classification=="Reference"]='green'

plot(soilsREL.pcoa,cex=1.5,pch=16,col=Class,main="standardized soil samples PCOA")
legend('topright',c('Fire Affected','Recovered','Reference'),pch=16,col=c('black','red','green'),box.lty=0)

#Test with ANOSIM
anosim(soilsREL.dist,grouping=Class) 

#Call:
#anosim(dat = soilsREL.dist, grouping = Class) 
#Dissimilarity: bray 
#
#ANOSIM statistic R: 0.3564 
#Significance: 0.002 
#
#Permutation: free
#Number of permutations: 999

#Test for strength and significance of environmental drivers
#reduce env to only measured environmental conditions
env2=as.matrix(env[,c(7,8,12:20)])

EnvCor=cbind(round(cor(env2,soilsREL.pcoa[,1]),2),round(cor(env2,soilsREL.pcoa[,2]),2))
colnames(EnvCor)=c("PCoA1", "PCoA2")
EnvCor
#PCoA1 PCoA2
#AirTemperature_C        0.51  0.09
#SoilTemperature_to10cm  0.74  0.23
#OrganicMatter_500      -0.01 -0.24
#NO3N_ppm                0.38  0.06
#NH4N-ppm                0.37  0.02
#pH                      0.06  0.55
#SulfateSulfur_ppm       0.07  0.32
#K_ppm                   0.08  0.18
#Ca_ppm                 -0.05  0.55
#Mg_ppm                 -0.18  0.33
#Fe_ppm                  0.38 -0.16


soilsEF=envfit(soilsREL.pcoa,env2) 
plot(soilsREL.pcoa,cex=0,main="standardized soil samples PCOA") 
text(soilsREL.pcoa[,1],soilsREL.pcoa[,2],rownames(soilsREL.pcoa)) 
plot(soilsEF)
plot(env2[,"SoilTemperature_to10cm"],soilsREL.pcoa[,1],xlab="Soil Temperature",ylab="PCOA1") 
cor(soilsREL.pcoa[,1],env[,"SoilTemperature_to10cm"])
#[1] 0.7397104


env.dist=vegdist(env2,method="euclidean")
mantel(env.dist,soilsREL.dist)
#Mantel statistic based on Pearson's product-moment correlation 
#Call:
#mantel(xdis = env.dist, ydis = soilsREL.dist) 
#Mantel statistic r: 0.2544 
#      Significance: 0.042 
#Upper quantiles of permutations (null model):
#  90%   95% 97.5%   99% 
#0.205 0.245 0.276 0.330 
#Permutation: free
#Number of permutations: 999


                          


####  Expanded code for generating the correlation table
# Original (compact) code:  round(cor(t(rbind(env, lakesREL.pcoa[,1], lakesREL.pcoa[,2])))[6:7,1:5], 2)
#
# To show what is happening step-by-step we will first look at the innermost nested function
# 
# Step 1: We generate a new matrix that combines our environmental matrix (env) with our PCoA coordinates
# rbind() - combines data by combining rowst
# new.matrix<-rbind(env, lakesREL.pcoa[,1], lakesREL.pcoa[,2])
# 
# Step 2: We transpose this matrix to have the data in the appropriate form for doing a correlation analysis
# new.matrix2<-t(new.matrix) 
#
# Step 3: We do a correlation analysis looking at the relationships among all of the environmental variables and the PCoA coordinates
# cor() returns the R value (not R-squared) of a Pearson correlation
# new.matrix3<-cor(new.matrix2)
#
# Step 4: We are only interested in the correlation between the environmental variables and the PCoA coordinates (not the covariance of environmental variables)
# (In the original code this is nested within the call to the round() function)
# new.matrix4<-new.matrix3[6:7, 1:5]
#
# Step 5: We use the round () function to specify how many decimal places we want to view (in this case, 2)
# round(new.matrix4, 2)
