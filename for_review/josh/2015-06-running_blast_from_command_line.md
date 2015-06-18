---
title: Running BLAST from the command line to identify environmental sequences
layout: post
date: 2015-06
category: null
comments: true
tags: []
---

# Introduction
OK, your first introduction to the use and abuse of command line tools is... BLAST! That's right, the [Basic Local Alignment Search Tool](http://en.wikipedia.org/wiki/BLAST)!

Let's assume that all of you have used the NCBI BLAST Web page to do individual searches. Today we'll automate batch searches at the command line on your own computer. This is a technique that works well for small-to-medium sized sequencing data sets. The various database (nr, nt) are getting big enough that it's reasonably time consuming to search them on your own, although of course you can do it if you want – you might just have to wait a while for things to finish.

Before I forget, let me say that there are a lot of tips and tricks for working at the UNIX command line that I'm going to show you, so even if you've used command line BLAST before, you should skim along.

First, let's check and see if we have BLAST.

```
which blastall
```

If you have BLAST installed and in your path (BLAST may be installed but not in your path), it will give you something like this:

```
/opt/blast/bin/blastall
```

If you don't have BLAST (you should have it in your QIIME or mothur paths), then you will need to install it.

## Installing BLAST
To install the BLAST software, you need to download it from NCBI, unpack it, and copy it into standard locations:

```
curl -O ftp://ftp.ncbi.nih.gov/blast/executables/release/2.2.24/blast-2.2.24-ia32-linux.tar.gz
tar xzf blast-2.2.24-ia32-linux.tar.gz
sudo cp blast-2.2.24/bin/* /usr/local/bin
sudo cp -r blast-2.2.24/data /usr/local/blast-data
```

## Download the databases
Now, we can't run BLAST without downloading the databases. Let's start by doing a BLAST of some sequences from an environmental sequencing project (not telling you from what yet). For this you'll need the nt db.  This, like a lot of NCBI databases is huge, so I don't suggest putting this on your laptop unless you have a lot of room.  It's best on a larger computer (HPCC, Amazon machine, that you have access to).  I wouldn't install this database unless you know you have room on your computer.

Use curl to retrieve them:

```
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.01.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.02.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.03.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.04.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.05.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.06.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.07.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.08.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.09.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.10.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.11.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.12.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.13.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.14.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.15.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.16.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.17.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.18.tar.gz \
curl -O ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.19.tar.gz \
```

This downloads the database files into the current working directory from the given FTP site, naming the files for the last part of the path (e.g. 'mouse.protein.faa.gz'). You can do this from any Web or FTP address.

Now you've got these files. How big are they?

```
ls -l *.gz
```

These are large files and they are going to be even larger when you uncompress them.

```
gunzip *.tar.gz
```

So, now we've got the database files, but BLAST requires that each subject database be preformatted for use; this is a way of speeding up certain types of searches. To do this, we have to format the database.  You should do:

```
formatdb -i nt.*.faa -o T -p F
```

The -i parameter gives the name of the database, the -o parameter says "save the results", and the -p parameter says "this is a protein database". For DNA, you'd want to use '-p F', or false.

Before we start a BLAST of all of our sequences, we need to make sure our blast is working.  To do this, we want to start with something small. Let's take a few sequences off the top of the mouse protein set:

```
head nt.01.fasta > nt_first.fasta
```

Here, the program 'head' takes the first ten lines from that file, and the `>` tells UNIX to put them into another file, `nt-first.fasta`.

Just a reminder:

1. UNIX generally doesn't care what the file is called, so '.faa' and '.fa' are all the same to it. 
2. UNIX utilities work well with text files, and almost everything you'll encounter is a basic text file. This is different from Windows and Mac, where more complicated formats are used that can't be as easily dealt with on UNIX.

Now try a BLAST:

```
blastall -i nt-first.fasta -d nt -p blastn
```

You can do three things at this point.

First, you can scroll up in your terminal window to look at the output.  

Second, you can save the output to a file:

```
blastall -i nt-first.fasta -d nt -p blastn -o out.txt
```

and then use 'less' to look at it:

```
less out.txt
```

and third, you can pipe it directly to less, by which I mean you can send all of the output to the 'less' command without saving it to a file:

```
blastall -i nt-first.fasta -d nt -p blastn | less
```

## Different BLAST options
BLAST has lots and lots and lots of options. Run 'blastall' by itself to see what they are. Some of the most useful ones are `-v`, `-b`, and `-e`.
