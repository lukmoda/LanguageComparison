PROGRAM buffon_needle ! program to estimate pi from a Monte Carlo simulation 
		      ! applied to Buffon's Needle

IMPLICIT NONE

REAL :: ang, &    ! angle from needle's center in relation to horizontal 
	pos, &    ! center's distance in relation to the line
	start, &  ! store execution time
	finish, &     
	l         ! needle's length (arbitrary)


REAL*8, DIMENSION ( : ), ALLOCATABLE :: piest, & ! pi estimate  
					sig      ! error estimate

INTEGER :: N, &    ! number of entries
 	   cont, & ! counts needles that fall on line
	   i

INTEGER, DIMENSION ( : ), ALLOCATABLE :: lanc ! array of number of throws
					

REAL*8, PARAMETER :: PI = 3.14159265359


l = 1. ! just to simplify
cont = 0
CALL srand (423) ! random seed

WRITE(*, "(/, A)"), "Numero de entries: "
READ*, N

ALLOCATE (lanc(N)); ALLOCATE (piest(N)); ALLOCATE (sig(N)); 

WRITE(*, "(/, A)"), "Type the array of number of throws: "

DO i=1, N
	
	READ*, lanc(i)	

END DO 


WRITE (*, "(/, A, A, A, A, A, A, /)") "          N", "       Pi", "        Exp Error", "    Real Error", &
									"   Exp-Real","       Time"

DO i=1,N
	
	CALL CPU_TIME(start)  ! intrinsic function to measure execution time. Latency of ~ 4E-3 seg
	CALL mc_needle (ang, pos, l, cont, lanc(i), piest(i), sig(i))
	CALL CPU_TIME(finish) 
	WRITE(*, "(I12, F12.6, F12.6, F12.6, F12.6, F12.3)"), lanc(i), piest(i), sig(i), ABS(PI-piest(i)), & 
							     (ABS(sig(i)-ABS(piest(i)-PI))), finish-start

END DO

									
END PROGRAM buffon_needle

SUBROUTINE mc_needle (ang, pos, l, cont, needle, piest, sig) 
							   
	IMPLICIT NONE
	REAL, INTENT (inout) :: ang, pos, l
	REAL*8, INTENT (inout) :: piest, sig 
	INTEGER, INTENT (in) :: needle
	INTEGER, INTENT (inout) :: cont
	INTEGER :: k
	REAL*8, PARAMETER :: PI = 3.14159265359

	DO k=1, needle	 
		ang = rand () * PI/2 ! random angle between 0 and pi/2
	  	pos = rand () * l    ! random number between 0 e l
	  	 IF (l/2. * COS(ang) >= pos) THEN ! condition for needle to fall on the line
	    		 cont = cont + 1          ! updates count 
	  	 END IF 
	END DO

 	piest = DBLE(needle)/cont      ! pi estimate
	sig = piest/SQRT(REAL(needle)) ! experimental error
	cont = 0

END SUBROUTINE mc_needle

