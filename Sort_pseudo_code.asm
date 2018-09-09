 .InstructionOrigin	$E000	;where EEPROM is memory mapped
 LoadReg1	#$FF
 Store		DataDirectionRegisterA

Restart:
 Jumpto		DelayLoop
 LoadReg0	#0
 Store		MaskingLEDs		;this will be used to sort LEDs
 LoadReg0	#$FF
 Store		InvertUnsorted	;creates flickering (processing) effect for LEDs not "sorted"
 LoadReg0	RNG				;randomly generated unorgranized LEDs scheme
 Store		LEDScheme
 XORReg0	InvertUnsorted
 Store		InvertUnsorted	;Logic inverted of unorgranized LEDs
 LoadReg1	#5				;The amount of Display cycle to LEDs are being "processed"

Display:
 LoadReg0	LEDScheme
 Store		LEDsOutput
 Jumpto		DelayLoop
 LoadReg0	InvertUnsorted
 Store		LEDsOutput		;Create "processing" effect by showing complemented "unsorted" LEDs, "sorted" LEDs are stably lit
 Jumpto		DelayLoop
 DecreaseReg1
 GoToIfNot0 Display

SortAlgorithm:
 LoadReg0	InvertUnsorted
 Compare	#$FF			;value when all LEDs stable Lit
 IfEqualJmp	Restart
 Add		MaskingLEDs		;Because "ShiftLeft" shifts 0 in, add fix by turning 0 to 1 for proper masking
 LoadReg0	LEDScheme		;This operation masks each LED
 ORReg0		MaskingLEDs		;from lowest bit to higest (right
 Store		LEDScheme		;to left) to logic 1 each time this
 LoadReg0	MaskingLEDs		;loop runs. Since both InvertUnsorted
 ORReg0		InvertUnsorted	;and LEDScheme is masked that makes the
 Store		InvertUnsorted	;LED(s) masked stably lit (i.e. sorted)
 ShiftLeft	MaskingLEDs		;Next time loop runs, the lowest unmasked bit will be mask
 LoadReg1	#5
 Jumpto		Display

DelayLoop:
 StoreReg1toStack
 LoadReg1	#$C3
LoopB:
 LoadReg2	#$FF
LoopA:
 DecreaseReg2
 GoToIfNot0 loopA		;Count down from loopA to 0
 DecreaseReg1
 GoToIfNot0 loopB		;Count down from looB to 0 but have to countdown from loopA because nested under
 GetfromStacktoReg1
 Return

 .END