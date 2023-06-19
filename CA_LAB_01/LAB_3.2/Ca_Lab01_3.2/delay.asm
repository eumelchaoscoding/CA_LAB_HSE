;export symbols
        XDEF delay_0_5sec
        
        INCLUDE 'mc9s12dp256.inc'
        
.data: SECTION ; RAM: Variable data section
.const:SECTION ; ROM: Constant data
.init: SECTION ; ROM: Code section

;-> Delay code with help from Tibor Lederer
;-> two loops, inner and outer loop, multiplied with clock

delay_0_5sec:
        PSHX                ;save registers x and y
        PSHY
        
        LDX #500            ;delay time in ms 
waitO:  LDY #8000           ;8k cycles
waitI:  DBNE Y, waitI       ;Inner loop -> 8k reps * 3 cycles (dbne) = 24k cycles
        DBNE X, waitO       ;24k cycles / 24Mhz clock should result in 1ms delay
        
        PULY                ;reload registers
        PULX
        RTS