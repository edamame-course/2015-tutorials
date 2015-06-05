---
layout: page
title: "QIIME Tutorial 2"
comments: true
date: 2014-08-14 08:44:36
---
###Handouts of workflow charts are available for the QIIME workflow discussed in these tutorials:
-  [Paired-End Illumina](https://github.com/edamame-course/docs/tree/gh-pages/extra/Handouts/QIIMEFlowChart_IlluminaPairedEnds_13aug2014.pdf?raw=true)
-  [454](https://github.com/edamame-course/docs/tree/gh-pages/extra/Handouts/QIIMEFlowChart_454_13aug2014.pdf?raw=true)

## Welcome back, Microbe Enthusiasts!

## Creating an OTU table in QIIME

Previously, we left off with quality-controlled merged Illumina paired-end sequences, picked OTUs and an alignment of the representative sequences from those OTUs.

### 3.1  Assign taxonomy to representative sequences

Navigate into the QIIMETutorial directory using `cd`, and, enter the QIIME environment. We will use the RDP classifier with a greengenes 16S rRNA reference database (both default options in QIIME).  This script will take a few minutes to run on a lap-top. Documentation is [here](http://qiime.org/scripts/assign_taxonomy.html).

```
assign_taxonomy.py -i usearch61_openref_prefilter0_90/rep_set.fna -m rdp -c 0.8
```

Navigate into the new rdp_assigned_taxonomy directory and inspect the head of the tax_assignments file.

```
head cdhit_rep_seqs_tax_assignments.txt
```

![img11](https://github.com/edamame-course/docs/raw/gh-pages/img/QIIMETutorial2_IMG/IMG_11.jpg)

This assignment file is used anytime an OTU ID (the number) needs to be linked with its taxonomic assignment.
*Note* that this list of OTUs and taxonomic assignments includes our "failed-to-align" representative sequences.  We will remove these at the next step.

### 3.2  Make an OTU table, append the assigned taxonomy, and exclude failed alignment OTUs

The OTU table is the table on which all ecological analyses (e.g. diversity, patterns, etc) is performed.  However, building the OTU table is relatively straightforward (you just count how many of each OTU was observed in each sample).  Instead, every step up until building the OTU table is important.  The algorithms that are chosen to assemble reads, quality control reads, define OTUs, etc are all gearing up to this one summarization. Documentation for make_otu_table.py is [here](http://qiime.org/scripts/make_otu_table.html). Note that the "map" file is not the actually mapping file, but the OTU cluster file (the output of cdhit).
Navigate back into the "QIIMETutorial" directory to execute the script.

```
biom summarize_table -i usearch61_openref_prefilter0_90/otu_table_mc2_w_tax.biom -o summary_otu_table_mc2_w_tax_biom.txt
```

The summary file contains information about the number of sequences per sample, which will help us to make decisions about rarefaction (subsampling).  When we inspect the file, we see that sample F3D142.S208 has 2212 reads, the minimum observed.  This is what we will use as a subsampling depth.  Also, a lot of the info in this file is typically reported in methods sections of manuscripts.

![img13](https://github.com/edamame-course/docs/raw/gh-pages/img/QIIMETutorial2_IMG/IMG_13.jpg)


### 3.3 Make a phylogenetic tree

We will make a phylogenetic tree of the short-read sequences so that we can use information about the relatedness among taxa to estimate and compare diversity.  We will use FastTree for this.  
It is best not to use trees made from short-reads as very robust hypotheses of evolution. I suggest using trees from short-read sequences for ecological analyses, visualization and hypothesis-generation rather than strict phylogenetic inference.
Documentation is [here](http://qiime.org/scripts/make_phylogeny.html).

```
mkdir fasttree_cdhit
```

```
make_phylogeny.py -i pynast_aligned/cdhit_rep_seqs_aligned.fasta -t fasttree -o fasttree_cdhit/fasttree_cdhit.tre
```

A few notables:  The tree algorithm input is the alignment file; the output extension is .tre.

Inspect the new tree file ([Newick](http://marvin.cs.uidaho.edu/Teaching/CS515/newickFormat.html) format). The OTU ID is given first, and then the branch length to the next node. This format is generally compatible with other tree-building and viewing software. For example, I have used it to input into the [Interactive Tree of Life](http://itol.embl.de/) to build visually appealing figures. [Topiary Explorer](http://topiaryexplorer.sourceforge.net/) is another options for visualization, and is a QIIME add-on.

### 3.4 Rarefaction (subsampling)

Navigate back into the QIIMETutorial directory.

Before we start any ecological analyses, we want to evenly subsample ("rarefy", but see this [discussion](http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1003531)) all the samples to an equal ("even") number of sequences so that they can be directly compared to one another. Many heartily agree (as exampled by [Gihring et al. 2011](http://onlinelibrary.wiley.com/doi/10.1111/j.1462-2920.2011.02550.x/full)) that sample-to-sample comparisons cannot be made unless subsampling to an equal sequencing depth is performed.

To subsample the OTU table, we need to decide the appropriate subsampling depth. What is the best number of sequences?  As a rule, we must subsample to the minimum number of sequences per sample for all samples *included* in analyses.  Sometimes this is not straightforward, but here are some things to consider:

*  Are there low-sequence samples that have very few reads because there was a technological error (a bubble, poor DNA extraction, poor amplification, etc)?  These samples should be removed (and hopefully re-sequenced), especially if there is no biological explanation for the low number of reads.
*  How complex is the community?  An acid-mine drainage community is less rich than a soil, and so fewer sequences per sample are needed to evaluate diversity.
*  How exhaustive is the sequencing?  If this is unknown, an exploratory rarefaction analysis could be done to estimate.
*  How important is it to keep all samples in the analysis?  Consider the costs and benefits of, for example, dropping one not-very-well-sequenced replicate in favor of increasing overall sequence information.  If you've got $$ to spare, built-in sequencing redundancy/replication is helpful for this.
*  Don't fret!  Soon sequencing will be so inexpensive that we will be sequencing every community exhaustively and not have to worry about it anymore.

In this example dataset, we want to keep all of our samples, so we will subsample to 2212.  Documentation is [here](http://qiime.org/scripts/single_rarefaction.html?highlight=rarefaction).

```
single_rarefaction.py -i usearch61_openref_prefilter0_90/otu_table_mc2_w_tax.biom -o Subsampling_otu_table_even2998.biom -d 2998
```

We append _even2998 to the end of the table to distinguish it from the full table.  This is even2998 table is the final biom table on which to perform ecological analyses.  If we run the biom summary command, we will now see that every sample in the new table has exactly the same number of sequences:

```
biom summarize_table -i Subsampling_otu_table_even2998.biom -o summary_Subsampling_otu_table_even2998.txt
```
##[screenshot]

Our "clean" dataset has 19 samples and 858 OTUs defined at 97% sequence identity.

There is a [recent paper](http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1003531) that suggests that even subsampling is not necessary, but this is very actively debated.

### 3.5 Calculating alpha (within-sample) diversity

Navigate back into the QIIMETutorial directory, and make a new directory for alpha diversity results.

```
mkdir alphadiversity_even4708

```

We will calculate richness (observed # taxa) and phylogenetic diversity (PD) for each sample.  Documentation is [here](http://qiime.org/scripts/alpha_diversity.html).

```
alpha_diversity.py -i Subsampling_otu_table_even4708.biom -m observed_species,PD_whole_tree -o alphadiversity_even4708/subsample_usearch61_alphadiversity_even4708.txt -t usearch61_openref_prefilter0_90/rep_set.tre
```

As always, inspect the results file.  What are the ranges that were observed in richness and PD?

```
head alphadiversity_even4708/subsample_usearch61_alphadiversity_even4708.txt
```

QIIME offers a variety of additional options for calculating diversity, and the -s option prints them all!

```
alpha_diversity.py -s
```

There is workflow script, [alpha_rarefaction.py](http://qiime.org/scripts/alpha_rarefaction.html), which is useful if you want to udnerstand how measures of alpha diversity change with sequencing effort.  The script calculates alpha diversity on iterations of a subsampled OTU table.

### 3.6 Visualizing alpha diversity

`summarize_taxa_through_plots.py` is a QIIME workflow script that calculates summaries of OTUs at different taxonomic levels. Documentation is [here](http://qiime.org/scripts/summarize_taxa_through_plots.html).

```
summarize_taxa_through_plots.py -o alphadiversity_even4708/taxa_summary4708/ -i Subsampling_otu_table_even4708.biom
```

When the script is finished, navigate into the results file, and into the "taxa_summary_plots" and find the html area and bar charts.  If you are on a Mac, use the `open` command to open the html file in your browser. Neato!

```
open area_charts.html
```

##[screenshot]

To view the HTML files, the EC2 users will need to execute the following command:

```
cp -r taxa_summary_even4708/taxa_summary_plots/ ../Dropbox/
```

If the file doesn't open correctly, EC2 users may need to download the folder from Dropbox and unzip the folder (7-Zip --> Extract Here), and then when they open the file, it will show the graphs and other hoopla!

The links above and below the charts point to the raw data or other summaries.  Spend some time exploring all of the different links.  Scroll over the charts and notice how the SampleID and taxonomic assignment "pop" up.

```
open bar_charts.html
```

As you are navigating to these html files, notice that the script has produced an OTU/biom table for every taxonomic level (designated by the "L").  The "L" stands for "lineage", and each "level" is designated by a number.  L1 is Domain, L2 is Phylum, L3 is Class, etc.  The more resolved the lineage (higher number), the less accurate the definition (e.g., L6 is not entirely and consistently the same as  "genus").

The taxa_summary_plots/charts subdirectory contains individual files of all of the charts, but their file names are not useful.  The easiest way to view individual charts is to start with the html page, and then click on the "View Chart" link below each figure, which points to this directory.

##[screenshot]

In your browser, carefully inspect and interact with this quick charts.  Though these are not publication-ready, they are a great first exploration of the taxa in the dataset.

(We will test differences in alpha diversity in R.)


## Where to find QIIME resources and help
*  [QIIME](qiime.org) offers a suite of developer-designed [tutorials](http://www.qiime.org/tutorials/tutorial.html).
*  [Documentation](http://www.qiime.org/scripts/index.html) for all QIIME scripts.
*  There is a very active [QIIME Forum](https://groups.google.com/forum/#!forum/qiime-forum) on Google Groups.  This is a great place to troubleshoot problems, responses often are returned in a few hours!
*  The [QIIME Blog](http://qiime.wordpress.com/) provides updates like bug fixes, new features, and new releases.
*  QIIME development is on [GitHub](https://github.com/biocore/qiime).


-----------------------------------------------
-----------------------------------------------

