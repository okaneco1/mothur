#!/bin/bash -login
 
### define resources needed

### you can give your job a name for easier identification
#SBATCH --job-name=12S_2pdiffs_submission1A

### mem: amount of memory that the job will need
#SBATCH --mem=30G

### walltime - how long you expect the job to run; for 12S 8h; for 16S 24h; just add a space to the line you dont want to use
#SBATCH --time=8:00:00

### nodes:ppn - how many nodes you require
#SBATCH --nodes=1 

### nodes:ppn - how many cores per node (ppn) that you require
#SBATCH --cpus-per-task=16

### 1.option: specify where you want your jobs output files to go and give a filename; or 2.option: in the job submission folder and x=jobs name, j=job ID
#SBATCH --output=%x-%j.SLURMout

### Mail type 
#SBATCH --mail-type=ALL

### e-mail for when something goes wrong etc. you will get notified
#SBATCH --mail-user=okaneco1@msu.edu


### load necessary modules
module purge
module load vsearch/2.16.0
module load GCC/8.2.0-2.31.1  OpenMPI/3.1.3
module load Mothur/1.46.1-Python-3.7.2    


### change to the working directory where your code is located
cd /mnt/home/okaneco1/SeaLampreyProject/submission1/seqs


### run make contigs ("" + # symbol tells mothur that it's only running one command, not a batch file)
### may want to change this command to one line (no returns) before uploading and using. 
### you may also want to use 'dos2unix' after upload as well as 'chmod 777'
mothur "#make.contigs(ffastq=./CO@12S@Sub1@A@020824@S1@L001@R1@001.fastq.gz, rfastq=./CO@12S@Sub1@A@020824@S1@L001@R2@001.fastq.gz, findex=./CO@12S@Sub1@A@020824@S1@L001@I1@001.fastq.gz, rindex=./CO@12S@Sub1@A@020824@S1@L001@I2@001.fastq.gz, oligos=./submission1_12S_libA_oligos.txt, pdiffs=2, trimoverlap = TRUE)"

### rename output files from make.contigs (make sure to change file name)
mv CO@12S@Sub1@A@020824@S1@L001@R1@001.trim.contigs.fasta stability.trim.contigs.fasta
mv CO@12S@Sub1@A@020824@S1@L001@R1@001.contigs.groups stability.contigs.groups
mv CO@12S@Sub1@A@020824@S1@L001@R1@001.contigs.report stability.contigs.report
mv CO@12S@Sub1@A@020824@S1@L001@R1@001.trim.contigs.qual stability.trim.contigs.qual
≈
### call your executable--Modify for correct script name
/usr/bin/time -v mothur mothur_batch_script_submission1A.txt

### summary info about the job
scontrol show job <Job ID>


