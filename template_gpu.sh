#!/bin/bash
# Job name:
# (change the JOB_NAME to your own name)
#SBATCH --job-name=JOB_NAME
#
# Account:
#SBATCH --account=co_esmath
#
# Partition:
#SBATCH --partition=savio3_gpu
#
# Number of MPI tasks needed:
#SBATCH --ntasks=1
#
# Processors per task:
#SBATCH --cpus-per-task=4
#
#SBATCH --gres=gpu:GTX2080TI:2
#
# Wall clock limit:
#SBATCH --time=72:00:00
#
#
# Mail type:
#SBATCH --mail-type=BEGIN,END,FAIL
#
# Mail user:
# (change the email address below to your own address)
#SBATCH --mail-user=EMAIL_ADDRESS
#
# Command(s) to run:
source /global/home/users/${USER}/.bashrc
module load python
module load cuda/11.2

# conda activate python env (change CONDA_ENV_NAME to your env name)
source activate CONDA_ENV_NAME
export XLA_FLAGS=--xla_gpu_cuda_data_dir=/global/software/sl-7.x86_64/modules/langs/cuda/11.2


# change the directory to the directory where you submitted the job
# (change DIR to your directory)
cd DIR

# run the command
# (change main.py to your python file name) 
python main.py
