
	.equ JP1, 0xff200060
	
	.section .text
	.global _MotorOff
	
_MotorOff:

	#=======================Prologue=======================#
	#Callee saved registers used
	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)
	#=====================End Prologue=====================#
	
	
	#Turn on Motor 0 on based on given directions
	
		#Get existing values
		movia r16, JP1
		ldwio r17, (r16)
		
		movia r16, 0xffffffcf #Only bits 4 and 5 are 0
		and r17, r16, r17 #Now bits 4 and 5 are set to 0, rest untouched
		
		movi r16, 0b11 #Turn off motor
		slli r16, r16, 4 #Since motor2, bits 4 and 5
		
		or r17, r16, r17 #Put with previous numbers
		
		#Load it in
		movia r16, JP1
		stwio r17, (r16)
		
	#End turn on Motor 0 on based on given directions
		
		
	#=======================Epilogue=======================#
	#Restoring callee saved registers
	ldw r16, 0(sp)
	ldw r17, 4(sp)

	#Restoring sp
	addi sp, sp, 8
	#=====================End Epilogue=====================#
	
ret