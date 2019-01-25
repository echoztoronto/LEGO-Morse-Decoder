
	.equ ADDR_AUDIODACFIFO, 0xFF203040

	.section .data

		SHORT_WAV:
		.incbin "short.wav"

		LONG_WAV:
		.incbin "long.wav"

		END_OF_FILES: 


	.section .text
	.global _Sound

_Sound:

	#=======================Prologue=======================#
	#Callee saved registers used
	addi sp, sp, -20
	stw r16, 0(sp)
	stw r17, 4(sp)
	stw r18, 8(sp)
	stw r19, 12(sp)
	stw r20, 16(sp)
	#=====================End Prologue=====================#

	
	movia r16, ADDR_AUDIODACFIFO
	
	bne r4, r0, Dash #1 for Dash, 0 for Dot

	#Dot sound
	Dot:
	
		movia r17, SHORT_WAV
		movia r18, LONG_WAV

		SHORT_LOOP:
		movi r19, 500
		delay:
		addi r19, r19, -1
		bne r19, r0, delay

		ldwio r20, 0(r17)
		stwio r20, 8(r16)   # left
		stwio r20, 12(r16)  # right

		addi r17, r17, 1
		bne r17, r18, SHORT_LOOP

		br _End
		
	#End dot sound

	#Dash sound
	Dash:
	
		PLAY_LONG:
		movia r17, LONG_WAV
		movia r18, END_OF_FILES

		LONG_LOOP:
		movi r19, 500
		delay:
		addi r19, r19, -1
		bne r19, r0, delay

		ldwio r20, 0(r17)
		stwio r20, 8(r16)   # left
		stwio r20, 12(r16)  # right

		addi r17, r17, 1
		bne r17, r18, LONG_LOOP
		
	#End dash sound

	
_End:

	#=======================Epilogue=======================#
	#Restoring callee saved registers
	ldw r16, 0(sp)
	ldw r17, 4(sp)
	ldw r18, 8(sp)
	ldw r19, 12(sp)
	ldw r20, 16(sp)

	#Restoring sp
	addi sp, sp, 20
	#=====================End Epilogue=====================#
	
ret

