#Data Visualization Demo
by Ashley Shade for EDAMAME2015
[EDAMAME-2015 wiki](https://github.com/edamame-course/2015-tutorials/wiki)

***
EDAMAME tutorials have a CC-BY [license](https://github.com/edamame-course/2015-tutorials/blob/master/LICENSE.md). _Share, adapt, and attribute please!_
***

##Overarching Goal  
* This tutorial will contribute towards understanding **ecological statistics to analyze and interpret microbial sequencing data**

##Learning Objectives
* Identify R packages and other resources that provide visualization tools for .biom and traditional OTU tables

***

##ggplot demo

[ggplot2](http://ggplot2.org/) is an R package that provides really beautiful (if you're good - publication-ready) visualization tools.  It is built and maintained by Hadley Wickham, and his site has a lot of documentation about the different capabilities of ggplot2.  However, the plotting syntax is different from regular R plotting syntax, and so there is a bit of a learning curve. In ggplot, layers of graphical objects are defined and overlapped to make charts and graphs.  There is an excellent resource for getting started with ggplot2 at a website called [R Cookbook](http://www.cookbook-r.com/Graphs/index.html).  R Cookbook has lots of good tips for general R-ing.

We've made a graph using ggplot2 from the [Centralia contextual data](https://github.com/ShadeLab/Centralia_16S_analysis/tree/master/Data/ContextualData).  This is the kind of visualization that we hope to include in a paper.

When you are in R, install the ggplot2 package and open the library using the below commands.  After you install ggplot2 the first time, you do not need to do it again.

```
intall.packages("ggplot2")
library(ggplot2)
``` 

Click on the above link to the github directory.  Download the RAW Centralia_ContextualMap_09june15.txt file, as well as the R code.  Open R studio and follow along with the demo.  If you want a sneak peak at what we're making, look at the .pdf files of charts.

##[phyloseq demo](https://github.com/raleva/Edamame_phyloseq)
Phyloseq is another R package for visualizations.  It interfaces with functions in ggplot2, but has added nice features specific to sequencing datasets.

##[Phinch](http://www.phinch.org/)
Phinch is a web-based tool (browser must be Chrome) that uploads a .biom table exported straight from mothur or QIIME and automatically presents different exploratory visualizations of the data.

