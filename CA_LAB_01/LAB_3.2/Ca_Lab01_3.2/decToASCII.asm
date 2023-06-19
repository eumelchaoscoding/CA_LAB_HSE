          XDEF decToASCII
          
;Defines
;RAM: Variable data section
.data:    SECTION

;ROM: constant data
.const:   SECTION

;ROM: Code section
.init:    SECTION
decToASCII:


          PSHX              ;save register contents
          PSHY
          PSHD
          
          CPD #0            ; number is positive ?
          BGE positive      ; branch if greater 0 
          
negative: 
          MOVB #'-', X      ; sign char '-'
          COMA              ; invert regA
          COMB              ; invert regB
          ADDD #1           ; +1 -> 2's complement
          
          BRA convers
          
positive:
          MOVB #' ', X      ;sign char ' '
          
convers:                    ;--> Zahl wird je Stelle durch potenz von 10 geteilt 
                            ; z.B. 5876 -> 5*10^3 + 8*10^2 + 7*10^1 + 6*10^0
          TFR X, Y          ;save string pointer to Y
          
          LDX #10000        ;div 10^4
          IDIV              ; regD / regX -> remainder in D
          EXG D,X           ; swap D/X -> save remainder to X
          ADDD #'0'         ;decimal to ASCII
          STAB 1, Y         ; store lsb in Y 
          
          TFR X,D           ;remainder back to regD
          LDX #1000         ;div 10^3
          IDIV              ;regD / regX  
          EXG D,X           ;remainder in X
          ADDD #'0'
          STAB 2,Y          ;store lsb in Y
          
          TFR X,D           ;remainder back to regD
          LDX #100          ;div 10^3
          IDIV              ;regD / regX  
          EXG D,X           ;remainder in X
          ADDD #'0'
          STAB 3,Y          ;store lsb in Y
          TFR X,D           ;remainder back to regD
          LDX #10           ;div 10^3
          IDIV              ;regD / regX  
          EXG D,X           ;remainder in X
          ADDD #'0'
          STAB 4,Y          ;store lsb in Y
          
          TFR X,D           ;remainder back to regD
          ADDD #'0'         ;
          STAB 5, Y         ;store lsb in Y
          
          MOVB #0,6,Y       ;set terminating zero
          
          PULD              ;restore original contents
          PULY
          PULX
          RTS