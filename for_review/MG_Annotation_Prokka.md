#Annotating metagenomes using Prokka
Now that our assembly finished, we are going to work on annotation. Annotation is the process of identifying coding sequences, RNA's and other important features from raw (meta)genomic fasta files. There are several annotation programs available but we will only be using Prokka for this course. We are using Prokka in part because it is fast, but also because running the actual command is quite simple. Prokka makes us of a set of software in order to provide a quick and robust annotation of contigs from genomes/metagenomes. Prokka can identify coding regions, rRNA, tRNA, signal peptides, and noncoding RNA.  

Before we can run the annotation we need to make some changes to our fasta headers from the final.contigs.fa. The fasta headers produced by megahit are too long and cause an error in prokka. Take a look at them by using `head`. We will use a quick awk script adapted from Pierre Lindenbaum to change our fasta headers and write them to a new file. [Pierre's original Script](https://www.biostars.org/p/53212/)  [Pierre's Blog](http://plindenbaum.blogspot.com/)

```
awk '/^>/{print ">contig" ++i; next}{print}' < final.contigs.fa > New_Headers.fa
```
Take a look at New_Headers.fa using `head` and you will see that the fasta headers are shorter and labeled sequentially. Now that is taken care of we can start our annotation. This step will take several hours, so be sure you are using tmux when you start the command. 

```
prokka --outdir CentraliaMG_Prokka New_Headers.fa
```

Make sure that you do not have a directory called "CentraliaMG_Prokka" before running this script as prokka will fail if you do. Once prokka finishes, it will output 11 files in total. You can find out more about each of these output files from the prokka paper [here](http://bioinformatics.oxfordjournals.org/content/30/14/2068.long). 

###Additional Resources
#### Pierre Lindebaum
[Blog](http://plindenbaum.blogspot.com/)

[awk script](https://www.biostars.org/p/53212/)

####Prokka
[Prokka Paper](http://bioinformatics.oxfordjournals.org/content/30/14/2068.long)

[Prokka Developers' Site](http://www.vicbioinformatics.com/software.prokka.shtml)

####Softwares Prokka uses
Prodigal [Website](http://prodigal.ornl.gov/) & [Paper](http://www.biomedcentral.com/1471-2105/11/119)

RNAmmer [Website](http://www.cbs.dtu.dk/services/RNAmmer/) & [Paper](http://nar.oxfordjournals.org/content/35/9/3100)

Aragorn [Website](http://mbioserv2.mbioekol.lu.se/ARAGORN/) & [Paper](http://nar.oxfordjournals.org/content/32/1/11.long)

SignalP [Website](http://www.cbs.dtu.dk/services/SignalP/) & [Paper](http://www.nature.com/nmeth/journal/v8/n10/full/nmeth.1701.html)

Infernal [Website](http://infernal.janelia.org/) & [Paper](http://bioinformatics.oxfordjournals.org/content/29/22/2933)
