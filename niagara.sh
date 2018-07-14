#!/bin/sh

#SBATCH --time=480
#SBATCH --nodes=1
#SBATCH --array=0,40,80,120,160,200

echo "Running on `hostname`"
SCR=${SCRATCH}
export FLUPRO=$HOME/fluka

ID=${SLURM_ARRAY_TASK_ID-0}
echo $ID
TMP=${SLURM_TMPDIR-$SCR}
echo $TMP
WD=${HOME}/UCNshielding

for i in `seq $ID $((ID+40))`; do
  sed -e "s/MYSEED/`date +%N | head -c 6`/g" ucn.inp > $TMP/ucn$i.inp
done
cd ${SCR}
parallel --lb "time $FLUPRO/flutil/rfluka -N0 -M1 -e ${WD}/myfluka $TMP/ucn{}" ::: `seq $ID $((ID+40))`
