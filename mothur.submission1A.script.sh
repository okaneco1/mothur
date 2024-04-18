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

### call your executable--Modify for correct script name
/usr/bin/time -v mothur mothur_batch_script_submission1A.txt

### summary info about the job
scontrol show job <Job ID>
