
	.equ TERMINAL, 0xff201000
	
	.section .text
	.global _PrintToTerminal
	
_PrintToTerminal:

	#=======================Prologue=======================#
	#Callee saved registers used
	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)
	#=====================End Prologue=====================#
	
	
	#Print character to terminal
	
		movia r16, TERMINAL
		
		#Check for space to write
		Write_Poll:
			
			ldwio r17, 4(r16)
			srli r17, r17, 16
			beq r17, r0, Write_Poll #If no space we poll / wait
			
		#Mask out character, last byte
		andi r17, r4, 0xff
		stwio r17, (r16) #Write to terminal
	
	#End print character to terminal
	
	
	#=======================Epilogue=======================#
	#Restoring callee saved registers
	ldw r16, 0(sp)
	ldw r17, 4(sp)

	#Restoring sp
	addi sp, sp, 8
	#=====================End Epilogue=====================#
	
ret