	#Constants settings
	
		#Timer 1 related
			.equ Interrupt_Cycles, 100000000
			
		#Timer 2 related
		
		#Motor related
			.equ Duty_On_Cycles, 50000000
			.equ Duty_Off_Cycles, 50000000
			.equ Direction, 1 #or 0
		
		#Sensor related
			.equ Sensor_Threshold, 0x8
			.equ Timing_Sensor_Threshold, 0x8
			
	#End constant settings
	
	.section .data
	.align 2
	
		CharReg: .word 0x0
		SpaceReg: .word 0x0
		

	.section .text
	.global _start
	
_start:

	#Init
	
		#Init Stack Pointer
		movia sp, 0x04000000
		
		#Init Lego related
		#Resets all motors
		#Sets up threshold for sensor and puts into statemode
		#Hardcoded for sensor0 as read, sensor2 as timing via interrupt
		movia r4, Sensor_Threshold
		movia r5, Timing_Sensor_Threshold
		call LegoInit
		
		#			#Init Timer 1 with interrupt
		#			#Note that enabling of PIE and clt3 is done inside
		#			movia r4, Interrupt_Cycles
		#			call Timer1InterruptInit
		
	#End init
		
_Main_Loop:

	#Just PWM for motor since reading is done with interrupts
	#Hardcoded for motor2 (3rd/middle one, bits 4 and 5)
	#Motor PWM
	
		movia r4, Direction
		call MotorOn
		
		movia r4, Duty_On_Cycles
		call Timer2Delay
		
		call MotorOff
		
		movia r4, Duty_Off_Cycles
		call Timer2Delay
		
	#End motor PWM
	
	br _Main_Loop;
	
	#Just in case
_End: br _End