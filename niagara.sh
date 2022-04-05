#!/bin/sh

#SBATCH --time=480
#SBATCH --nodes=1
#SBATCH --array=0-1000:40

module load gnu-parallel
module load gcc/9.4.0

echo "Running on `hostname`"
SCR=${SCRATCH}/flukasims
export FLUPRO=$HOME/fluka

ID=${SLURM_ARRAY_JOB_ID}${SLURM_ARRAY_TASK_ID}
echo $ID
TMP=${SLURM_TMPDIR-$SCR}
echo $TMP
WD=${SCRATCH}/UCNshielding

for i in `seq $ID $((ID+40))`; do
  sed -e "s/SEEDYSEED/`date +%N`/g" ucn.inp > $TMP/ucn$i.inp
done
cd ${SCR}
parallel --lb "time $FLUPRO/bin/rfluka -N0 -M1 -e ${WD}/myfluka $TMP/ucn{}" ::: `seq $ID $((ID+40))`
