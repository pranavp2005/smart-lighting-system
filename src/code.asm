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
        MOV al, 10001011b
        OUT CWREG, al
    
        MOV al, 00000001b
        OUT PORTA, al
        
door:   IN  al,PORTB 
        CMP al, 00000001b
        JNE door
        CMP dl, 00000011b
        JLE p1
        JMP door

p1:     INC dl
        MOV al, dl
        OUT PORTA, al
        JMP door

END