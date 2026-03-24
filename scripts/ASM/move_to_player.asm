# Set memory location address
# Assumes a SimpleMovementComponent mapped to addresses 32-35
ADD r2 r0 34		# r2 holds z-axis address
ADD r3 r0 5		# r3 holds max speed
NEG r4 r3		# r4 holds min speed
INCREASE:
	ADD r1 r1 1
	STR r1 r2
	JLE r1 r3 INCREASE
	NOP
DECREASE:
	SUB r1 r1 1
	STR r1 r2
	JGE r1 r4 DECREASE
	JMP INCREASE
