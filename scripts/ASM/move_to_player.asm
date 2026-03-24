# Set memory location address
# Assumes a SimpleMovementComponent mapped to addresses 32-35
ADD rA r0 32	# Movement Component X velocity setter addr
ADD rB r0 33	# Movement Component Y velocity setter addr
ADD rC r0 34	# Movement Component Z velocity setter addr
ADD rD r0 64	# Detection Component X getter addr
ADD rE r0 65	# Detection Component Y getter addr
ADD rF r0 66	# Detection Component Z getter addr
ADD r9 r0 67	# Detection Component distance getter addr
ADD r8 r0 1		# Closest distance we want to get to
MAIN:
	LDR r1 r9	# Load distance
	JGE r1 r8 MOVE_TO_PLAYER # Move to player if > min distance
	JMP STOP_MOVING		     # Otherwise, stop moving.

MOVE_TO_PLAYER:
	# For each component load the distance, 
	# add 4 to velocity for that direction
	# We'll do a really shit implementation and just
	# have it the velocity set to the distance
	LDR r1 rD	# Load X distance 
	STR r1 rA	# Store distance to velocity
	#LDR r1 rE	# Load Y distance 
	#STR r1 rB	# Store distance to velocity
	LDR r1 rF	# Load Z distance 
	STR r1 rC	# Store distance to velocity
	JMP MAIN

STOP_MOVING:
	STR r0 rA
	STR r0 rB
	STR r0 rC
	JMP MAIN