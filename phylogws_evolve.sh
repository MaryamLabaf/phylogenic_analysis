#!/usr/bin/bash

#SBATCH --job-name=phyloGWS_evolve                                                                                                                                                                           

### Math setting                                                                                                                                                                                     
#SBATCH -n 10                                                                                                                                                                                         
#SBATCH --account=math                                                                                                                                                                               
#SBATCH --time=00-80:00:00                                                                                                                                                                           
#SBATCH --mem=500gb                                                                                                                                                                                   
#SBATCH --partition=Intel                                                                                                                                                                                                                                                                                                                               
#SBATCH --error="logs/"%x-%j.err                                                                                                                                                                    
#SBATCH --output="logs/"%x-%j.out                                                                                                                                                                   

### Array job                                                                                                                                                                                        
##SBATCH --array=0-1000:10                                                                                                                                                                           
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mlabaf@bidmc.harvard.edu


##SBATCH --export=NONE                                                                                                                                                                               
##. /etc/profile  

module load gnu9/9.3.0
module load gsl-2.5-gcc-10.2.0-eu4v22u
module load python-2.7.18-gcc-10.2.0-h5x5w3p

g++ -o mh.o -O3 mh.cpp  util.cpp `gsl-config --cflags --libs`

PHYLOWGS_PATH="./data01/phylowgs-master"
mkdir -p $4$5"_chains"
python2 $PHYLOWGS_PATH/multievolve.py --params $1 --num-chains 18 --ssms $2 --cnvs $3 \
                                      --output-dir $4$5"_chains"  \
                                      --burnin-samples 1000 \
                                      --mcmc-samples 2500

echo "Finish Run"
echo "end time is `date`"



