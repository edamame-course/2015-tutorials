---
title: Assembling your metagenome
layout: post
date: 2015-06
category: metagenomics
tags: []
---

# Assembling your metagenome

Ok, so we've just spent a little while quality checking, quality trimming, normalizing, and (possibly) partitioning and it's time to get some results -- we're going to assemble our reads into longer contigs and (hopefully!) entire bacterial and archaeal genomes (Disclaimer: Assembling metagenomes is really difficult and fraught with confounding issues.  It was only a few years ago that this was first done for a very simple community that [resulted in a paper in Science](http://www.sciencemag.org/content/335/6068/587.abstract)).

First, there are numerous options for assembling metagenomic data.  Most assemblers ([Velvet](http://www.ebi.ac.uk/~zerbino/velvet/), [IDBA](https://code.google.com/p/hku-idba/), [SPAdes](http://bioinf.spbau.ru/spades/)) that work well on genomic data can be used for metagenomic data, but since they were designed for use on single organisms, they might not be the best choice when you have many many organisms which share genomic signatures.  

We've gone to the trouble of installing some of these to the EDAMAME [ami](), so feel free to experiment in your free time with other assemblers.  We'll be using a newish assembler, Megahit ([program](https://github.com/voutcn/megahit) and [paper](http://bioinformatics.oxfordjournals.org/content/31/10/1674.long)), which has a couple of benefits for us.  One, the assembler is optimized for metagenomic reads, and two, it's pretty fast (when compared to other assemblers (i.e. SPAdes) that provide good results on metagenomic data in addition to metagenomic data).

## Preparing the Data

Each assembler program takes data input in slightly different formats.  Velvet is the most flexible: it can take in paired-end and/or single reads, in FASTA or FASTQ format, gzipped or not.  On the other hand, SPADes requires paired-end FASTQ, while IDBA requires paired-end FASTA.

Since we're going to use megahit, which takes single-end reads (in this case we have disregarded the paired-end metagenomic data and combined the paired reads into a single file -- yes, this throws out some of the information you get from having paired reads), we want our data in a single file as the input.
