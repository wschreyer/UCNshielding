*$ CREATE USIMBS.FOR
*COPY USIMBS
*
*=== Usimbs ===========================================================*
*
      SUBROUTINE USIMBS ( MREG, NEWREG, FIMP )

      INCLUDE '(DBLPRC)'
      INCLUDE '(DIMPAR)'
      INCLUDE '(IOUNIT)'
*
*----------------------------------------------------------------------*
*                                                                      *
*     Copyright (C) 2001-2008      by    Alfredo Ferrari & Paola Sala  *
*     All Rights Reserved.                                             *
*                                                                      *
*                                                                      *
*     USer defined IMportance BiaSing:                                 *
*                                                                      *
*     Created on   02 july 2001    by    Alfredo Ferrari & Paola Sala  *
*                                                   Infn - Milan       *
*                                                                      *
*     Last change on 30-oct-08     by    Alfredo Ferrari               *
*                                                                      *
*     Input variables:                                                 *
*                Mreg = region at the beginning of the step            *
*              Newreg = region at the end of the step                  *
*     (thru common TRACKR):                                            *
*              Jtrack = particle id. (Paprop numbering)                *
*              Etrack = particle total energy (GeV)                    *
*       X,Y,Ztrack(0) = position at the beginning of the step          *
*  X,Y,Ztrack(Ntrack) = position at the end of the step                *
*                                                                      *
*    Output variable:                                                  *
*                Fimp = importance ratio (new position/original one)   *
*                                                                      *
*----------------------------------------------------------------------*
*
      INCLUDE '(TRACKR)'
*
      FIMP   = ONEONE

*     UCN target
*      X0 = 436
*      Y0 = 596
*      Z0 = 144

*     T1
*      X0 = 207.6
*      Y0 = 964.2
*      Z0 = 137.16

*     BL1A1
*      X0 = -600.0
*      Y0 = 958.92
*      Z0 = 137.16

*     BL1A2
      X0 = -250.0
      Y0 = 958.92
      Z0 = 137.16
  
      X1 = Xtrack(0) - X0
      Y1 = Ytrack(0) - Y0
      Z1 = Ztrack(0) - Z0
      X2 = Xtrack(Ntrack) - X0
      Y2 = Ytrack(Ntrack) - Y0
      Z2 = Ztrack(Ntrack) - Z0
  
      R1 = sqrt(Y1**2+Z1**2)
      R2 = sqrt(Y2**2+Z2**2)


      IF ( R1 .GT. 650 ) R1 = 650
      IF ( R2 .GT. 650 ) R2 = 650
      FIMP = EXP( (R2 - R1)/30. )

      RETURN
*
*======================================================================*
*                                                                      *
*     Entry USIMST:                                                    *
*                                                                      *
*     Input variables:                                                 *
*                Mreg = region at the beginning of the step            *
*                Step = length of the particle next step               *
*                                                                      *
*    Output variable:                                                  *
*                Step = possibly reduced step suggested by the user    *
*                                                                      *
*======================================================================*
*
      ENTRY USIMST ( MREG, STEP )
*
      IF ( STEP .GT. ONEONE ) STEP = HLFHLF * STEP
      RETURN
*=== End of subroutine Usimbs =========================================*
      END

