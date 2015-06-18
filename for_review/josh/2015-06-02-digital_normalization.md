---
title: Digital normalization for metagenome sequence data
layout: post
date: null
category: tutorial
tags: []
---
Authored by Joshua Herr with contribution from Ashley Shade and Jackson Sorensen for EDAMAME2015     

[EDAMAME-2015 wiki](https://github.com/edamame-course/2015-tutorials/wiki)

***
EDAMAME tutorials have a CC-BY [license](https://github.com/edamame-course/2015-tutorials/blob/master/LICENSE.md). _Share, adapt, and attribute please!_
***

##Overarching Goal  
* This tutorial will contribute towards an understanding of **metagenome analysis**

##Learning Objectives
* Use digital normalization to remove excess data
* Trim/Filter out errors from sequences by identifying low coverage kmers in high coverage areas

***

# Getting started
We'll start using the files we generated in the previous step (quality trimming step).  Here's where we're going to be running a program for a while (how long depends on the amount of memory your computer has and how large your data set is).  

Since this process can take a while and is prone to issues with remote computing (internet cutting out, etc.) make sure you're running in `screen` or `tmux` when connecting to your EC2 instance!

# Run a First Round of Digital Normalization
Normalize everything to a coverage of 20. The normalize-by-media.py script keeps track of the number of times a particular kmer is present. The flag `-C` sets a median kmer coverage cutoff for sequence. In otherwords, if the median coverage of the kmers in a particular sequence is above this cutoff then the sequence is discarded, if it is below this cutoff then it is kept. We specify the length of kmer we want to analyze using the `-k` flag. The flags `-N` and `-x` work together to specify the amount of memory to be used by the program. As a rule of thumb, the two multiplied should be equal to the available memory(RAM) on your machine. You can check the available memory on your machine with `free -m`. For our m3.large instances we should typically have about 4GB of RAM free.    

```
python /usr/local/share/khmer/scripts/normalize-by-median.py -k 20 -C 20 -N 4 -x 1e9 -s normC20k20.kh *qc.fastq
```

Make sure you read the manual for this script, it's part of the [khmer](https://github.com/ged-lab/khmer) package.  This script produces a set of '.keep' files, as well as a normC20k20.kh database file.  The database file (it's a hash table in this case) can get quite large so keep in ming when you are running this script on a lot of data with not a lot of free space on your computer.

# Removing Errors from our data
We'll use the `filter-abund.py` script to trim off any k-mers that are in abundance of 1 in high-coverage reads.

```
python /usr/local/share/khmer/scripts/filter-abund.py -V normC20k20.kh *.keep
```

The output from this step produces files ending in `.abundfilt` that contain the trimmed sequences.

If you read the manual, you see that the `-V` option is used to make this work better for variable coverage data sets, such as those you would find in metagenomic sequencing.  If you're using this tool for a genome sequencing project, you wouldn't use the `-V` flag.

# Normalize down to a coverage of five
Now that we've eliminated many more erroneous k-mers from the dataset, let's ditch some more high-coverage data. Normalize down to a coverage of five using the following command. Note that here we are loading the count table from the first round of digital normalization and normalizing our error filtered data from the filter-abund.py step. 

```
python /usr/local/share/khmer/scripts/normalize-by-median.py -x 1e09 -C 5 -s normC5k20.kh -l normC20k20.kh *qc.fastq.keep.abundfilt
```

Now, we'll have a file (or list of files if you're using your own data) which will have the name: `{your-file}.qc.fastq.keep.abundfilt.keep`.  We're going to check the file integrity to make sure it's not faulty and we're going to clean up the names.

Let's rename your files:
```
mv {your-file}.qc.fastq.keep.abundfilt.keep {your-file}_single.fastq  
```
These files will be used in the next section where we assemble your metagenomic reads.

##Help and other Resources
* [khmer documentation and repo](https://github.com/dib-lab/khmer/blob/master/README.rst)
* [khmer protocols - see "Kalamazoo Protocol"](http://khmer-protocols.readthedocs.org/en/v0.8.4/)
* [khmer recipes - bite-sized tasks using khmer scripts](http://khmer-recipes.readthedocs.org/en/latest/)
* [khmer discussion group](http://lists.idyll.org/listinfo/khmer)

