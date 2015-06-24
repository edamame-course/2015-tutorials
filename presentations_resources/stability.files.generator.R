# This scipt takes a shell-generated list of .fastq file names and makes a data frame that matches samples with a pair of forward+reverse reads

# it will write it as "stability.files" file that can be piped right into mothur

library("stringr")
library("plyr")
#library("reshape2")


# INSERT THE NAME OF YOUR DIRECTORY WITH FASTQ FILES BELOW
# this is the only step you need to edit
setwd("")

filenames <- system("ls *fastq*", intern=T)

forward="F"
reverse="R"

R1_idx <- grep(forward, filenames)
R1_files <- filenames[R1_idx]

R2_idx <- grep(reverse, filenames)
R2_files <- filenames[R2_idx]

filenames.fin <- data.frame(R1_files, R2_files)

stability.files <- data.frame(group=ldply(str_split(filenames.fin[,1], "_"))$V1, filenames.fin)

write.table(stability.files, "stability.files", sep = "\t", row.names=F, col.names=F, quote=F)


