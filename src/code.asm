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
        MOV  dl, 00h                 
                         
        ; Set up the 8255 to read from ports A and B, and write to port C.
        MOV  al, 10010000b
        OUT  CWREG, al
        
; Continuously read from port C to see if someone has stepped on the pressure
; plates.
start:  IN   al, PORTA
        ; START DEBUG
        SHR  al, 4
        OUT  PORTB, al 
        CMP  al, 00010000b
        ; END DEBUG
        JNE  start
        CALL increment
        MOV  al, dl
        OUT  PORTC, al
        JMP  start 

PROC increment
        INC  dl
        CMP  dl,09h
        JLE  inc1
        MOV  dl, 00h
inc1:   ret
ENDP increment

END