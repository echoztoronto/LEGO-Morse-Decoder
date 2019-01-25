
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
	
	br exit

	Serve_irq0:

		#=======================Prologue=======================#
		#Callee saved registers used
		addi sp, sp, -8
		stw r16, 0(sp)
		stw r17, 4(sp)
		#=====================End Prologue=====================#

		
		#Acknowledge interrupt
		
			movia r16, TIMER1
			stwio r0, (r16)
			
		#End acknowledge interrupt
		
		#TEST
		
			#Toggle LEDs
			movia r16, LEDR
			ldwio et, (r16) #Get current state
			movia r17, 0xffffffff #Xor mask
			xor r17, et, r17
			stwio r17, (r16)
			
		#END TEST
		
		#Read from sensor0
		
			#Get current states from sensors
			movia r16, JP1
			ldwio r17, (r16)
			
			movi r18, 0b1
			slli r18, r18, 27
			and r18, r17, r18 #Mask out bit 27 for sensor0
			
			#movia r18
		
		#End read from sensor0
		
		
		#=======================Epilogue=======================#
		#Restoring callee saved registers
		ldw r16, 0(sp)
		ldw r17, 4(sp)

		#Restoring sp
		addi sp, sp, 8
		#=====================End Epilogue=====================#
		
		#br exit
	
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