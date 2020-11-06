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
ssh (-r) local_path/A username@dtn.brc.berkeley.edu:path/A
# receive from the server
ssh (-r) username@dtn.brc.berkeley.edu:path/A local_path/A 
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

python myscript.py

matlab main.m
```

-   you can find the [hardware config](https://docs-research-it.berkeley.edu/services/high-performance-computing/user-guide/hardware-config)



### Reference

-   [official reference](https://docs-research-it.berkeley.edu/services/high-performance-computing/user-guide/)
-   [others (chinese)](http://bicmr.pku.edu.cn/~wenzw/pages/slurm.html)

