#!/bin/sh

export FLUPRO=$HOME/fluka
WD=$SCRATCH/flukasims

#rm ranucn*
#rm run.sh.*
#rm prerun.sh.*
#{ ls ${WD}/ucn*_fort.21; echo ; echo ucn_21.trk; } | $FLUPRO/flutil/ustsuw
#rm ${WD}/ucn*_fort.21
#{ ls ${WD}/ucn*_fort.22; echo ; echo ucn_22.bnn; } | $FLUPRO/flutil/usbsuw
#{ echo ucn_22.bnn; echo ucn_22.bnn.asc; } | $FLUPRO/flutil/usbrea
#rm i${WD}/ucn*_fort.22
#{ ls ${WD}/ucn*_fort.23; echo ; echo ucn_23.rnc; } | $FLUPRO/flutil/usrsuw
#rm ucn_*_fort.23
{ ls -f ${WD}/ucn*_fort.24; echo ; echo ucn_24.bnn; } | $FLUPRO/bin/usbsuw &
{ ls -f ${WD}/ucn*_fort.25; echo ; echo ucn_25.bnn; } | $FLUPRO/bin/usbsuw &
#rm ${WD}/ucn*_fort.24
#head README.md -n16 > READMEn.md
#python sum_flux_energy.py | tail -n27 >> READMEn.md
#mv READMEn.md README.md
#rm *.out
#rm *.err
#rm *.log
#rm fort.11

#param=$(grep '$start_translat' ucn.inp | cut -d ' ' -f 2)
#git add README.md ucn.inp ucn.flair ucn_2*
#git commit -m "Changed offset from target to ${param}cm"
