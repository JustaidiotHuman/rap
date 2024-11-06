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
    mov eax, [ebp+8]         ; Load argc
    cmp eax, 2               ; Check if argc == 2
    jne error                

    ; Load the argument (argv[1])
    mov eax, [ebp+12]        ; Get address of argv array
    add eax, 4               ; Move to argv[1]
    mov eax, [eax]           ; Load address of argv[1] into eax
    
    ; Convert to an integer
    push eax                 ; Push address of argv[1] onto stack
    call atoi                ; Call atoi to convert string to integer
    add esp, 4               ; Clean up stack after function call
    mov ebx, eax

    ; Check if N is positive (N > 0)
    cmp ebx, 1               ; Check if N < 1
    jl error                 ; If N < 1, jump to error

collatz_loop:
    
    push ebx                 ; Push the current number
    push decformat           ; Push format string
    call printf              ; Call printf to print the number
    add esp, 8               ; Clean up the stack

    ; Check if N == 1
    cmp ebx, 1               ; Compare N with 1
    je end            ; If N == 1, end

    ; Calculate next term
    test ebx, 1              ; Test if N is odd
    jnz odd_case             ; If N is odd, jump to odd_case

even_case:
    ; N is even: N = N / 2
    shr ebx, 1               ; Divide N by 2 (shift)
    jmp collatz_loop         ; Repeat the loop

odd_case:
    ; N is odd: N = 3 * N + 1
    mov eax, ebx             ; Move N into eax
    lea eax, [eax*2 + eax]   ; Calculate 3 * N
    add eax, 1               ; Add 1
    mov ebx, eax             ; Store the result back in N (ebx)
    jmp collatz_loop         ; Repeat the loop

error:
    push errormsg            ; Push error message
    call printf              ; Print the error message
    add esp, 4               ; Clean up stack
    jmp end                  ; Jump to end

end:
    ; Restore ebx
    pop ebx

    ; Function epilogue
    mov eax, 0               ; Return 0
    mov esp, ebp
    pop ebp
    ret

