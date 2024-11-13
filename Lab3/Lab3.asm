;---------------------------------------------------------------
;Lab3.asm calculate and print collatz sequence
;Author: DR
; ---------------------------------------------------------------

extern printf              
extern atoi                 ; Declare atoi for string-to-integer conversion

section .data
    decformat: db `%d\n`, 0 ; Decimal format with newline
    errormsg: db `Error: Bitte nur einen positiven integer eingeben.`, 0

section .text
    global main

main:
    ; Function prologue
    push ebp                 ; Save base pointer
    mov ebp, esp             ; Set up new base pointer

    push ebx

    ; Check if one argument was passed (argc == 2)
    mov eax, [ebp+8]         
    cmp eax, 2               
    jne error                

    ; Load the argument (argv[1])
    mov eax, [ebp+12]        
    add eax, 4              
    mov eax, [eax]           
    
    ; Convert to an integer
    push eax               
    call atoi                ; Call atoi to convert string to integer
    add esp, 4               ; Clean up stack
    mov ebx, eax

    ; Check if N is positive (N > 0)
    cmp ebx, 1               ; Check if N < 1
    jl error                 ; If N < 1, jump to error

collatz_loop:
    
    push ebx              
    push decformat          
    call printf              ; Call printf to print the number
    add esp, 8               ; Clean up the stack

    ; Check if N == 1
    cmp ebx, 1               
    je end            

    ; Calculate next term
    test ebx, 1              ; Test if N is odd
    jnz odd             

even:
    ; N = N / 2
    shr ebx, 1               ; Divide N by 2 (shift)
    jmp collatz_loop         

odd:
    ; N = 3 * N + 1
    mov eax, ebx             ; Move N into eax
    imul eax, eax, 3
    add eax, 1
    mov ebx, eax            
    jmp collatz_loop         ; Repeat the loop

error:
    push errormsg           
    call printf              ; Print the error message
    add esp, 4               ; Clean up stack
    jmp end                

end:
    ; Restore ebx
    pop ebx

    mov eax, 0               ; Return 0
    mov esp, ebp
    pop ebp
    ret

