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
      INCLUDE '(FLKMAT)'
*      CHARACTER(len=8) :: MNAM
*
      FIMP   = ONEONE

*     UCN target
*      X0 = 436
*      Y0 = 596
*      Z0 = 144

*     BL1A
*      X0 = 207.6
*      Y0 = 964.2
*      Z0 = 137.16

*     BL1A1
      X0 = -600.0
      Y0 = 958.92
      Z0 = 137.16

*     BL1A2
*      X0 = -250.0
*      Y0 = 958.92
*      Z0 = 137.16
  
*     BL1A3
*      X0 = 100.0
*      Y0 = 958.92
*      Z0 = 137.16

*     BL1A4
*      X0 = 700.0
*      Y0 = 958.92
*      Z0 = 137.16

*     BL1U1
*      X0 = -600.0
*      Y0 = 888.24
*      Z0 = 144.145

*     BL1U2
*      X0 = -250.0
*      Y0 = 787.9
*      Z0 = 144.145

*     BL1U3
*      X0 = 100.0
*      Y0 = 687.5
*      Z0 = 144.145

      X1 = Xtrack(0) - X0
      Y1 = Ytrack(0) - Y0
      Z1 = Ztrack(0) - Z0
      X2 = Xtrack(Ntrack) - X0
      Y2 = Ytrack(Ntrack) - Y0
      Z2 = Ztrack(Ntrack) - Z0

      IF (Z1 .LT. -Z0) Z1 = -Z0
      IF (Z2 .LT. -Z0) Z2 = -Z0

      IF (Ytrack(0) .GT. 1000) Y1 = 1000 - Y0
      IF (Ytrack(Ntrack) .GT. 1000) Y2 = 1000 - Y0
  
      R1 = sqrt(X1**2 + Y1**2 + Z1**2)
      R2 = sqrt(X2**2 + Y2**2 + Z2**2)

      IF ( R1 .LT. 10.0 ) R1 = 10.0
      IF ( R2 .LT. 10.0 ) R2 = 10.0
*      IF ( R1 .GT. 900.0 ) R1 = 900.0
*      IF ( R2 .GT. 900.0 ) R2 = 900.0
      
*      IF ((MREG .EQ.  3) .OR. (MREG .EQ. 19) .OR. 
*     &    (MREG .EQ. 20) .OR. (MREG .EQ. 21) .OR. 
*     &    (MREG .EQ. 27) .OR. (MREG .EQ. 28) .OR. 
*     &    (MREG .EQ. 29) .OR. (MREG .EQ. 32) .OR. 
*     &    (MREG .EQ. 33) ) THEN
*         R1 = 0.0
*      END IF
*      IF ((NEWREG .EQ.  3) .OR. (NEWREG .EQ. 19) .OR. 
*     &    (NEWREG .EQ. 20) .OR. (NEWREG .EQ. 21) .OR. 
*     &    (NEWREG .EQ. 27) .OR. (NEWREG .EQ. 28) .OR. 
*     &    (NEWREG .EQ. 29) .OR. (NEWREG .EQ. 32) .OR. 
*     &    (NEWREG .EQ. 33) ) THEN
*         R1 = 0.0
*      END IF

*      CALL GEOR2N(MREG, MNAM, IERR)
*      print *,MREG
*      print *,MNAM
*      print *,IERR

      MMAT = MEDFLK(MREG,1)
      NEWMAT = MEDFLK(NEWREG,1)
      R3 = R1
      R4 = R2
      IF ((RHO(MMAT) .LT. 0.01) .AND. (RHO(NEWMAT) .LT. 0.01)) R4 = R3

      FIMP = (R2/R1)**2 * EXP( (R4 - R3)/30. )

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

