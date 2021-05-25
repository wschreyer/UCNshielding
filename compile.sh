#!/bin/sh

module unload StdEnv/2020
module load nixpkgs/16.09
module load gcc/7.3.0
export FLUPRO=$HOME/fluka
export FLUFOR=gfortran
rm -f usimbs.o
rm -f fluscw.o
$FLUPRO/bin/fff usimbs.f
$FLUPRO/bin/fff fluscw.f
rm -f myfluka.map myfluka
$FLUPRO/bin/ldpmqmd -o myfluka usimbs.o fluscw.o
