	
	.equ TIMER2, 0xff202020
	
	.section .text
	.global _TIMER2Delay
	
_TIMER2Delay:

	#=======================Prologue=======================#
	#Callee saved registers used
	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)
	#=====================End Prologue=====================#
	

	#Set up for Timer 2
	
		movia r16, TIMER2
		
		#Set lower 16 bits for time
		movia r17, 0xFFFF #Mask for lower 16 bits
		and r17, r4, r17
		stwio r17, 8(r16)
		
		#Set upper 16 bits for time
		movia r17, 0xFFFF0000 #Mask for upper 16 bits
		and r17, r4, r17
		srli r17, r17, 16
		stwio r17, 12(r16)
		
		#Set time out to 0
		stwio r0, (r16)
		
		#Start TIMER2
		movi r17, 0b0100
		stwio r17, 4(r16)
		
	#End set up for Timer 2
	
	#Poll for time out
	
		Poll:
			
			#Retreive value
			ldwio r17, (r16)
			
			#Mask out time out bit
			andi r17, r17, 0x0001
			
			#Keep checking till time out
			beq r17, r0, Poll
			
	#End poll for time out
		
		
	#=======================Epilogue=======================#
	#Restoring callee saved registers
	ldw r16, 0(sp)
	ldw r17, 4(sp)

	#Restoring sp
	addi sp, sp, 8
	#=====================End Epilogue=====================#
	
ret