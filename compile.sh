#!/bin/sh

module load gcc/9.1.0
export FLUPRO=$HOME/fluka
export FLUFOR=gfortran
rm -f usimbs.o
$FLUPRO/flutil/fff usimbs.f
rm -f myfluka.map myfluka
$FLUPRO/flutil/ldpmqmd -o myfluka usimbs.o
module load gcc/5.4.0
