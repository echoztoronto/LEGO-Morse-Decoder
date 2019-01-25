
	.equ JP1, 0xff200060
	
	.section .text
	.global _LegoInit
	
_LegoInit:

	#=======================Prologue=======================#
	#Callee saved registers used
	addi sp, sp, -12
	stw r16, 0(sp)
	stw r17, 4(sp)
	stw r18, 8(sp)
	#=====================End Prologue=====================#
	
	
	#Basic set up
	
		#Turn off everything
		movia r16, JP1
		movia r17, 0xFFFFFFFF
		stwio r17, (r16)
		
		#Set I/O direction with magic number
		movia r17, 0x07F557FF 
		stwio r17, 4(r16)
		
	#End basic set up
	
	#Set up threshold value for sensor0
	
		movi r17, 0b11111 #For bits 31 to 27 inclusive
		slli r17, r17, 4 #4 spaces for threshold
		#0.....0 0001 1111 0000
		
		or r17, r17, r4 #Putting threshold value in r4
		slli r17, r17, 3 #3 spaces for load, value mode, and unused
		#0.....0 1111 1XXX X000 where XXXX is threshold
		
		#At this point bits 31 to 23 (inclusive) set
		
		ori r17, r17, 0b011 #0 is for load threshold, middle 1 is for value mode, rightmost 1 is unused
		slli r17, r17, 8 #8 spaces for s4~s1 settings, all off
		#0.....0 1111 1XXX X011 0000 0000
		
		ori r17, r17, 0xff #s4~s1 all off
		slli r17, r17, 4 #4 spaces for s0 & m4
		#0.....0 1111 1XXX X011 1111 1111 0000
		
		#At this point bits 31 to 12 (inclusive) set
		
		ori r17, r17, 0xb #s0 is on, to set threshold
		slli r17, r17, 8 #8 spaces for remaining m3~m0
		#1111 1XXX X011 1111 1111 1011 0000 0000
		
		ori r17, r17, 0xff #m3~m0 all off
		#1111 1XXX X011 1111 1111 1011 1111 1111
		
		#At this points all bits set
		
		stwio r17, (r16)
		
	#End set up threshold value for sensor0
	
	#Turn sensors into state mode
		
		#Change Bit 22 (load) to 1 for do not load
		#Change Bit 21 (mode) to 0 for state mode
		movia r18, 0xff9fffff #Only bits 22 and 21 are 0
		and r17, r17, r18 #Only bits 22 and 21 are now 0, rest untouched
		movi r18, 0b10 #Bit 22 = 1 for no load, bit 21 = 0 for state mode
		slli r18, r18, 21
		or r17, r17, r18
		#1111 1XXX X101 1111 1111 1011 1111 1111
		
		#Disabling sensor0
		movi r18, 0b1
		slli r18, r18, 10
		or r17, r17, r18
		#1111 1XXX X101 1111 1111 1111 1111 1111
		
		stwio r17, (r16)
		
	#End turn sensors into state mode
		
		
	#=======================Epilogue=======================#
	#Restoring callee saved registers
	ldw r16, 0(sp)
	ldw r17, 4(sp)
	ldw r18, 8(sp)

	#Restoring sp
	addi sp, sp, 12
	#=====================End Epilogue=====================#
	
ret