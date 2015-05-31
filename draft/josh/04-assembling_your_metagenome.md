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

We're going to run this code:

```
megahit -m 0.9 -l 500 --cpu-only -r pooled_trim.fastq.keep.abundfilt.keep -o megahit_assembly
```
