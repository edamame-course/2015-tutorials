---
layout: page
title: "Intro to QIIME"
comments: true
date: 2015-04-15 
---

#Intro to QIIME

##Getting started

###Assembling Illumina paired-end sequences

Log on to the EC2 and find the Centralia_16Stag folder. 

This folder contains 52 samples with 30,000 reads each. These are 16S rRNA amplicons sequenced with MiSeq. We will use [PANDAseq](http://www.ncbi.nlm.nih.gov/pubmed/22333067) to assemble the forward and reverse reads.

Use `mkdir` to create a new directory called "pandaseq_merged_reads"
```
mkdir pandaseq_merged_reads
```

####Join paired-end reads with PANDAseq
```
pandaseq –f [forward filename] –r [reverse filename] –A simple_bayesian -B –F –g [log filename *.log.txt] -l 253 -L 253 -o 47 –O 47 -t 0.9 –w > mock_cmty.fasta -g mock_cmty.log 
```
Let's look carefully at the anatomy of this command.

  -  `pandaseq` calls the package of pandaseq scripts.
  -  `-f MiSeq_SOP/F3D0_S188_L001_R1_001.fastq` tells the script where to find the forward read.
  -  `-r` tells the script where to find its matching reverse read.
  -  `-w pandaseq_merged_reads/F3D0_S188.fasta` directs the script to make a new fasta file of the assembled reads and to put it in the "pandaseq_merged_reads" directory.
  -  `-g pandaseq_merged_reads/F3D0_S188.log` Selects an option of creating a log file.
  -  `-L` specifies the maximum length of the assembled reads, which, in truth, should be 251 bp. This is a very important option to specify, otherwise PANDAseq will assemble a lot of crazy-long sequences.

  All of the above information, and more options, are fully described in the [PANDAseq Manual.](http://neufeldserver.uwaterloo.ca/~apmasell/pandaseq_man1.html).  The log file includes details as to how well the merging went.
  
  [sanity check 1 goes here]
  
  ####Subsampling
  As previously mentioned, we have 52 samples with 30,000 reads each. In order to efficiently process these data, we will have to subsample them to 5,000 reads per sample. That means that we will run a program to randomly pick 5,000 sequences from the 30,000 assembled reads.
  
  [subsampling code goes here]
  
  [explanation of subsampling code goes here]
  
  ####Converting FASTQ file to FASTA and QUAL files
  
  We have FASTQ files and will split them into FASTA and QUAL files for further analysis.
  
  ```
  convert_fastaqual_fastq.py -c fastq_to_fastaqual -f seqs.fastq -o fastaqual
  ```
  
  Options for this command can be found on the [QIIME website](http://qiime.org/scripts/convert_fastaqual_fastq.html)
  
  ####Understanding the QIIME mapping file.
QIIME requires a [mapping file](http://qiime.org/documentation/file_formats.html) for most analyses.  This file is important because it links the sample IDs with their metadata (and, with their primers/barcodes if using QIIME for quality-control). 

Let's spend few moments getting to know the mapping file:

```
more Cen_simple_mapping.txt
```

[image of updated mapping file screen shot goes here]

A clear and comprehensive mapping file should contain all of the information that will be used in downstream analyses.  The mapping file includes both categorical (qualitative) and numeric (quantitative) contextual information about a sample. This could include, for example, information about the subject (sex, weight), the experimental treatment, time or spatial location, and all other measured variables (e.g., pH, oxygen, glucose levels). Creating a clear mapping file will provide direction as to appropriate analyses needed to test hypotheses.  Basically, all information for all anticipated analyses should be in the mapping file.

*Hint*:  Mapping files are also a great way to organize all of the data for posterity in the research group.  New lab members interested in repeating the analysis should have all of the required information in the mapping file.  PIs should ask their students to curate and deposit both mapping files and raw data files.

Guidelines for formatting map files:
  - Mapping files should be tab-delimited
  - The first column must be "#SampleIDs" (commented out using the `#`).
  -  SampleIDs are VERY IMPORTANT. Choose wisely! Ideally, a user who did not design the experiment should be able to distiguishes the samples easily, as is the case with the Schloss data. SampleIDs must be alphanumeric characters or periods.  They cannot have underscores.
  - The last column must be "Description".
  - There can be as many in-between columns of contextual data as needed.
  - If you plan to use QIIME for quality control (which we do not need because the PANDAseq merger included QC), the BarcodeSequence and LinkerPrimer sequence columns are also needed, as the second and third columns, respectively.
  - Excel can cause formatting heartache.  See more details [here](misc/QIIMETutorial_Misc/MapFormatExcelHeartAche.md).

  ###Merging assembled reads
  Now that we have FASTA files and are familiar with the mapping file, we are going to merge the FASTA sequences into one big FASTA file and add a label to each sequence from the mapping file. 
  
  ```
  add_qiime_labels.py -m Cent_simple_mapping.txt, -i [option here], -c [option here] 
  ```
  * `-m` is the mapping file 
  * `-i` is the directory of FASTA files to combine and label
  * `-c` is the column from mapping file to take the labels for each sequence from
  Other options on [the QIIME page](http://qiime.org/scripts/add_qiime_labels.html)
  
  
  
  
