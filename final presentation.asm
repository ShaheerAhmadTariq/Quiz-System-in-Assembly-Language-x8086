;ARRAY_OF_ADDRESS Has all the address of Question's Strings
;ARRAY is consists of random numbers 
;the problem starts from 206 when i want to call each questionString randomly


.MODEL LARGE
.DATA  
    
    
       ;--------Questions----------------
    STR4 DB 0DH,0AH,'7-5 = ?',0AH,0DH,'a) 3    b) 8   c) 2    d) 10','$'   
    STR5 DB 0DH,0AH,'8+9 = ?',0AH,0DH,'a) 17    b) 18   c) 16    d) 19','$'   
    STR6 DB 0DH,0AH,'4/2 = ?',0AH,0DH,'a) 3    b) 6   c) 3    d) 2','$'   
    STR7 DB 0DH,0AH,'14/7 = ?',0AH,0DH,'a) 2    b) 3   c) 4    d) 5','$'   
    STR8 DB 0DH,0AH,'7*8 = ?',0AH,0DH,'a) 45    b) 48   c) 57    d) 56','$'   
    STR9 DB 0DH,0AH,'15+13 = ?',0AH,0DH,'a) 30    b) 28   c) 27    d) 32','$'   
    STR10 DB 0DH,0AH,'9-6 = ?',0AH,0DH,'a) 3    b) 8   c) 2    d) 8','$'
    ;STR1 DB 0DH,0AH,'3+5 = ?',0AH,0DH,'a) 3    b) 8   c) 3    d) 7','$';//1   
    ;STR2 DB 0DH,0AH,'5-2 = ?',0AH,0DH,'a) 5    b) 7   c) 3    d) 11','$';//3   
    ;STR3 DB 0DH,0AH,'10+2 = ?',0AH,0DH,'a) 13    b) 16   c) 26    d) 1','$';//2     

    ARRAY_OF_ANSWER DB  'c','a','d','a','d','b','a','d','a','c','$'



    ARRAY_OF_ADDRESS  DB 10 DUP(?)
    ;WORD DB ?
    CR  EQU  ODH
    LF  EQU  OAH
    ARRAY   DB   10 DUP('$')    
    CALCULATING DB   0DH,0AH,'******************************',0DH,0AH,'....Calculating Random Array.........','$'
    ;RAND_ARRAY  DB   0DH,0AH,'Random Array: ','$'
    VAR     DB   9
    WORD    DB   0
    ARR_LEN DW   0 
    PTR DB 10	

	
    Correct_MSG   DB  'Correct Answer$'
    Incorrect_MSG DB  'Incorrect Answer$'
    SCORE_MSG   DB  0DH,0AH,'**************************',0DH,0AH,'YOU SCORE: ','$'
    Total_score   DB   0 
    ;------------------VerifyRollNO---------------
    VERIFIY_MSG   DB  0DH,0AH,'Enter your Roll No :','$'
 
    num1 db 1h
    num2 db 1h 
    num3 db 1h
    req1 db 1h
    req2 db 0h
    req3 db 0h
    pk db '',0Dh,0Ah,'$'  
    a2  DB 'Roll Number Allowed',0Dh,0Ah,'$'  
    ;------------------VERIFY_PASSWORD
    STUDENT_ID DB 12 DUP(' ')  
    VERIFY_P    DB  'Enter your Password:','$' 
    NOT_FOUND   DB  0DH,0AH,'USER NOT FOUND','$'
    MSG1    DB  0DH,0AH,'FOUND!!$'  
    MSG2    DB  0DH,0AH,'NOT FOUND!!$' 
    STUDENT_LIST01    DB  'ASD$'
    STUDENT_LIST02    DB  'QWE$'
    STUDENT_LIST03    DB  'ZXC$'
    STRLEN DW ?
    TRUE    DB  0

    END_SCREEN  DB  0DH,0AH,'************************************',0DH,0AH,'THANKS FOR YOUR RESPONSE$'
.CODE
MAIN PROC
;initialize DSS
    MOV AX,DATA
    MOV DS,AX  
    
   
    
VERIFY_AGAIN:   
    CALL VALIDATE 
    CMP BX,1
    JNE NOT_A_STUDENT:  

               
    CALL VERIFY_STUDENT
    CMP TRUE,1
    JNE NOT_A_STUDENT
      
    CALL RANDOM_CALL  
    ;PRINT TOTAL SCORE
    MOV AH,9
    MOV DX,OFFSET SCORE_MSG 
    INT 21H      
    ;CALCULATE TOTAL SCORE AND PRINT IT
    MOV DL,Total_score
    MOV AH,2 
    ;CHECK IF HEX NUM IS 0AH          
    CMP DL,0AH
    JNE PRINT_TOTAL_NUM
    MOV DL,31H  ;PRINT 1
    INT 21H
    MOV DL,30H  ;PRINT 0
    INT 21H
    JMP END_PRINT_TOTAL
PRINT_TOTAL_NUM:
    ;CONVERT HEX NUM INTO ASCII
    ADD DL,30H
    INT 21H
END_PRINT_TOTAL:           
    MOV AH,9
    MOV DX,OFFSET END_SCREEN
    INT 21H        
    
    JMP END_MAIN_FUNCTION
NOT_A_STUDENT:
    MOV AH,9
    MOV DX,OFFSET NOT_FOUND
    INT 21H    
    JMP VERIFY_AGAIN 
    
    
                 
END_MAIN_FUNCTION:  
;DOS exit
    MOV AH,4CH
    INT 21H
            
MAIN ENDP 

;**************************************************************************
VALIDATE PROC     
    ;INPUT:- NOTHING
    ;PROCESSING number stored as num1, num2, num3
    ;OUTPUT BX: IF BX=0 WRONG ROLLno ELSE IF BX=1 CORRECT ROLLno
 
 
    MOV AH,9
    MOV DX,OFFSET VERIFIY_MSG
    INT 21H 
    mov ah,1      ;storing num1
    int 21h
    mov num1,al 
          
    mov ah,1 
    int 21h
    mov num2,al   ;storing num2

    mov ah,1 
    int 21h
    mov num3,al   ;storing num3 
    Call NL

    mov cx,4      ;num1 will be compared with req1=1
    sub num1,30h
    mov bl,req1
    cmp bl,num1
    JNE     wrong


    sub num2,30h
    mov req2,0h
L1:
    mov bl,req2   ;the num2 will be compared with req2=0, 1, 2, 3
    cmp bl,num2
    JE here
    INC req2
    loop L1
    jmp wrong
    here: 
    mov cx,10
    sub num3,30h  
    mov req3,0h
L2:
    mov bl,req3   ;the num3 will be compared with req3= 0, 2, 4, 6, 8
    cmp num3,bl 
    JE right
    INC req3
    inc req3
    loop L2
    jmp wrong



    CALL NL  
ret
            
            ;wrong input call
    wrong:
    MOV BX,0
ret 



    NL:         ;next line call
    lea dx,pk
    mov ah,9
    int 21h
ret;


right:      ;correct input call
    CAll NL
    MOV BX,1 
ret





stop:   

;**************************************************************************    
VERIFY_STUDENT PROC  
    ;INPUT: NOTHING
    ;OUTPUT: TRUE CONTAINS 1 IF STUDENT EXITS ELSE 0
    
    MOV AH,9
    MOV DX,OFFSET VERIFY_P
    INT 21H
    MOV TRUE,0                           
    XOR CX,CX                      
    MOV SI,OFFSET STUDENT_ID
    MOV AH,1
    INT 21H
    
REPEAT:
    CMP AL,0DH
    JE END1
    CMP AL,10H
    JNE NOBACKSPACE 
    DEC CX
    DEC SI
NOBACKSPACE:
    MOV [SI],AL
    INC SI
    INC CX  
    INT 21H
    JMP REPEAT  
         
END1:
    INC SI
    MOV [SI],'$'

    
;FOR CHECKING THE PASSWORD LENGTH
    CMP CX,3
    JNE END_VERIFY:        
    
;FOR STRING LENGTH 
    MOV SI,OFFSET STUDENT_LIST01
    XOR CX,CX
COUNT01:        
    
    CMP [SI],'$'
    JE COUNTED01
    INC CX 
    INC SI
    JMP COUNT01 
    
COUNTED01:
         
    MOV StrLen,CX   
    
    
;----------FIRST ID------------
;COMPARE STUDENT_LIST02
    MOV SI,OFFSET STUDENT_LIST01
    MOV DI,OFFSET STUDENT_ID
    ;DEC CX
   
    
    
TOP: 
    MOV AX,[SI]
    MOV DX,[DI]
    CMP DL,AL
    JNE NOt_Equal
    INC SI
    INC DI
    LOOP TOP

    MOV AH,9
    MOV DX,OFFSET MSG1
    INT 21H
    MOV TRUE,1
    JMP END_VERIFY:
    
NOt_Equal:  
    
   
;FOR STRING LENGTH 
    MOV SI,OFFSET STUDENT_LIST02
    XOR CX,CX
COUNT02:        
    
    CMP [SI],'$'
    JE COUNTED02
    INC CX 
    INC SI
    JMP COUNT02 
    
COUNTED02:
         
    MOV StrLen,CX         
  

;----------SECOND ID------------
;COMPARE STUDENT_LIST02
    MOV SI,OFFSET STUDENT_LIST02
    MOV DI,OFFSET STUDENT_ID  
    MOV CX,strlen
    DEC CX
   
    
    
TOP2: 
    MOV AX,[SI]
    MOV DX,[DI]
    CMP DL,AL
    JNE NOt_Equal02
    INC SI
    INC DI
    LOOP TOP2

    MOV AH,9
    MOV DX,OFFSET MSG1
    INT 21H
    MOV TRUE,1
    JMP END_VERIFY:
    
NOt_Equal02:  
    
   
 
;FOR STRING LENGTH 
    MOV SI,OFFSET STUDENT_LIST03
    XOR CX,CX
COUNT03:        
    
    CMP [SI],'$'
    JE COUNTED03
    INC CX 
    INC SI
    JMP COUNT03 
    
COUNTED03:
         
    MOV StrLen,CX         
  

;------------THIRD ID----------
;COMPARE STUDENT_LIST03
    MOV SI,OFFSET STUDENT_LIST03
    MOV DI,OFFSET STUDENT_ID  
    MOV CX,strlen
    DEC CX
   
    
    
TOP3: 
    MOV AX,[SI]
    MOV DX,[DI]
    CMP DL,AL
    JNE NOt_Equal03
    INC SI
    INC DI
    LOOP TOP3

    MOV AH,9
    MOV DX,OFFSET MSG1
    INT 21H 
    MOV TRUE,1
    JMP END_VERIFY:
    
NOt_Equal03:  
    MOV AH,9
    MOV DX,OFFSET MSG2
    INT 21H
   
        

END_VERIFY:  
        
           
           
    
RET 
VERIFY_STUDENT ENDP     
;**************************************************************************
RANDOM_CALL PROC
    ;INPUT: NOTHING
    ;OUTPUT: DX: ADDRESS OF QUESTION
    ;
    MOV AH,9
    MOV DX,OFFSET CALCULATING
    INT 21H
   


;<<------- Storing Addresses of all Question into an Array ------->>    
    MOV SI,OFFSET STR4
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS,BL 
    
    MOV SI,OFFSET STR5 
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+1,BL
    
    MOV SI,OFFSET STR6 
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+2,BL 
    
    MOV SI,OFFSET STR7
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+3,BL 
    
    MOV SI,OFFSET STR8 
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+4,BL
    
    MOV SI,OFFSET STR9 
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+5,BL
    
    MOV SI,OFFSET STR10
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+6,BL 
    
    MOV SI,OFFSET STR6 
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+7,BL
    
    MOV SI,OFFSET STR5 
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+8,BL
    
    MOV SI,OFFSET STR4
    MOV BX,SI
    MOV ARRAY_OF_ADDRESS+9,BL 
    
    
    
    
    
REPEAT_RAND:   
   
;GENERATE RANDOM NUM 
    MOV AH,00H  ;interrupts to get system time 
    INT 1AH      ;CX:DX now hold number of clock ticks since midnight
    
    MOV AX,DX
    XOR DX,DX
    MOV CX,10
    DIV CX       ; here dx contains the remainder of the division - from 0 to 9
    
    ADD DL,'0'   ;to ascii from '0' to '9'
    ;MOV AH,2H
    ;INT 21H
    
    MOV WORD,DL 
    
;CHECK IF NUM EXITS IN ARRAY
    MOV SI,OFFSET ARRAY
    MOV AH,WORD
    MOV CX,ARR_LEN  
    
;IF CX IS 0 THEN SKIP TO AVOID INFINITE LOOP
    JCXZ SKIP
TOP_RAND:
    ;JCXZ SKIP    
    CMP [SI],AH
    JE EXISTS
    INC SI
    LOOP TOP_RAND
SKIP:
    
;NOT EXISTS          
    MOV DL,WORD
    MOV DI,OFFSET ARRAY
    ADD DI,ARR_LEN
    MOV [DI],DL
  
    INC ARR_LEN
EXISTS:

    
;CHECK IF ARRAY SIZE IS LESS THAN OR Equal to 10
    CMP ARR_LEN,0AH
    JL REPEAT_RAND:   
     
     
    
    MOV AH,2
    MOV SI,OFFSET ARRAY
    MOV CX,10 
    JCXZ SKIP2
PRINT:
    MOV DL,[SI]
    INC SI            
    INT 21H
    LOOP PRINT
SKIP2:       

   
    XOR BX,BX
    ;MOV AH,9 
    
    MOV SI,OFFSET ARRAY
PRINT1:    
    MOV BX,OFFSET ARRAY_OF_ADDRESS
    MOV CL,[SI]
    INC SI
    
    AND CL,0FH
    ADD BX,CX
    MOV DI,[BX]
   
    AND DI,00FFH 
    ;MIGRATE DX TO PRINT_QUESTION PROC
    ;CL: VALUE OF INDEX OF QUESTION 
    
    CALL Print_Question 
    MOV BP,OFFSET ARRAY_OF_ANSWER
    ADD BP,CX
    MOV BH,[BP]
    CALL Check_Answer
    ;INT 21H  
    DEC PTR
    CMP PTR,0
    JNE PRINT1
  
RET 
RANDOM_CALL ENDP        
                    
;***********************************************************

Print_Question PROC   
    ;input DI-> Address of question
    ;output Nothing
    
    XOR DX,DX
    MOV AH,9
    MOV DX,DI
    INT 21H
    
RET 
Print_Question ENDP    



;***********************************************************

Check_Answer PROC   
    ;Input BH-> Value of Answer
    ;Processing AL-> Answer entered by user  
    ;Output : nothing


;PRINT NEW LINE        
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H 
;GET USER INPUT     
    MOV AH,1
    INT 21H 
    
 
    
;CHECK IF ANSWER IS CORRECT    
    CMP AL,BH
    JE CORRECT   
    JMP INCORRECT
CORRECT:
;PRINT NEW LINE    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    MOV AH,9
    MOV DX,OFFSET Correct_MSG
    INT 21H    
    INC Total_score
    JMP END_CHECK
INCORRECT:  
;PRINT NEW LINE    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    MOV AH,9
    MOV DX,OFFSET Incorrect_MSG
    INT 21H  

END_CHECK:    
RET 
Check_Answer ENDP        