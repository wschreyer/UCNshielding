#!/bin/sh

module load gcc/7.3.0
export FLUPRO=$HOME/fluka
export FLUFOR=gfortran
$FLUPRO/flutil/fff usimbs.f
$FLUPRO/flutil/lfluka -o myfluka -m fluka usimbs.o
module load gcc/5.4.0
