;
;   Labor 1 - Test program for LCD driver
;
;   Computerarchitektur
;   (C) 2019-2020 J. Friedrich, W. Zimmermann
;   Hochschule Esslingen
;
;   Template by:   	   J.Friedrich
;   Last Modified: Alexander Rebmann 26.04.22
;
;   ---- Tasks edited by: Alex Rebmann
;  delay.asm          Help from Tibor Lederer           
;  led.asm                          
;  toLower.asm        Help from Tibor Lederer       
;  hexToASCII.asm     Help from Cafer Cicek      
;  decToASCII.asm     Help from Cafer Cicek     
;  lcd.asm            Help from Cafer Cicek              
;  main.asm           Help from Svenja Luik               

; Export symbols
        XDEF Entry, main

; Import symbols
        XREF __SEG_END_SSTACK                                        ;End of stack
        XREF initLCD, writeLine, delay_10ms                          ;LCD functions
        XREF delay_0_5sec, hexToASCII, decToASCII                    ;convert functions and delay
        XREF initLED, setLED, getLED, toggleLED                      ;LED functions

; Include derivative specific macros
        INCLUDE 'mc9s12dp256.inc'

; Defines

; RAM: Variable data section
.data:  SECTION
hex2Ascii:  DS.B     7                                               ;where hexToAscii is stored
dec2Ascii:  DS.B     7                                               ;where decToAscii is stored 

; ROM: Constant data
.const: SECTION
MSG1:   dc.b  " Mach mal eine",0
MSG2:   dc.b  " kleine Pause", 0
MSGA:   dc.b  "ABCDEFGHIJKLMnopqrstuvwxyz1234567890", 0
MSGB:   dc.b  "is this OK?", 0
MSGC:   dc.b  "Keep texts short!", 0
MSGD:   dc.b  "Oh yeah!", 0

; ROM: Code section
.init:  SECTION

main:
Entry:
        LDS  #__SEG_END_SSTACK                                       ; Initialize stack pointer
        CLI                                                          ; Enable interrupts, needed for debugger

        JSR  delay_10ms                                              ;Delay 20ms during power up
        JSR  delay_10ms

        JSR initLCD                                                  ;Initialize components once
        JSR initLED                                                   
        
        LDY #$0                                                      ;initialize counter
        
            
    loop:                                       
        TFR Y, D                                                     ;numerical Value to D
        PSHD
        LDX  #hex2Ascii                                              ;pointer to string
        JSR hexToASCII                                               ;jump to conversion hex -> ASCII 
        LDAB #0                                                      ;load byte to B 
        JSR  writeLine                                               ;write in line 0
        
        PULD                                                         ;restore Value 
        PSHD                                                         ;save on stack 
        LDX #dec2Ascii                                               ;load ptr to decimal ascii string 
        JSR decToASCII                                               ;and covert to string 
        LDAB #1                                                      ;write string to lcd line 1
        JSR writeLine 
        
        ; ---  LED ---
        PULD                                                         ;restore numerical value 
        JSR setLED                                                   ;set lower 8 Bits of numerical val 
        JSR delay_0_5sec                                             ;delay .5 seconds should result in 2 increments per second
        
        ;--------> address for buttons 'PTH.x' has to be maped 
        ;------- > BRCLR for HW because buttons are lowactive <---------
        ;BRCLR PTH, #$01, button0pressed                              ;check if button on port PTH.0 is pressed
        ;BRCLR PTH, #$02, button1pressed                              ;check if button on port PTH.1 is pressed
        ;BRCLR PTH, #$04, button2pressed                              ;check if button on port PTH.2 is pressed
        ;BRCLR PTH, #$08, button3pressed                              ;check if button on port PTH.3 is pressed
        ;------- > BRSET for SIM because buttons are NOT lowactive <---------
        BRSET PTH, #$01, button0pressed                              ;check if button on port PTH.0 is pressed
        BRSET PTH, #$02, button1pressed                              ;check if button on port PTH.1 is pressed
        BRSET PTH, #$04, button2pressed                              ;check if button on port PTH.2 is pressed
        BRSET PTH, #$08, button3pressed                              ;check if button on port PTH.3 is pressed
        
        ; continue here if not pressed
        INY                                                          ; increment by one if nothing pressed 
        BRA loop                                                     ; restart cycle 

button0pressed:                                                      ; if button 0 pressed
        EXG D, Y                                                     ; swap registers for easier adding in next step
        ADDD #16                                                     ; increment by 16 
        EXG Y, D                                                     ; swap back 
        BRA loop 
        
button1pressed:                                                      ; if button 1 pressed
        EXG D, Y                                                     ; swap registers for easier adding in next step 
        ADDD #10                                                     ; increment by 10 
        EXG Y, D                                                     ; swap back 
        BRA loop         

button2pressed:                                                      ;if button 2 pressed
        EXG D, Y                                                     ;swap registers for easier subtracting in next step 
        SUBD #16                                                     ;decrement by 16
        EXG Y, D                                                     ;swap back 
        BRA loop

button3pressed:                                                      ;if button 3 pressed 
        EXG D, Y                                                     ;swap registers for easier subracting in next step 
        SUBD #10                                                     ;decrement by 10 
        EXG Y, D                                                     ;swap back 
        BRA loop    

        STOP                                                         ;stop execution of CPU commands