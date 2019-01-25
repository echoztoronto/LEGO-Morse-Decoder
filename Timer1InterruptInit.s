	
	.equ TIMER1, 0xff202000
	
	.section .text
	.global _TIMER1InterruptInit
	
_TIMER1InterruptInit:

	#=======================Prologue=======================#
	#Callee saved registers used
	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)
	#=====================End Prologue=====================#
	
		
	#Set up for Timer 1
	
		movia r16, TIMER1
		
		#Set lower 4 bits for time
		movia r17, 0xFFFF #Mask for lower 16 bits
		and r17, r4, r17
		stwio r17, 8(r16)
		
		#Set upper 4 bits for time
		movia r17, 0xFFFF0000 #Mask for upper 16 bits
		and r17, r4, r17
		srli r17, r17, 16
		stwio r17, 12(r16)
		
		#Set time out to 0
		stwio r0, (r16)
		
		#Start TIMER1 with continuous and interrupt enabled
		movi r17, 0b0111
		stwio r17, 4(r16)
		
	#End set up for Timer 1
		
	#Set up processor to allow interrupt from Timer 1
	
		movi r17, 1
		rdctl r16, ctl3
		or r16, r16, r17 #Does not disable existing interrupts
		wrctl ctl3, r16 #Enables timer to interrupt
		wrctl ctl0, r17 #Global interrupt enable, PIE
		
	#End set up for processor
		
		
	#=======================Epilogue=======================#
	#Restoring callee saved registers
	ldw r16, 0(sp)
	ldw r17, 4(sp)

	#Restoring sp
	addi sp, sp, 8
	#=====================End Epilogue=====================#
	
ret
