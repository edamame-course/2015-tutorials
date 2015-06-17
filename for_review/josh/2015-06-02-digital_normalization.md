---
title: Digital normalization for metagenome sequence data
layout: post
date: null
category: tutorial
tags: []
---

# Getting started
We'll start using the files we generated in the previous step (quality trimming step).  Here's where we're going to be running a program for a while (how long depends on the amount of memory your computer has and how large your data set is).  

Since this process can take a while and is prone to issues with remote computing (internet cutting out, etc.) make sure you're running in `screen` or `tmux` when connecting to your EC2 instance!

# Run a First Round of Digital Normalization
Normalize everything to a coverage of 20, starting with the (more valuable) PE reads; keep pairs using '-p'

```
python /usr/local/share/khmer/scripts/normalize-by-median.py -k 20 -C 20 -N 4 -x 1e9 -s normC20k20.kh CentraliaMG_7GB.qc.fastq
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
Now that we've eliminated many more erroneous k-mers from the dataset, let's ditch some more high-coverage data.

We will first normalize the reads:

```
python /usr/local/share/khmer/scripts/normalize-by-median.py -C 5 --savetable normC5k20.kh *.fastq.gz.keep.abundfilt
```

Now, we'll have a file (or list of files if you're using your own data) which will have the name: `{your-file}.fastq.gz.keep.abundfilt.keep`.  We're going to check the file integrity to make sure it's not faulty and we're going to clean up the names.

Let's rename your files:
```
mv {your-file}.fastq.gz.keep.abundfilt.keep {your-file}_single.fastq.gz  
```
These files will be used in the next section where we assemble your metagenomic reads.

##Resources
[khmer documentation and repo](https://github.com/dib-lab/khmer/blob/master/README.rst)
