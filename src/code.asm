.MODEL TINY


.DATA
    PORTA1 equ 0000h
    PORTB1 equ 0002h
    PORTC1 equ 0004h
    CWREG1 equ 0006h

    
.CODE
.STARTUP
       
    init:   
      ORG  0000h
      
      ; This register will serve as internal memory and store the number of people in the room.
      MOV  dl, 00h
            
      ; Set up the PPI to read from Port A and write to Port B and Port C.
      MOV  al, 10010000b
      OUT  CWREG1, al
 
    ; "main" serves as our event loop and the functions check_entry and check_exit will handle the rest.        
    main:   
      CALL check_entry
      CALL check_exit
      JMP  main 
  
    
    delay PROC NEAR
    ; A small timed delay. The caller should set CX before calling.
      delay1:  
        NOP
        DEC  cx
        JNE  delay1
        RET
    delay ENDP
    
    
    delay_db PROC NEAR
    ; A debounce delay mechanism implemented on Port A's pressure sensors (push buttons).
      delay_db1:
        IN   al, PORTA1
        CMP  al, 0h
        JNE  delay_db1
        RET
    delay_db ENDP
    
    
    incr_cnt PROC NEAR
    ; Increase the count value and update the display.
        INC  dl;
        MOV  al, dl
        OUT  PORTC1, al
        RET
    incr_cnt ENDP
               
               
    decr_cnt PROC NEAR
    ; Decrease the count value and update the display.
        DEC  dl;
        MOV  al, dl
        OUT  PORTC1, al
        RET
    decr_cnt ENDP
  
    
    open_door PROC NEAR
    ; Open the door by turning the stepper motor to 180deg. 
        MOV  al, 00000001b
        OUT  PORTB1, al
        RET
    open_door ENDP
    
    
    close_door PROC NEAR
    ; Close the door by turning the stepper motor to 0deg.
        MOV  al, 00000010b
        OUT  PORTB1, al
        RET
    close_door ENDP 
                 
                 
    check_entry PROC NEAR
        ; Check to see if the external pressure sensor has been triggered.
        IN   al, PORTA1
        CMP  al, 00000001b
        JNE  check_entry4
                
        ; Open the door once the external pressure sensor has been triggered.
        CALL open_door
        MOV  cx, 0FFFFh
        CALL delay
            
        ; Check to see if the internal pressure sensor has been triggered. Provide a small window of time for entry.
        MOV  cx, 0FFFFh
      check_entry1:
        IN   al, PORTA1
        CMP  al, 00000010b
        JE   check_entry2 
        DEC  cx
        JNZ  check_entry1
        JMP  check_entry3
            
      check_entry2:
        ; If the person entered then the count should be incremented.
        CALL incr_cnt
        
      check_entry3:
        ; Close the door.     
        CALL close_door
      check_entry4:
        RET     
    check_entry ENDP
                    
         
    check_exit PROC NEAR
         ; Check to see if the external pressure sensor has been triggered.
        IN   al, PORTA1
        CMP  al, 00000010b
        JNE  check_exit4
                
        ; Open the door once the external pressure sensor has been triggered.
        CALL open_door
        MOV  cx, 0FFFFh
        CALL delay
            
        ; Check to see if the internal pressure sensor has been triggered. Provide a small window of time for entry.
        MOV  cx, 0FFFFh
      check_exit1:
        IN   al, PORTA1
        CMP  al, 00000001b
        JE   check_exit2 
        DEC  cx
        JNZ  check_exit1
        JMP  check_exit3
            
      check_exit2:
        ; If the person exited then the count should be decremented.
        CALL decr_cnt
        
      check_exit3:
        ; Close the door.     
        CALL close_door
      check_exit4:
        RET     
    check_exit ENDP

END


; POSSIBLE OPTIMIZTIONS:
; 1. Use a flag/moniter/semaphore to prevent entry/exit race conditions.