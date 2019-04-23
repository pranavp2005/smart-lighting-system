.MODEL TINY

.DATA
    PORTA equ 0000h
    PORTB equ 0002h
    PORTC equ 0004h
    CWREG equ 0006h
    
.CODE
.STARTUP

        ORG 0000h
        
        ; This register will serve as memory and store the number of people in the room.
        mov dl, 00h
        
        ; Set up the PPI to read from Port A and write to Port B and Port C.
        mov al, 10010000b
        OUT CWREG, al
        
main:   IN al, PORTA
        CALL delay
        OUT PORTB, al
        CMP al, 00000001b
        JNE main
        INC dl
        MOV al, dl
        OUT PORTC, al
        JMP main 

delay PROC
        MOV CX, 000Fh
p1:     NOP
        DEC CX
        CMP CX, 0000h
        JNE p1
        ret
delay ENDP

END 