#! /bin/bash
for file in $(<Whole_FastQ_FileNames.txt)
do
	sudo gunzip /data/MG_ZIPPED/${file}.gz
	split -l 4000000 /data/MG_ZIPPED/${file} Sample_
	ls Sample_* > SplitNames.txt
	
	for item in $(<SplitNames.txt)
	do	
		seqtk sample ${item} 65750 > ${item}_65750.fastq
		rm ${item}
	done
	
	cat *_65750.fastq > ${file}_2GB.fastq
	rm *65750.fastq
	gzip /data/MG_ZIPPED/${file}
done
cat *_2GB.fastq > CentraliaMG_7GB.fastq
