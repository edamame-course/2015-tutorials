---
layout: page
title: "QIIME Tutorial 3"
comments: true
date: 2014-08-14 12:44:36
---
### Handouts of workflow charts are available for the QIIME workflow discussed in these tutorials:
-  [Paired-End Illumina](https://github.com/edamame-course/docs/tree/gh-pages/extra/Handouts/QIIMEFlowChart_IlluminaPairedEnds_13aug2014.pdf?raw=true)
-  [454](https://github.com/edamame-course/docs/tree/gh-pages/extra/Handouts/QIIMEFlowChart_454_13aug2014.pdf?raw=true)


## 4.1 Make resemblance matrices to analyze comparative (beta) diversity
Make sure that you are in the QIIMETutorial directory.  

If you need the Subsampling_otu_table_even2998.biom file from Parts 1 and 2
of the tutorial you can download it here:

[Subsampling_otu_table_even2998.biom] 
##[add link]

We will make three kinds of resemblance matrices (sample by sample comparisons) for assessing comparative diversity.

Use the `-s` option to see all of the different options for calculating beta diversity in QIIME.

```
beta_diversity.py -s
```

To compare weighted/uweighted and phylogenetic/taxonomic metrics, we will ask QIIME to create four resemblance matrices of all of these different flavors.

```
beta_diversity.py -i Subsampling_otu_table_even2998.biom -m 

unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o beta_div_even2998/ -t 

usearch61_openref_prefilter0_90/rep_set.tre
```

There should be four new resemblance matrices in the new directory.  We're going to get all crazy and open these outside of the terminal. Use Excel to inspect them, and to compare their values.  This should be a square matrix, and the upper and lower triangles should be mirror-images.  The diagonal should be zero.

```
cd beta_div_even2212
```

Pop quiz:  Why is the diagonal zero?


## 4.2 Using QIIME for visualization:  Ordination

QIIME scripts can easily make an ordination using principal components analysis (PCoA). We'll perform PCoA on all resemblance matrices, and compare them.  Documentation is [here](http://qiime.org/scripts/principal_coordinates.html).  As always, make sure you are in the QIIMETutorial directory to execute these analyses.


```
principal_coordinates.py -i beta_div_even73419/ -o beta_div_even73419_PCoA/
```

Notice that the `-i` command only specifies the directory, and not an individual filepath.  PCoA will be performed on all resemblances in that directory.  If we navigate into the new directory, we see there is one results file for each input resemblence matrix.

##[screenshot]

Inspect the one of these files using nano.

```
nano pcoa_weighted_unifrac_Schloss_otu_table_even2212.txt
```

##[screenshot]

The first column has SampleIDs, and column names are PCoA axis scores for every dimension.  In PCoA, there are as many dimensions (axes) as there are samples. Remember that, typically, each axis explains less variability in the dataset than the previous axis.

These PCoA results files can be imported into other software for making ordinations outside of QIIME.

Navigate back into the QIIMETutorial directory.

We can make 2d plots of the output of `principal_coordinates.py`, and map the colors to the categories in the mapping file.

```
make_2d_plots.py -i 

beta_div_even2998_PCoA/pcoa_weighted_unifrac_Subsampling_otu_table_even2998.txt -m 

Cen_simple_mapping_corrected.txt -o PCoA_2D_plot/
```

Navigate into the new directory and open the html link.
```
cd plotting_PCoA2d_even2212_wu/
```

```
open _2D_PCoA_plots.html
```

![img19](https://github.com/edamame-course/docs/raw/gh-pages/img/QIIMETutorial3_IMG/IMG_19.jpg)

This is where  a comprehensive mapping file is priceless because any values or categories reported in the mapping file will be automatically color-coded for data exploration.  In the example above, there is an obvious difference in the community structure of the gut microbiota of the F3 mouse over time (using).

Take some time to explore these plots: toggle samples, note color categories, hover over points to examine sample IDs.  What hypotheses can be generated based on exploring these ordinations?

*Exercise*
Make 2D plots for each PCoA analysis from each of the four difference resemblance results and compare them.  How are the results different, if at all?  Would you reach difference conclusions?

[The Ordination Web Page](http://ordination.okstate.edu/) is a great resource about all the different flavors of ordination.

### 4.3  Other visualizations in QIIME
We can also make a quick heatmap in QIIME, which shows the number of sequences per sample relative to one another.

```
make_otu_heatmap_html.py -i Schloss_otu_table_even2212.biom -o heatmap/
```

```
open Schloss_otu_table_even2212.html
```

Explore this visualization.  You can filter the minimum number of OTUs, filter by sample ID, or by OTU ID.  

**Visualization considerations**
QIIME visualizations are currently being re-vamped by the developers.  In the next version, there will visualization scripts that are no longer supported, in favor of new tools.  Some of these tools include co-occurence networks enabled by Cytoscape (a MacQIIME add-on), and other visualizations by [emperor](http://biocore.github.io/emperor/).  There is always something new!


### 4.4  Exporting the QIIME-created biom table for use in other software (R, Primer, Phinch, etc)
This command changes frequently, as the biom format is a work in progress.  Use `biom convert -h` to find the most up-to-date arguments and options; the web page is not updated as frequently as the help file.

```
biom convert -b -i Schloss_otu_table_even2212.biom -o Schloss_otu_table_even2212.txt --table-type otu  --header-key taxonomy --output-metadata-id "ConsensusLineage"
```

Here, we use the argument `-b` to specify that we are converting a biom-formatted table to a "classic" otu table.  We specify input and output files with `-i` and `-o`, as always.  We also provide the `--table-type` arugment to "otu."  Finally, we specify that we want our OTU table to have the taxonomy assigned to each OTU as the last column in the table (` --header-key` set to "taxonomy") and that the name of this column, `--output-metadata-id`, will be the "ConsensusLineage"


## Where to find QIIME resources and help
*  [QIIME](qiime.org) offers a suite of developer-designed [tutorials](http://www.qiime.org/tutorials/tutorial.html).
*  [Documentation](http://www.qiime.org/scripts/index.html) for all QIIME scripts.
*  There is a very active [QIIME Forum](https://groups.google.com/forum/#!forum/qiime-forum) on Google Groups.  This is a great place to troubleshoot problems, responses often are returned in a few hours!
*  The [QIIME Blog](http://qiime.wordpress.com/) provides updates like bug fixes, new features, and new releases.
*  QIIME development is on [GitHub](https://github.com/biocore/qiime).

-----------------------------------------------
-----------------------------------------------

