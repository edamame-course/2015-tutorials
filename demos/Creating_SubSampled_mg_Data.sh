#! /bin/bash
for file in $(<Whole_FastQ_FileNames.txt) # Whole_FastQ_FileNames.txt is a list of the unzipped metagenome file names.
do
	sudo gunzip /data/MG_ZIPPED/${file}.gz #Here I am unzipping the first metagenome output read which is located in the directory /data/MG_ZIPPED/
	split -l 4000000 /data/MG_ZIPPED/${file} Sample_ #Since the raw metagenome files are so large I need to split them into smaller chunks so I can efficiently subsample them. Split can cut files based on size, or number of lines. I use the -l flag here to tell split to cut my raw reads into smaller files each containing 4 millions lines which is the same as 1 million reads.  
	ls Sample_* > SplitNames.txt #Writing the names of all of the "split" files to a new file.
	
	for item in $(<SplitNames.txt)
	do	
		seqtk sample ${item} 65750 > ${item}_65750.fastq # Sampling 65750 from each of the "split" files.
		rm ${item} #Cleaning up the directory to free up space. Removing the "split" files. 
	done
	
	cat *_65750.fastq > ${file}_2GB.fastq #Combine each of the separately subsampled files for the Sample.
	rm *65750.fastq # Clean up by removing the original subsampled files since we have a single file where we concatenated.
	gzip /data/MG_ZIPPED/${file} #Zip up the raw sequence read. 
done
cat *_2GB.fastq > CentraliaMG_7GB.fastq #Combine each of the Subsampled files of the raw files into one large file. 
