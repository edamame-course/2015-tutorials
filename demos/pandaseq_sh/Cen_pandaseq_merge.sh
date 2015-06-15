#!/bin/bash
# trim centralia sequences so we can test pipeline and analysis
# use pandaseq to merge reads - requires name list (file <list.txt> in same folder as this script) of forward and reverse reads to be merged using the panda-seq program

for file in $(<list2.txt)
do
    pandaseq -f ${file}F_sub.fastq -r ${file}R_sub.fastq -w pandaseq_merged_reads/${file}_merged.fastq -g pandaseq_merged_reads/${file}_merged.log -B -F -A simple_bayesian -l 253 -L 253 -o 47 -O 47 -t 0.9

done
