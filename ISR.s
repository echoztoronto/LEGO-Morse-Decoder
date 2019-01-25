
	.equ TIMER1, 0xff202000
	.equ LEDR, 0xff200000
	.equ JP1, 0xff200060
	
	.section .exceptions, "ax"
	.global ISR
	
ISR:
	#Note, no register saving here, done within individual
	#Serve_irqX sub functions depending on need
	
	#Uncomment if ISR can be interrupted
	#subi sp, sp, 12
	#stw et, (sp) #Back up of whatever was in et, r24
	#rdctl et, ctl1
	#stw et, 4(sp) #Back up of estatus
	#stw ea, 8(sp) #Back up of ea

	#Timer 1, irq0
		
		rdctl et, ctl4
		andi et, et, 1 #Timer 1 is bit 0, first bit
		bne et, r0, Serve_irq0
	
	#End Timer 1, irq0
	
	#JP1, irq11
	
		rdctl et, ctl4
		srli et, et, 11 #JP1 is bit 11
		andi et, et, 1 
		bne et, r0, Serve_irq11
		
		
	#End JP1, irq11
	
	br exit

	Serve_irq0:

		#=======================Prologue=======================#
		#Callee saved registers used
		addi sp, sp, -32
		stw r16, 0(sp)
		stw r17, 4(sp)
		stw r18, 8(sp)
		stw r19, 12(sp)
		stw r20, 16(sp)
		stw r21, 20(sp)
		stw r22, 24(sp)
		stw r23, 28(sp)
		#=====================End Prologue=====================#

		
		#Acknowledge interrupt
		
			movia r16, TIMER1
			stwio r0, (r16)
			
		#End acknowledge interrupt
		
		#>>>>>>>>>>>>>>>>>>>>>> PORTABLE START
		
		#TEST
		
			#Toggle LEDs
			movia r16, LEDR
			ldwio et, (r16) #Get current state
			movia r17, 0xffffffff #Xor mask
			xor r17, et, r17
			stwio r17, (r16)
			
		#END TEST
		
		#Get from CharReg (current morse sequence)
		#r16 - CharReg addr
		#r17 - CharReg value temp
		
			movia r16, CharReg
			ldw r17, (r16)
			#Prep for next sensor0 reading
			#Note: Extra 0's are fine, LookUpTable removes extra LSB 0's
			slli r17, r17, 1
			
		#End get from CharReg
			
		#Get from SpaceReg (consecutive spaces)
		#r18 - SpaceReg addr
		#r19 - SpaceReg value temp
		
			movia r18, SpaceReg
			ldw r19, (r18)
			
		#End get from SpaceReg
		
		#Read from sensor0
		#r20 - JP1 addr
		#r21 - JP1 value temp
		#r22 - sensor0 state value, 0 = blank, 1 = dot
		#Note: 0 = below, 1 = above threshold; Higher value (i.e. above threshold)
		#means lower light bounced back -> dot
		
			#Get current states from sensors
			movia r20, JP1
			ldwio r21, (r20)
			
			movi r22, 0b1
			slli r22, r22, 27
			and r22, r21, r22 #Mask out bit 27 for sensor0
			#Note: we did not need to shift to bit 0 
			#since we are only checking if it is 0
			
		#End read from sensor0
		
		#Processing
		
			#if r22 == 0 -> below threshold -> white space
			beq r22, r0, Blank
			
			#else r22 != 0 -> above threshold -> black dot
			
				#Checking if current morse sequence is done
				movi r23, 3
				blt r19, r23, Dot #if less than 3 consecutive spaces don't print
						
				#else we need to print
				
					mov r4, r17 #Prep argument for LookUpTable
					call LookUpTable #Character returned in r2
					
					mov r4, r2 #Prep argument for print
					call PrintToTerminal #Printing character to terminal
					
					#Checking if next sequence is part of a new word
					movi r23, 7
					beg r19, r23, Print_Space #if it is we need to print a space
					
					#else we are done
					br Print_Done
					
					Print_Space:
					
						#Print space to terminal
						movi r4, 0x20 #ASCII for space is 0x20
						call PrintToTerminal
						
						#Falls through to Print_Done...
						
					Print_Done:
					
						#New morse sequence starting with a single 1
						movi r17, 1
						stw r17, (r16)
						
						br Reset_SpaceReg
						
			Blank:
			
				#Increment SpaceReg by 1
				addi r19, r19, 1
				stw r19, (r18)
				
				#Put a 0 to current morse sequence
				#Note: already done when we slli at the top
				
				br Blank_Done
				
			Dot:
				
				#We just put a new 1 into morse sequence
				ori r17, r17, 1
				stw r17, (r16)
				
				#Falls through to Reset_SpaceReg
				
			Reset_SpaceReg:
				
				#Reset SpaceReg since not consecutive white space anymore
				stw r0, (r18)
				
				br Dot_Done
				
			Blank_Done:
			Dot_Done:
				
				#Algo is done
		
		#End processing
		
		#>>>>>>>>>>>>>>>>>>>>>> PORTABLE END
		
		
		#=======================Epilogue=======================#
		#Restoring callee saved registers
		ldw r16, 0(sp)
		ldw r17, 4(sp)
		ldw r18, 8(sp)
		ldw r19, 12(sp)
		ldw r20, 16(sp)
		ldw r21, 20(sp)
		ldw r22, 24(sp)
		ldw r23, 28(sp)

		#Restoring sp
		addi sp, sp, 32
		#=====================End Epilogue=====================#
		
		br exit
		
	Serve_irq11:

		#=======================Prologue=======================#
		#Callee saved registers used
		addi sp, sp, -32
		stw r16, 0(sp)
		stw r17, 4(sp)
		stw r18, 8(sp)
		stw r19, 12(sp)
		stw r20, 16(sp)
		stw r21, 20(sp)
		stw r22, 24(sp)
		stw r23, 28(sp)
		#=====================End Prologue=====================#

		
		#Acknowledge interrupt
		
			movia r16, JP1
			movia r17, 0xffffffff
			stwio r17, 12(r16)
			
		#End acknowledge interrupt
		
		#>>>>>>>>>>>>>>>>>>>>>> PORTABLE START
		
		#TEST
		
			#Toggle LEDs
			movia r16, LEDR
			ldwio et, (r16) #Get current state
			movia r17, 0xffffffff #Xor mask
			xor r17, et, r17
			stwio r17, (r16)
			
		#END TEST
		
		#Get from CharReg (current morse sequence)
		#r16 - CharReg addr
		#r17 - CharReg value temp
		
			movia r16, CharReg
			ldw r17, (r16)
			#Prep for next sensor0 reading
			#Note: Extra 0's are fine, LookUpTable removes extra LSB 0's
			slli r17, r17, 1
			
		#End get from CharReg
			
		#Get from SpaceReg (consecutive spaces)
		#r18 - SpaceReg addr
		#r19 - SpaceReg value temp
		
			movia r18, SpaceReg
			ldw r19, (r18)
			
		#End get from SpaceReg
		
		#Read from sensor0
		#r20 - JP1 addr
		#r21 - JP1 value temp
		#r22 - sensor0 state value, 0 = blank, 1 = dot
		#Note: 0 = below, 1 = above threshold; Higher value (i.e. above threshold)
		#means lower light bounced back -> dot
		
			#Get current states from sensors
			movia r20, JP1
			ldwio r21, (r20)
			
			movi r22, 0b1
			slli r22, r22, 27
			and r22, r21, r22 #Mask out bit 27 for sensor0
			#Note: we did not need to shift to bit 0 
			#since we are only checking if it is 0
			
		#End read from sensor0
		
		#Processing
		
			#if r22 == 0 -> below threshold -> white space
			beq r22, r0, Blank
			
			#else r22 != 0 -> above threshold -> black dot
			
				#Checking if current morse sequence is done
				movi r23, 3
				blt r19, r23, Dot #if less than 3 consecutive spaces don't print
						
				#else we need to print
				
					mov r4, r17 #Prep argument for LookUpTable
					call LookUpTable #Character returned in r2
					
					mov r4, r2 #Prep argument for print
					call PrintToTerminal #Printing character to terminal
					
					#Checking if next sequence is part of a new word
					movi r23, 7
					beg r19, r23, Print_Space #if it is we need to print a space
					
					#else we are done
					br Print_Done
					
					Print_Space:
					
						#Print space to terminal
						movi r4, 0x20 #ASCII for space is 0x20
						call PrintToTerminal
						
						#Falls through to Print_Done...
						
					Print_Done:
					
						#New morse sequence starting with a single 1
						movi r17, 1
						stw r17, (r16)
						
						br Reset_SpaceReg
						
			Blank:
			
				#Increment SpaceReg by 1
				addi r19, r19, 1
				stw r19, (r18)
				
				#Put a 0 to current morse sequence
				#Note: already done when we slli at the top
				
				br Blank_Done
				
			Dot:
				
				#We just put a new 1 into morse sequence
				ori r17, r17, 1
				stw r17, (r16)
				
				#Falls through to Reset_SpaceReg
				
			Reset_SpaceReg:
				
				#Reset SpaceReg since not consecutive white space anymore
				stw r0, (r18)
				
				br Dot_Done
				
			Blank_Done:
			Dot_Done:
				
				#Algo is done
		
		#End processing
		
		#>>>>>>>>>>>>>>>>>>>>>> PORTABLE END		
		
		
		#=======================Epilogue=======================#
		#Restoring callee saved registers
		ldw r16, 0(sp)
		ldw r17, 4(sp)
		ldw r18, 8(sp)
		ldw r19, 12(sp)
		ldw r20, 16(sp)
		ldw r21, 20(sp)
		ldw r22, 24(sp)
		ldw r23, 28(sp)

		#Restoring sp
		addi sp, sp, 32
		#=====================End Epilogue=====================#
		
		br exit
	
	exit:

		#Restore stuff saved, if ISR interruptable
		#wrctl ctl0, r0 #Disable interrupts during restore, PIE = 0
		#ldw et, (sp)
		#wrclt estatus, et
		#ldw et, 4(sp)
		#ldw ea, 8(sp)
		#addi sp, sp, 12
		
		subi ea, ea, 4 #Back to interrupted instruction

eret