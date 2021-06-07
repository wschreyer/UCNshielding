*                                                                      *
*=== fluscw ===========================================================*
*                                                                      *
      DOUBLE PRECISION FUNCTION FLUSCW ( IJ    , PLA   , TXX   , TYY   ,
     &                                   TZZ   , WEE   , XX    , YY    ,
     &                                   ZZ    , NREG  , IOLREG, LLO   ,
     &                                   NSURF )

      INCLUDE 'dblprc.inc'
      INCLUDE 'dimpar.inc'
      INCLUDE 'iounit.inc'
*
*----------------------------------------------------------------------*
*                                                                      *
*     Copyright (C) 2003-2019:  CERN & INFN                            *
*     All Rights Reserved.                                             *
*                                                                      *
*     New version of Fluscw for FLUKA9x-FLUKA20xy:                     *
*                                                                      *
*     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     *
*     !!! This is a completely dummy routine for Fluka9x/200x. !!!     *
*     !!! The  name has been kept the same as for older  Fluka !!!     *
*     !!! versions for back-compatibility, even though  Fluscw !!!     *
*     !!! is applied only to estimators which didn't exist be- !!!     *
*     !!! fore Fluka89.                                        !!!     *
*     !!! User  developed versions  can be used for  weighting !!!     *
*     !!! flux-like quantities at runtime                      !!!     *
*     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     *
*                                                                      *
*     Input variables:                                                 *
*                                                                      *
*           Ij = (generalized) particle code (Paprop numbering)        *
*          Pla = particle laboratory momentum (GeV/c) (if > 0),        *
*                or kinetic energy (GeV) (if <0 )                      *
*    Txx,yy,zz = particle direction cosines                            *
*          Wee = particle weight                                       *
*     Xx,Yy,Zz = position                                              *
*         Nreg = (new) region number                                   *
*       Iolreg = (old) region number                                   *
*          Llo = particle generation                                   *
*        Nsurf = transport flag (ignore!)                              *
*                                                                      *
*     Output variables:                                                *
*                                                                      *
*       Fluscw = factor the scored amount will be multiplied by        *
*       Lsczer = logical flag, if true no amount will be scored        *
*                regardless of Fluscw                                  *
*                                                                      *
*     Useful variables (common SCOHLP):                                *
*                                                                      *
*     Flux like binnings/estimators (Fluscw):                          *
*          ISCRNG = 1 --> Boundary crossing estimator                  *
*          ISCRNG = 2 --> Track  length     binning                    *
*          ISCRNG = 3 --> Track  length     estimator                  *
*          ISCRNG = 4 --> Collision density estimator                  *
*          ISCRNG = 5 --> Yield             estimator                  *
*          JSCRNG = # of the binning/estimator                         *
*                                                                      *
*----------------------------------------------------------------------*
*
      INCLUDE 'scohlp.inc'
*
      LOGICAL LFIRST
      SAVE LFIRST
      DATA LFIRST /.TRUE./
      IF (LFIRST) THEN
         WRITE (LUNOUT,*) 'Called custom fluscw'
         LFIRST = .FALSE.
      ENDIF

      FLUSCW = ONEONE
      LSCZER = .FALSE.

      ! weight neutron dose scoring with SNOOPY response curve
      IF (Ij == 8 .AND. ISCRNG == 2 .AND. JSCRNG < 7) THEN
         IF (-PLA >= 1e-11 .AND. -PLA < 1e-5) THEN
            ! logarithmic increase from 1 to 2 for neutrons between 
            ! 10meV to 10keV
            FLUSCW = 1. + (LOG10(-PLA) + 11.)/6.
         ELSE IF (-PLA >= 1e-5 .AND. -PLA < 1e-4) THEN
            ! drop from 2 to 1.2 between 10keV and 0.1MeV
            FLUSCW = 2. - (LOG10(-PLA) + 5.)*0.8
         ELSE IF (-PLA >= 1e-4 .AND. -PLA < 4e-3) THEN
            ! approximately constant 1.2 between 0.1 and 4MeV
            FLUSCW = 1.2
         ELSE IF (-PLA >= 4e-3 .AND. -PLA < 2e-2) THEN
            ! drop from 1.2 to 0.4 between 4 and 20MeV
            FLUSCW = 1.2 - LOG10(-PLA/4e-3)/LOG10(2e-2/4e-3)*0.8
         ELSE IF (-PLA >= 2e-3) THEN
            ! not sensitive above 20MeV
            FLUSCW = 0.
         ENDIF
      ENDIF

      ! RPG applies safety factor 2 to all Snoopy readings
      FLUSCW = FLUSCW*2.

      RETURN
*=== End of function Fluscw ===========================================*
      END

