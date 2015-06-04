---
title: Assembling your metagenome
layout: post
date: 2015-06
category: metagenomics
tags: []
---

# Assembling your metagenome

## A little background on assembly

Ok, so we've just spent a little while quality checking, quality trimming, normalizing, and (possibly, but probably not) partitioning and it's time to get some results -- we're going to assemble our reads into longer contigs and (hopefully!) entire bacterial and archaeal genomes

**Disclaimer:** Assembling metagenomes is really difficult and fraught with confounding issues.  It was only a few years ago that this was first done for a very simple community that [resulted in a paper in Science](http://www.sciencemag.org/content/335/6068/587.abstract)).  You're entering treacherous territory and there will be a lot of time spent assessing your output each step of the way.  

First, there are many, many options for assembling metagenomic data.  Most assemblers ([Velvet](http://www.ebi.ac.uk/~zerbino/velvet/), [IDBA](https://code.google.com/p/hku-idba/), [SPAdes](http://bioinf.spbau.ru/spades/)) that work well on genomic data can just as easily be used for metagenomic data, but since they were designed for use on single organisms, they might not be the best choice when you have many (to potentially thousands of) organisms which share genomic signatures.  It's difficult enough to get a good genome assembly from a pure culture of a single organism -- let alone many organisms not sequenced to the depth you need.

We've gone to the trouble of installing some assembly programs to the EDAMAME [ami](), so feel free to experiment in your free time with other assemblers.  We'll be using a *newish* assembler, Megahit ([program](https://github.com/voutcn/megahit) and [paper](http://bioinformatics.oxfordjournals.org/content/31/10/1674.long)), which has a couple of benefits for us.  One, the assembler is optimized for (i.e. designed to handle) metagenomic reads, and two, it's pretty fast (when compared to other assemblers (i.e. SPAdes) that provide good results on metagenomic data in addition to metagenomic data).

## Preparing the Data

Each assembler program takes data input in slightly different formats.  Velvet is the most flexible: it can take in paired-end and/or single reads, in FASTA or FASTQ format, gzipped or not.  On the other hand, SPADes requires paired-end FASTQ, while IDBA requires paired-end FASTA.  Make sure you always spend time reading the manual of a program first.

Since we're going to use megahit, which takes single-end reads (in this case we have disregarded the paired-end metagenomic data and combined the paired reads into a single file -- yes, this throws out some of the information you get from having paired reads), we want our data in a single file as the input.  We've been running our data as single end from the start, but you should know that if you have paired end data and you want to utilize the information from the pairs you'll have to plan accordingly.

## Running megahit

First read the [megahit manual here](https://github.com/voutcn/megahit).  The paper can be found here: [Li et al. 2015 MEGAHIT: an ultra-fast single-node solution for large and complex metagenomics assembly via succinct de Bruijn graph](http://bioinformatics.oxfordjournals.org/content/31/10/1674.abstract).

You'll want to read the (minimal) manual first, but we're going to use a couple of flags:
  1. We have to set the memory you will use in the analysis, I suggest for our case to use `-m 0.9` which means we'll use 90% of the available CPU memory.  You don't want to use 100% or your computer will not be able to run essential operations.
  2. Megahit requires us to set the length of the reads that will be ignored.  Just to be safe I have used `-l 500` here, but change it and see if it changes your assembly.  I would not go below your average read length.

Taking that into consideration, we're going to run this code:

```
megahit -m 0.9 -l 500 --cpu-only -r pooled_trim.fastq.keep.abundfilt.keep -o megahit_assembly
```

You should slowly see something similar to the following output:

```
23.0Gb memory in total.
Using: 21.112Gb.
MEGAHIT v0.2.1-beta
[Thu Jun  25 09:53:10 2015] Start assembly. Number of CPU threads 8.
[Thu Jun  25 09:53:10 2015] Extracting solid (k+1)-mers for k = 21
[Thu Jun  25 09:59:09 2015] Building graph for k = 21
[Thu Jun  25 10:00:49 2015] Assembling contigs from SdBG for k = 21
[Thu Jun  25 10:05:00 2015] Extracting iterative edges from k = 21 to 31
[Thu Jun  25 10:07:43 2015] Building graph for k = 31
[Thu Jun  25 10:09:39 2015] Assembling contigs from SdBG for k = 31
[Thu Jun  25 10:12:27 2015] Extracting iterative edges from k = 31 to 41
[Thu Jun  25 10:13:34 2015] Building graph for k = 41
[Thu Jun  25 10:15:35 2015] Assembling contigs from SdBG for k = 41
[Thu Jun  25 10:18:06 2015] Extracting iterative edges from k = 41 to 51
[Thu Jun  25 10:19:09 2015] Building graph for k = 51
[Thu Jun  25 10:20:53 2015] Assembling contigs from SdBG for k = 51
[Thu Jun  25 10:23:02 2015] Extracting iterative edges from k = 51 to 61
```

...and at the end you'll see something like this:

```
[Thu Jun  25 18:43:16 2015] Merging to output final contigs.
[Thu Jun  25 18:43:18 2015] ALL DONE.
```

So, now we want to take a look at our assembly and see how it "looks".  We'll navigate into the folder we named (`megahit_assembly`) as the output by typing `cd megahit-assembly` and then `ls -lah` the contents of the folder.  You should see something like this:

```
drwxr-xr-x 3 user group    7 Jun  4 10:43 .
drwxr-xr-x 9 user group  101 Jun  4 09:53 ..
-rw-r--r-- 1 user group 147M Jun  4 10:43 final.contigs.fa
-rw-r--r-- 1 user group 1.2M Jun  4 10:43 log
-rw-r--r-- 1 user group   71 Jun  4 09:53 opts.txt
drwxr-xr-x 2 user group   13 Jun  4 10:43 tmp
```

We're really concerned with two files, the `log` of the run and, of course, the assembly `final.contigs.fa`

Let's take a look at the `log` file first; go ahead and type `tail log`.  This will give you some of megahit's stats on the assembly.  The whole log file will give you a more in depth account of what happened than was printed to the screen.

We're interested in this part:

```
Simple path graph size: 81489
Number of unitigs removed: 113
Total length: 86752217, N50: 5464, Mean: 1482, number of contigs: 58510
Maximum length: 234281
```

This tells us that we have 58510 contigs, more than half of our assembly is represented by contigs larger than 5464 bases, and that our average contig size is 1482 bases.  Our assembly is a total of 234281 bases.

I'm sure you're wondering just how much of our input sequencing actually assembled here?  Well, we have to run some stats on our original input files.  Let's use the handy [fastx-toolkit](http://hannonlab.cshl.edu/fastx_toolkit/), which is already installed on the EDAMAME ami.
