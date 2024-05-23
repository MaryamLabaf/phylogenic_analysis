#!/bin/bash

# Navigate to the directory of the output of evolve chain results, create JSON files for evolutionary trees and view results. 

PATH_DIR="/mathspace/data01/maryam.labaf001/phylowgs-master"

mkdir -p $PATH_DIR/"Witness_per_sample"
cd $PATH_DIR/evolve_output_of_CNV || exit

# Loop through each chains in the evolve output
for folder in *_chains; do
    # Extract the sampleID from the folder name
    sampleID=$(echo "$folder" | sed 's/_chains//')

    mkdir -p test_results    
    cd test_results || exit
    python2 ../write_results.py "$sampleID" "../$folder/trees.zip" "$sampleID.summ.json.gz" "$sampleID.muts.json.gz" "$sampleID.mutass.zip"

    gunzip *.gz
    cd ..
    
    # Move the test_results directory to wintess/data/
    mv test_results wintess/data/
    
    # Navigate into the wintess directory
    cd wintess || exit
    
    python2 index_data.py
    
    cd ..
    cp -r wintess Witness_per_sample/
    
    cd Witnes_per_sample || exit
    mv wintess "${sampleID}_witness"
    cd ..
done


