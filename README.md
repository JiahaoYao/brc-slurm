# brc-slurm
This is the manual for the head start at berkeley research computing cluster

##### logging in 

```bash
ssh username@hpc.brc.berkeley.edu
```

##### working place

-   `/global/home/username` only have 10 GB limit
-   `/global/scratch/<username>` has infinite storage

##### transferring data

```bash
# sending to the server
scp (-r) local_path/A username@dtn.brc.berkeley.edu:path/A
# receive from the server
scp (-r) username@dtn.brc.berkeley.edu:path/A local_path/A 
```

##### Making vim available!

```bash 
wget https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim
mv basic.vim ~/.vimrc
```

###### vim basics
- <kbd>i</kbd>: insert before the cursor
- <kbd>Esc</kbd>: exit insert mode
- <kbd>Esc</kbd>+<kbd>:w</kbd>: write (save) the file, but don't exit
- <kbd>Esc</kbd>+<kbd>:q</kbd>: quit (fails if there are unsaved changes)
- <kbd>Esc</kbd>+<kbd>:q!</kbd>: quit and throw away unsaved changes

##### ~~Install the anaconda~~ (OUTDATED!)
- Download the [anaconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html)
```bash 
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
bash Anaconda3-2020.11-Linux-x86_64.sh
```

- add the path
```bash 
echo 'export PATH=“/global/scratch/<username>/<anaconda-path>/bin:$PATH”' >> ~/.bashrc
source ~/.bashrc
```


##### use anaconda (OUTDATED!)

```python
module load python
```

Then, create the conda environment as usual. 

Since the disk quota in the local storage is limited, we need to change the location using the following commands (https://stackoverflow.com/questions/67610133/how-to-move-conda-from-one-folder-to-another-at-the-moment-of-creating-the-envi)

```markdown
# create a new pkgs_dirs (wherever, doesn't have to be hidden)
mkdir -p /big_partition/users/user/.conda/pkgs

# add it to Conda as your default
conda config --add pkgs_dirs /big_partition/users/user/.conda/pkgs

# create a new envs_dirs (again wherever)
mkdir -p /big_partition/users/user/.conda/envs

# add it to Conda as your default
conda config --add envs_dirs /big_partition/users/user/.conda/envs
```

- use cuda on brc

```markdown
module load cuda/10.2
export XLA_FLAGS=--xla_gpu_cuda_data_dir=/global/software/sl-7.x86_64/modules/langs/cuda/10.2
```


##### adding the software

<ul>
  <li><code class="highlighter-rouge">module avail</code> - List all available modulefiles.</li>
  <li><code class="highlighter-rouge">module list</code> - List modules loaded.</li>
  <li><code class="highlighter-rouge">module add|load _modulefile_ ...</code> - Load modulefile(s).</li>
  <li><code class="highlighter-rouge">module rm|unload _modulefile_ ...</code> - Remove modulefile(s).</li>
</ul>

###### Example

if the code uses matlab, make sure you load the matlab module: `module load matlab`

##### Running the jobs

<ul>
	<li><code>sbatch myjob.sh</code>&nbsp;- Submit a job, where <code>myjob.sh</code>&nbsp;is a SLURM job script. </li>
    <li><code>squeue -u $USER</code>&nbsp;- Check your current jobs</li>
	<li><code>scancel [jobid]</code><code>&nbsp;</code>- Cancel a job with a job ID from `squeue -u $USER`</li>
	<li><code>sinfo</code>&nbsp;- View the status of the cluster's compute nodes</li>
</ul>

-   `sacctmgr -p show associations user=$USER` --- show which partition can be used in the account



One example of ` myjob.sh`

```
#!/bin/bash
# Job name:
#SBATCH --job-name=test
#
# Account:
#SBATCH --account=co_esmath
#
# Partition:
#SBATCH --partition=savio3
#
# Quality of Service:
#SBATCH --qos=esmath_savio3_normal
# Number of nodes: 
#SBATCH --nodes=1
# Processors per task 
#SBATCH --cpus-per-task=2
#
# Wall clock limit:
#SBATCH --time=24:00:00
# Email Notification
#SBATCH --mail-type=END, FAIL
#SBATCH --mail-user=google@gmail.com
#
## Command(s) to run:


# load some necessary software
module load matlab mpi 

# if one use conda for the python environment
conda activate myenv

# run my jobs
bash myscript.sh

# python jobs
python myscript.py

# matlab jobs
matlab < main.m 
```



One example of ` myjob.sh` (**GPU Instance**)

```
#!/bin/bash
# Job name:
#SBATCH --job-name=test
#
# Account:
#SBATCH --account=co_esmath
#
# Partition:
#SBATCH --partition=savio3_gpu
#
# Quality of Service:
#SBATCH --qos=esmath_gpu3_normal
# Number of nodes: 
#SBATCH --nodes=1
# Processors per task 
#SBATCH --cpus-per-task=2
#
#SBATCH --gres=gpu:GTX2080TI:1
# Wall clock limit:
#SBATCH --time=24:00:00
# Email Notification
#SBATCH --mail-type=END, FAIL
#SBATCH --mail-user=google@gmail.com
#
## Command(s) to run:

# load gpu related 
module load gcc openmpi
module load cuda/11.2
module load cudnn/7.0.5
export CUDA_PATH=/global/software/sl-7.x86_64/modules/langs/cuda/11.2
export LD_LIBRARY_PATH=$CUDA_PATH/lib64:$LD_LIBRARY_PATH
 
# if one use conda for the python environment
conda activate myenv

# python jobs
XLA_FLAGS=--xla_gpu_cuda_data_dir=/global/software/sl-7.x86_64/modules/langs/cuda/11.2 python myscript.py
```

-   you can find the [hardware config](https://docs-research-it.berkeley.edu/services/high-performance-computing/user-guide/hardware-config)

### advanced usage
```bash
pip install sysflow
```

##### config the slurm  
```bash
slurm config 
```

##### run the jobs
```bash
slurm run [python test.py --arg1 5 --arg2 3]
```

##### examples in python 
```python
from sysflow.job.slurm import Slurm

# use the last config
slurm = Slurm()

# change the config 
# slurm = Slurm(job_name='hello-word', email='abc@abc.com', conda_env='qrl')

# change the account or partition
# slurm = Slurm(account='co_esmath', qos='esmath_savio3_normal', partition='savio3')

slurm.run('python test.py')
```
```bash 
slurm config --account fc_esmath --qos savio_normal
slurm config --account co_esmath --qos esmath_savio3_normal --partition savio3 --task_per_node 32
slurm config --account co_esmath --qos savio_lowprio --partition savio2 --task_per_node 24
```


### Reference

-   [official reference](https://docs-research-it.berkeley.edu/services/high-performance-computing/user-guide/)
-   [others (chinese)](http://bicmr.pku.edu.cn/~wenzw/pages/slurm.html)
-   [cheatsheet](https://arc.umich.edu/wp-content/uploads/sites/4/2020/05/Great-Lakes-Cheat-Sheet.pdf)
