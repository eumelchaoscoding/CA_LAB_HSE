                  XDEF hexToASCII
;ROM: Constant data

.const:           SECTION
H2A:    DC.B      "0123456789ABCDEF",0

;ROM: Code section
.init:            SECTION

hexToASCII:                     ;16Bit input is passed in register D as a nullterminated string 

        PSHX
        PSHY
        PSHD
                
        MOVB #'0',0,X            ;set zero for prefix 0x           
        MOVB #'x',1,X            ;set 'x' for prefix 0x to index 1
        
        ANDA #$F0                ;AND A (zero the lower 4 bits of regA)
        LSRA                     ;Logical Shift right (regA) 4x
        LSRA                     ;MSB -> LSB
        LSRA                     ;bit 7 to pos of bit 3
        LSRA
        SEX     A, Y             ;save bit to array (sign extend warning when using TFR)
        LDAA  H2A, Y             ;load char in Y
        STAA    2, X
        
        PULD                     ;
        PSHD
                                     
        ANDA #$0F                ;isolate LSB
        SEX     A, Y             ;save LSB
        LDAA  H2A, Y             ;load char in Y
        STAA    3, X 
        
        ANDB #$F0                ;MSB b to LSB
        LSRB
        LSRB
        LSRB
        LSRB
        SEX     B, Y
        LDAB  H2A, Y             ;load char in Y
        STAB    4, X
        
        PULD
        PSHD
        
        ANDB  #$0F
        SEX     B, Y
        LDAB  H2A, Y             ;load char in Y
        STAB    5, X
        
        MOVB #$0,6,X            ;end string with hex zero 
       
        PULD
        PULY
        PULX
        RTS