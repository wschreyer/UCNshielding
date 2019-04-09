#!/bin/sh

#SBATCH --time=480
#SBATCH --mem=1000M
#PBS -l walltime=08:00:00

echo "Running on `hostname`"
SCR=/home/wschreye/scratch
export FLUPRO=/home/wschreye/fluka

ID=${SLURM_ARRAY_JOB_ID}${SLURM_ARRAY_TASK_ID}
echo $ID
TMP=${SLURM_TMPDIR-$SCR}
echo $TMP
WD=${HOME}/UCNshielding

sed -e "s/MYSEED/`date +%N | head -c 6`/g" ucn.inp > $TMP/ucn$ID.inp
cd ${SCR}
time $FLUPRO/flutil/rfluka -N0 -M1 -e ${WD}/myfluka $TMP/ucn$ID
rm -f $TMP/ucn$ID.inp
rm -f $TMP/ranucn${ID}001
rm -f $TMP/ucn${ID}001.log
