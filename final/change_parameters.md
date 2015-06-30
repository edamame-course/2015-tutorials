##Changing the default parameters in QIIME
Authored by Siobhan Cusack for EDAMAME 2015

[EDAMAME-2015 wiki](https://github.com/edamame-course/2015-tutorials/wiki)

***
EDAMAME tutorials have a CC-BY [license](https://github.com/edamame-course/2015-tutorials/blob/master/LICENSE.md). _Share, adapt, and attribute please!_
***

When using a pipeline such as QIIME, you may want to change the default parameters of a given script. To do this, you will need to create a parameters file. QIIME has a good overview of parameters files [here](http://qiime.org/documentation/qiime_parameters_files.html).

As an example, when using [pick_open_reference_otus.py](http://qiime.org/scripts/pick_open_reference_otus.html), I may want to change the OTU cutoff to 99% instead of the default 97%. Let's try this.

Start up an EC2 instance with the QIIME AMI (ami-1918ff72) and grab the combined_seqs_smaller.fna file, which is a file containing just a fraction of our full sequences for demonstration purposes:

```
curl -O https://raw.githubusercontent.com/edamame-course/2015-tutorials/master/QIIME_files/combined_seqs_smaller.fna

```

To make sure that the workflow script is running properly, it's a good idea to inspect the log file carefully. To get an idea of what the log file will look like when we use the default parameters, let's run it as we did in the QIIME tutorial.
If you don't already have usearch installed, do that now:
```
curl -O https://raw.githubusercontent.com/edamame-course/2015-tutorials/master/QIIME_files/usearch5.2.236_i86linux32
curl -O https://raw.githubusercontent.com/edamame-course/2015-tutorials/master/QIIME_files/usearch6.1.544_i86linux32
sudo cp usearch5.2.236_i86linux32 /usr/local/bin/usearch
sudo chmod +x /usr/local/bin/usearch
sudo cp usearch6.1.544_i86linux32 /usr/local/bin/usearch61
sudo chmod +x /usr/local/bin/usearch61
```
In the home directory (containing the combined_seqs_smaller.fna file), run the following:

```
pick_open_reference_otus.py -i combined_seqs_smaller.fna -m usearch61 -o usearch61_openref_97/ -f

```
This will take just a couple of minutes to run. Once it has finished, navigate into the usearch61_openref_97 directory and use ```more``` to inspect the log file fully.

[screenshot]

Navigate back to the directory containing the fna file and use nano to make a new file that we will put our parameter changes into.

```
nano parameters.txt
```
This will open a new, empty file. Copy and paste the following into the new file:
```
pick_otus:similarity	0.99

assign_taxonomy:id_to_taxonomy_fp  /home/ubuntu/qiime_software/gg_otus-12_10-release/taxonomy/99_otu_taxonomy.txt
```
Now exit and save the file. 

The parameters file specifies to the workflow script that when it gets to the pick_otus step, it should use a cutoff of 99% instead of 97%. It also specifies that when it gets to the assign_taxonomy step, it should use a file from QIIME that was created using a 99% rather than a 97% cutoff. 

The format here is to specify the script, the option, and the setting we want to use. It's similar to running a script with a flag (in the case of pick_otus here, "similarity" would be the flag) and the option that we would normally put after the flag goes after that. Important note: when making your parameters file, write out the script (without .py), then a colon, then the option, without any spaces. Then hit tab, and type your specification. The space between the option and your setting IS important.

No we're going to run pick_open_reference OTUs with our new parameters file.  

```
pick_open_reference_otus.py -i combined_seqs_smaller.fna -m usearch61 -o usearch61_openref/ -f -p parameters.txt
```
Once it finishes running, inspect the log file using more. 

[screenshot]

That's it! You can now change the OTU cutoff to anything your heart desires!


Now for something more complicated; say I want to change the database used for clustering and aligning. We'll use Silva because a lot of you probably want to use it.
Go to Silva's [download page](http://www.arb-silva.de/no_cache/download/archive/qiime/), and click the most recent release (Silva_104_release.tgz).

Save this in a place where you can find it, like the desktop, and use scp to transfer the file to your Amazon instance, and unzip it:

```
scp -i [your key file] Silva_104_release.tgz ubuntu@ec2-[your DNS]

tar -xvzf Silva_104_release.tgz

```
This will generate a new directory called "silva_104". Navigate there and inspect the new files if you'd like to. 

Now move the necessary files into the directory containing your fna file. You can do this using:

```
mv *99* [your directory]
```
Navigate into the directory with these files and make a new parameters file.

```
nano parameters_Silva.txt
```
Copy and paste these lines, making sure to add the correct file path if you unzipped the Silva database somewhere other than the home directory:

```
align_seqs:template_fp    /home/ubuntu/silva_104/core_Silva_aligned.fasta 

assign_taxonomy:id_to_taxonomy_fp   /home/ubuntu/silva_104/Silva_taxa_mapping_104set_97_otus.txt

assign_taxonomy:reference_seqs_fp   /home/ubuntu/silva_104/silva_104_rep_set.fasta

```
Exit and save the file, then run pick_open_reference_otus.py:

```
pick_open_reference_otus.py -i combined_seqs.fna -m usearch61 -o usearch61_openref/ -f -p parameters_Silva.txt

```
Let it run, then inspect the log file to ensure that the correct database was used:
[screenshot]

Hooray! You can now use any database you like so long as the files are formatted correctly.

#Resources and help
## QIIME
  - QIIME documentation on [parameters files](http://qiime.org/documentation/qiime_parameters_files.html).
  - [QIIME](qiime.org) offers a suite of developer-designed [tutorials](http://www.qiime.org/tutorials/tutorial.html).
  - [Documentation](http://www.qiime.org/scripts/index.html) for all QIIME scripts.
  - There is a very active [QIIME Forum](https://groups.google.com/forum/#!forum/qiime-forum) on Google Groups.  This is a great place to troubleshoot problems, responses often are returned in a few hours!
  - The [QIIME Blog](http://qiime.wordpress.com/) provides updates like bug fixes, new features, and new releases.
  - QIIME development is on [GitHub](https://github.com/biocore/qiime).
  - Remember that QIIME is a workflow environment, and the original algorithms/software that are compiled into QIIME must be referenced individually (e.g., PyNAST, RDP classifier, FastTree etc...)



