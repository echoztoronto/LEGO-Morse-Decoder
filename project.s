	#Constants settings
	
		#Timer 1 related
			.equ Interrupt_Cycles, 100000000
			
		#Timer 2 related
		
		#Motor related
			.equ Duty_On_Cycles, 4000000
			.equ Duty_Off_Cycles, 100000000
			.equ Direction, 0 #or 0
		
		#Sensor related
			.equ Sensor_Threshold, 0xa0
			
	#End constant settings

	.section .text
	.global _start
	
_start:

	#Init
	
		#Init Stack Pointer
		movia sp, 0x04000000
		
		#Init Lego related
		#Resets all motors
		#Sets up threshold for sensor and puts into statemode
		#Hardcoded for sensor0
		#Note: State mode not in interrupt mode
		movia r4, Sensor_Threshold
		call _LegoInit
		
		#Init Timer 1 with interrupt
		#Note that enabling of PIE and clt3 is done inside
		movia r4, Interrupt_Cycles
		call _TIMER1InterruptInit
		
	#End init
		
_Main_Loop:

	#Just PWM for motor since reading is done with interrupts
	#Hardcoded for motor2 (3rd/middle one, bits 4 and 5)
	#Motor PWM
	
		movia r4, Direction
		call _MotorOn
		
		movia r4, Duty_On_Cycles
		call _TIMER2Delay
		
		call _MotorOff
		
		movia r4, Duty_Off_Cycles
		call _TIMER2Delay
		
	#End motor PWM
	
	br _Main_Loop;
	
	#Just in case
_End: br _End
