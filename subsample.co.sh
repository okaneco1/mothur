#!/bin/bash

# Usage: bash subsample.co.sh <input_R1.fastq.gz> <input_R2.fastq.gz> <input_I1.fastq.gz> <input_I2.fastq.gz> <output_prefix> <subsample_size>


# Input file names
input_R1="$1"
input_R2="$2"
input_I1="$3"
input_I2="$4"

# Output file name
output_prefix="$5"

# Sample size
subsample_size="$6"

# Subsample R1
# zcat to take in .gz files
# Seed set at 100 (-s100) for reproducibility
# gzip to output files as .gz
zcat "$input_R1" | seqtk sample -s100 - "$subsample_size" | gzip > "${output_prefix}_R1.fastq.gz"

# Subsample R2
zcat "$input_R2" | seqtk sample -s100 - "$subsample_size" | gzip > "${output_prefix}_R2.fastq.gz"

# Subsample I1
zcat "$input_I1" | seqtk sample -s100 - "$subsample_size" | gzip > "${output_prefix}_I1.fastq.gz"

# Subsample I2
zcat "$input_I2" | seqtk sample -s100 - "$subsample_size" | gzip > "${output_prefix}_I2.fastq.gz"
