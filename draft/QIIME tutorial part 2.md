* Assign taxonomy to representative sequences

Command

: assign_taxonomy.py -i usearch61_openref_prefilter0_90/rep_set.fna -m rdp -c 0.8

* Make an OTU table, append the assigned taxonomy, and exclude failed alignment OTUs

Commnad

: biom summarize_table -i usearch61_openref_prefilter0_90/otu_table_mc2_w_tax.biom -o 

summary_otu_table_mc2_w_tax_biom.txt

* Rarefaction (subsampling)

  (Subsample to an equal sequencing depth across all samples (rarefaction) to make a new “even" OTU table)

Command

: single_rarefaction.py -i usearch61_openref_prefilter0_90/otu_table_mc2_w_tax.biom -o 

Subsampling_otu_table_even2998.biom -d 2998

* Calculating alpha (within-sample) diversity

Command

: alpha_diversity.py -i Subsampling_otu_table_even73419.biom -m observed_species,PD_whole_tree -o 

alphadiversity_even73419/subsample_usearch61_alphadiversity_even73419.txt -t rep_set.tree

* Calculation of Alphadiversity

Command

: mkdir alphadiversity_even2998

: alpha_diversity.py -i Subsampling_otu_table_even2998.biom -m observed_species,PD_whole_tree -o 

alphadiversity_even2998/subsample_usearch61_alphadiversity_even2998.txt -t 

usearch61_openref_prefilter0_90/rep_set.tre

* make area, and bar chart from subsampled dataset + summary tables for taxonomic level.

Command

: summarize_taxa_through_plots.py -o alphadiversity_even2998/taxa_summary2998/ -i 

Subsampling_otu_table_even2998.biom

* Make resemblance matrices to analyze comparative (beta) diversity

Command

: beta_diversity.py -i Subsampling_otu_table_even2998.biom -m 

unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o beta_div_even2998/ -t 

usearch61_openref_prefilter0_90/rep_set.tre

* Creat PCoA plot

Command

: principal_coordinates.py -i beta_div_even73419/ -o beta_div_even73419_PCoA/

* make 2D plot

Command

: make_2d_plots.py -i 

beta_div_even2998_PCoA/pcoa_weighted_unifrac_Subsampling_otu_table_even2998.txt -m 

Cen_simple_mapping_corrected.txt -o PCoA_2D_plot/

* Creat NMDS plot
* 


  
