---
layout: page
title: Running BLAST from the command line to identify environmental sequences
comments: true
date: 2015-06-25 14:00:00
---
#Running BLAST from the command line to identify environmental sequnences
Authored by Jin Choi for EDAMAME2015, based on a previous tutorial.
[EDAMAME-2015 wiki](https://github.com/edamame-course/2015-tutorials/wiki)

***
EDAMAME tutorials have a CC-BY [license](https://github.com/edamame-course/2015-tutorials/blob/master/LICENSE.md). _Share, adapt, and attribute please!_
***

##Overarching Goal
* This tutorial will contribute towards an understanding of BLAST running locally

##Learning Objectives
* Build local DB
* Blast query into local DB

***

# Introduction
OK, your first introduction to the use and abuse of command line tools is... BLAST! That's right, the [Basic Local Alignment Search Tool](http://en.wikipedia.org/wiki/BLAST)!

Let's assume that all of you have used the NCBI BLAST Web page to do individual searches. Today we'll automate batch searches at the command line on your own computer. This is a technique that works well for small-to-medium sized sequencing data sets. The various database (nr, nt) are getting big enough that it's reasonably time consuming to search them on your own, although of course you can do it if you want – you might just have to wait a while for things to finish.

## Motiviation: Why I want to run BLAST locally?
1. BLAST on my own database
2. Automation: run on server, downstream analysis, can be part of other program
3. Speed

Before I forget, let me say that there are a lot of tips and tricks for working at the UNIX command line that I'm going to show you, so even if you've used command line BLAST before, you should skim along.

First, let's check and see if we have BLAST.

```
which blastn
```

If you have BLAST installed and in your path (BLAST may be installed but not in your path), it will give you something like this:

```
/usr/bin/blastn
```

If you don't have BLAST, then you will need to install it.

## Step 1: Installing BLAST
To install the BLAST software, type this:

```
sudo apt-get install ncbi-blast+
```

## Step 2: Download the databases
Now, we can't run BLAST without downloading the databases. Let's start by doing a BLAST of some sequences from an environmental sequencing project (not telling you from what yet). For this you'll need the nt db.  This, like a lot of NCBI databases is huge, so I don't suggest putting this on your laptop unless you have a lot of room.  It's best on a larger computer (HPCC, Amazon machine, that you have access to).  I wouldn't install this database unless you know you have room on your computer. Let's download small part of database for tutorial.

Use curl to retrieve database and the file that we use today:

```
curl -O https://s3.amazonaws.com/edamame/Blast_Tutorial.tar.gz
```

This downloads the database files into the current working directory from the given FTP site, naming the files for the last part of the path (e.g. 'mouse.protein.faa.gz'). You can do this from any Web or FTP address.

unzip file.

```
tar -zxvf Blast_Tutorial.tar.gz
```

Let's move into the directory

```
cd Blast_Tutorial
```

Now you've got these files. How big are they?

```
ls -l
```

Let me tell you what are the file.

MyQuery.txt : This will be used for query

Refsoil16s.fa : You can use this for exercise as a database

rep_set.fna : We well use this for database. This is the same file that we create from qiime tutorial.  

rep_set_sub.fna : You can use this for exercise as a query

Database files are large files, but let's use something small for this tutorial.

So, now we've got the database files, but BLAST requires that each subject database be preformatted for use; this is a way of speeding up certain types of searches. To do this, we have to format the database.  You should do:

```
makeblastdb -in rep_set.fna -dbtype nucl -out My16sAmplicon
```

The -in parameter gives the name of the database, the -out parameter says "save the results", and the -dbtype parameter says "what type of the database". For DNA, you'd want to use '-dbtype nucl'. FYI, for protein, '-dbtype prot'.

Let's see how BLAST database looks like

```
ls
```

You may notice that there are 3 files that were generated.

My16sAmplicon.nhr

My16sAmplicon.nin

My16sAmplicon.nsq


Just a reminder:

1. UNIX generally doesn't care what the file is called, so '.fna' and '.fa' are all the same to it. 
2. UNIX utilities work well with text files, and almost everything you'll encounter is a basic text file. This is different from Windows and Mac, where more complicated formats are used that can't be as easily dealt with on UNIX.

## Step 3: Run BLAST
Now try a BLAST: You need a file that have your query in. Here is your query looks like.

```
cat MyQuery.txt
```

We have 4 bacteria and 5 fungi.

Now BLAST. We use blastn because we will search nucleotide database using a nucleotide query.

```
blastn -db My16sAmplicon -query MyQuery.txt
```

You can do three things at this point.

First, you can scroll up in your terminal window to look at the output.  

Second, you can save the output to a file:

```
blastn -db My16sAmplicon -query MyQuery.txt -out out.txt
```

and then use 'less' to look at it:

```
less out.txt
```

and third, you can pipe it directly to less, by which I mean you can send all of the output to the 'less' command without saving it to a file:

```
blastn -db My16sAmplicon -query MyQuery.txt | less
```

Sometimes tabular form (output format) is useful. To get the result in tabular form,

```
blastn -db My16sAmplicon -query MyQuery.txt -out outtabular.txt -outfmt 6
```

## Excercise

Let's try to search Reference Soil database using a your 16s amplicon query.

1. Make Reference Soil database
Here is the fasta format of reference soil. : RefSoil16s.fa

2. Search using a sample 16s amplicon query
You can use this sample query: MyQuery.txt

## Different BLAST options
BLAST has lots and lots and lots of options. Run 'blastn' by itself to see what they are. Some of the most useful ones are `-evalue`.

If you want to search protein, use 'blastp' instead of 'blastn'. 'blastx', 'tblastn', 'tblastx' also available.
***
##Help and other resources
* [Manual of Blast+]( http://www.ncbi.nlm.nih.gov/books/NBK279690/)

-----------------------------------------------
-----------------------------------------------