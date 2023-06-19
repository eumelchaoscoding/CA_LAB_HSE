;export symbols
        XDEF initLED, setLED, getLED,toggleLED
        
        INCLUDE 'mc9s12dp256.inc'
        
.data: SECTION ; RAM: Variable data section
.const:SECTION ; ROM: Constant data
.init: SECTION ; ROM: Code section

;->led code:
;-> init leds:
initLED:  
          BSET DDRJ, #2     ;port J as output
          BCLR PTJ, #2      ;bit clear: J.1 = 0 -> Activate LEDs
          MOVB #$FF, DDRB   ;Port b as output '63'
          CLR PORTB         ;clr leds
          RTS
          
;-> set led: sets PORTB to value of regB
setLED:
          STAB PORTB        ;'store B' to PORTB
          RTS               ; return from subroutine
          
;-> get led: returns value of PORTB
getLED:
          LDAB PORTB        ;PORTB -> regB
          RTS
          
;-> toggleLED: invert Register for leds
toggleLED:
          LDAB PORTB        ;LEDs -> regB
          PULB
          EORB PORTB        ;XOR PORTB
          STAB PORTB        ;store regB to PORTB
          RTS