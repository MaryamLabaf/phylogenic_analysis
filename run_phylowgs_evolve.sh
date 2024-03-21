#!/usr/bin/bash
# run phylogenic multi evolve

PHYLOWGS_PATH="./data01/phylowgs-master"
INPUT="$PHYLOWGS_PATH/PARSER_OUT/"
OUTPUT_DIR="$PHYLOWGS_PATH/evolve_output_of_CNV/"
mkdir -p "$OUTPUT_DIR"

for fl in "$INPUT"/*_parser_out/; do
    # Extract sample name from folder name
    SAMPLE=$(basename "$fl" | sed 's/_parser_out//')
    echo "Processing sample: $SAMPLE"

    # Define file paths
    SSM_FILE="$fl/${SAMPLE}_ssm_data.txt"
    CNV_FILE="$fl/${SAMPLE}_cnv_data.txt"
    PARAM="$fl/${SAMPLE}_params.json"

    # Check if the required files exist
    if [[ -f "$SSM_FILE" && -f "$CNV_FILE" && -f "$PARAM" ]]; then
        echo "Found required files for sample: $SAMPLE"
        echo "SSM_FILE: $SSM_FILE"
        echo "CNV_FILE: $CNV_FILE"
        echo "PARAM: $PARAM"
        sbatch phylowgs_evolve.sh $PARAM $SSM_FILE $CNV_FILE $OUTPUT_DIR $SAMPLE
    else
        echo "Required files not found for sample: $SAMPLE"
    fi
done
