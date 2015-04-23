#Data quality checking with FastQC

####Information in this tutorial is based on the FastQC manual which can be accessed [here](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/).

FastQC is a relatively quick and labor-unintesive way to check the quality of your sequencing data.

Before starting, we need to make sure we have sequencing files that end in .gz

FastQC is already loaded and active in our AMI, so all we have to do is use the 'fastqc' command:
```
fastqc [filename].gz
```
This will create two new files with the same name and the extensions `.fastqc.zip` and `fastqc.html`. As you may be able to guess, these are processed files in zip and html format. 

Let's look at the html file. It should say "FastQC report" at the top and contain 12 charts and graphs.

###1: Basic Statistics
[screenshot here]
Basic statistics is a chart containing information about your file, including the name, how many reads there are for this sequence, and whether or not any of the reads were flagged for poor quality. 

###2: Per base sequence quality
[screenshot here]
Per base sequence quality is exactly what it sounds like: a graph displaying the quality of the sequence at every base. It displays this information using box and whisker plots to give you a sense of how much variation there was among the reads. Any plot that is within the green region is considered acceptable quality, while anything in the orange or red regions should be trimmed. 

###3: Per tile sequence quality
[screenshot here]
Per tile sequence quality is a measure of the flow cell quality by individual tiles. If the figure is entirely a solid bright blue, the flow cell tile quality was consistently great! If there are patches of lighter blue or any other color, there was a problem associated with one of the tiles and this may correspond with a decrease in sequence quality in those regions.

###4: Per sequence quality scores
[screenshot here]
Per sequence quality scores reprent the quality of each read for the sequence. Some of the reads may be of poor quality due to positioning within the flow cell.

###5: Per base sequence content
[screenshot here]
Per base sequence content shows the percent of the sequence that is composed of each of the 4 bases. Since we expect the composition to be roughly the same for each base, the lines should be parallel. 

