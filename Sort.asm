 .ORG $E000
 LDA #$FF
 STA $8003

restrt: 
	JSR delay
	LDA #$0
	STA $401
	LDA #$FF
	STA $402
	LDA #$C4
 	STA $400 
 	EOR $402
 	STA $402 
 	LDX #$5 
	
flicker:
	LDA $400
	STA $8001
	JSR delay
	LDA $402
	STA $8001
	JSR delay
	DEX
	BNE flicker

main:
	LDA $8001
	CMP #$FF
	BEQ restrt
	INC $401
	LDA $400
	ORA $401
	STA $400
	LDA $401
	ORA $402
	STA $402
	ROL $401
	LDX #$5
	JMP flicker

delay:
	PHX
	LDX #$C3
loopB:
	LDY #$FF
loopA:
	DEY
	BNE loopA
	DEX
	BNE loopB
	PLX
	RTS 
	
	.END