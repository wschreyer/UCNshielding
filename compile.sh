#!/bin/sh

export FLUPRO=$HOME/fluka
export FLUFOR=gfortran
rm -f usimbs.o
rm -f fluscw.o
$FLUPRO/bin/fff usimbs.f
$FLUPRO/bin/fff fluscw.f
rm -f myfluka.map myfluka
$FLUPRO/bin/ldpmqmd -o myfluka usimbs.o fluscw.o
