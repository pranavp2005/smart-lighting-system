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
        OUT PORTB, al
        CMP al, 00000001b
        JNE main
        CALL delay_db   
        CALL delay
        CALL incr_cnt
        JMP main 

; A small timed delay
delay PROC NEAR
        MOV CX, 0FFFFh
p1:     NOP
        DEC CX
        JNE p1
        ret
delay ENDP

; A debounce delay mechanism implemented on Port A's buttons.
delay_db PROC NEAR
p2:     IN al, PORTA
        CMP al, 0h
        JNE p2
        ret
delay_db ENDP

incr_cnt PROC NEAR
        INC dl;
        MOV al, dl
        OUT PORTC, al
incr_cnt ENDP

END 