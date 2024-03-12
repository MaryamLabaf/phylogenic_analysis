#  Input intermediate CNV.txt files which will contain for each CNV its chromosome, start and end coordinates, major and minor copy numbers, and cellular prevalence (i.e., fraction of 
# cells in sample containing the CNV, not just the fraction of tumor cells containing the CNV). 
# Prepare the intermediate CNV.txt files to create ssm_data.txt files tp perfomr phylogenic analysis.

module load bedtools

CNV_PATH=$1 # path to the CVN.txt files

cd $CNV_PATH

find . -name '*.txt' -type f -print0 | while IFS= read -r -d $'\0' file; do
    NAME=$(basename $file _CNA_for_phyloWGS.txt)
    echo $NAME
    # Filter out lines containing NA values
    grep -v NA $file > $NAME"_filtered.txt"

    # Check if the filtered file contains more than just the header line
    if [ $(wc -l < $NAME"_filtered.txt") -gt 1 ]; then
    	head -n 1 $NAME"_filtered.txt" > $NAME"_CNV.txt"
    	tail -n +2 < $NAME"_filtered.txt" | sort -k1,1 -k2,2n | bedtools merge -c 4,5,6,7 -o max,max,max,mean -i - >> $NAME"_CNV.txt"
    else
        # Print an error message if the filtered file only contains the header line
        echo "Error: Filtered file $NAME"_filtered.txt" contains only the header line. Skipping merging for $file."
    fi
    # Clean up temporary file
    rm $NAME"_filtered.txt"
done
