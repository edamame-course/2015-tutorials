---
title: Quality Trimming Raw Metagenomic Sequencing
layout: post
date:
category : tutorial
tags : []
---

By Joshua Herr

## Background On Quality Trimming

When DNA sequencing takes place, errors are inevitable.  No sequencing method is perfect and some are drastically different than others in regard to sequence length and quality.  We're going to trim the poor quality tail end sections of our Illumina reads.  Although in general Illumina reads are very high quality, this degradation at the end of the sequencing run is typical of the Illumina sequencing platforms.

Some sequencing centers will remove library adapters (our sequencing center does), but you will have to check with your data provider to know what they give you and ALWAYS check for your self to verify what you have been told.

As always, you want to make sure you read the manual of any tool to be sure you know what the tool is doing to your data and if that is the right tool for the job.  Knowing which tool to use is very important -- you wouldn't use a saw to put a nail in a piece of wood, would you?

We'll be using a tool which is not aware of paired-end reads. This is fine as the downstream metagenome assembly program we will use (megahit) only takes single end reads.  If you choose to use a different assembly program that accepts (or even requires!) paired-end reads then you will have to choose a tool to do trimming on the paired-ends.  

## Quality Trimming Your Sequence Data

1.  Start a ```m1.xlarge``` machine from Amazon Web Services running the EDAMAME AWS ami (insert ami here).  This instance has about 15 GB of RAM, and 2 CPUs, and should be enough to complete the assembly of the example data set we will use.

**Note:** One of the issues with processing whole genome shotgun data is how long it takes for the computer to process many steps of the workflow.  This can be time consuming and you should consider using ```screen``` or ```tmux``` to ensure that an internet connection issue does not cause you to lose your workflow progress.

**Pro-Tip:** You'll also want to keep in mind that these assemblies take a lot of computer power to run which can cost you some money -- for your own benefit, you can try to optimize your scripts on a desktop or laptop before you actually fire up the AWS instance of this size.

Download the data:
```
wget https://s3.amazonaws.com/edamame/EDAMAME_Datasets.tar.gz
tar -zxvf EDAMAME_Datasets.tar.gz
```

2.  First, let's get an idea of some quality stats from our data.  We're going to first use the ```fastx_quality_stats``` [script](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_statistics_usage) from the Hannon Lab's [fastx-toolkit](http://hannonlab.cshl.edu/fastx_toolkit/index.html) package.

```
fastx_quality_stats -i <filename>.fastq -o quality.txt

cat quality.txt
```

This will give us some idea of what we are dealing with.  We'll want to keep this in mind when we check the quality after trimming.

Then we run this command:

```
fastq_quality_filter -i <filename>.fastq -Q33 -q 30 -p 50  -o <filename>.qc.fastq
```

This command first uses the ```fastq_quality_filter``` [script](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage) from Hannon Lab's [fastx-toolkit](http://hannonlab.cshl.edu/fastx_toolkit/index.html) to trim the data using Illumina-33 [Phred quality score](http://en.wikipedia.org/wiki/Phred_quality_score). 

Note that you can modify the ```fastq_quality_filter``` [script](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage) to trim to any specific length or quality level that you desire.  As always, read the [manual](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage) for information on how to use a script.

If when you are using your own data, the ```fastq_quality_filter``` complains about invalid quality scores, first try removing the -Q33 in the command.  There are numerous types of quality scores and you may have older data which did not use the Q33 output.  For more information on fastq quality scores, [this is a good overview](http://en.wikipedia.org/wiki/FASTQ_format).

For a sanity check, let's use the ```fastx_quality_stats``` script again to see what changed in our trimmed data files:

```
fastx_quality_stats -i <filename>.qc.fastq -o qc_quality.txt

cat quality.txt

cat qc_quality.txt
```

What are the differences between the raw data and the quality trimmed data?


## Other tools for quality trimming

There are other tools for quality trimming your data -- some are for specific types of data and have different features.  It's a good idea to read the manual of each tool and do a sanity check on your data after using the tools (at the very least ```head```, ```tail```, ```more```, ```less```, *etc*.) to see that you are actually removing what you think you are removing.

Some handy quality and/or adapter trimming tools you might want to investigate are:
    1. [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) - all purpose
    2. [cutadapt](https://code.google.com/p/cutadapt/) - adapter trimming
    3. [sickle](https://github.com/najoshi/sickle) - read quality trimming
    4. [scythe](https://github.com/vsbuffalo/scythe) - adapter contamination trimming


## Next step

Now we're going to take our quality trimmed reads and run digital normalization on the reads to remove redundant information and also remove some erroneous information.
