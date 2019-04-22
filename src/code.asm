.MODEL TINY

.DATA
    PORTA equ 0000h
    PORTB equ 0002h
    PORTC equ 0004h
    CWREG equ 0006h
    
.CODE
.STARTUP
        ORG 0000h
        
        ; In register storage of the number of people that entered the room,
        MOV dl, 00h                 
                         
        ; Set up the 8255 to read from port B (and C) and write to port A.
        MOV al, 10001001b
        OUT CWREG, al
    
        ; Initialize the 7 segment display to 0.
        MOV al, 00000000b
        OUT PORTA, al
        
door:   IN  al, PORTC
        OUT PORTB, al
        JMP door

END