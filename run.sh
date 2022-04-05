#!/bin/sh

###SBATCH --account=rrg-rpicker
#SBATCH --time=480
#SBATCH --mem=1000M

echo "Running on `hostname`"
SCR=$SCRATCH/flukasims
export FLUPRO=/home/wschreye/fluka

ID=${SLURM_ARRAY_JOB_ID}${SLURM_ARRAY_TASK_ID}
echo $ID
TMP=${SLURM_TMPDIR-$SCR}
echo $TMP
WD=$SCRATCH/UCNshielding

sed -e "s/SEEDYSEED/`date +%N`/g" ucn.inp > $TMP/ucn$ID.inp
cd ${SCR}
time $FLUPRO/bin/rfluka -N0 -M1 -e ${WD}/myfluka $TMP/ucn$ID
rm -f $TMP/ucn$ID.inp
rm -f $TMP/ranucn${ID}001
rm -f $TMP/ucn${ID}001.log
