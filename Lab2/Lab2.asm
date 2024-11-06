;---------------------------------------------------------------
; Fibonacci.asm - Calculate and print the first N Fibonacci numbers
; Author: DR
; ---------------------------------------------------------------

extern printf    ; Declare printf for output

section .data
    decformat: db `%d\n`, 0    ; Decimal format with newline

section .text
    global main

main:
    ; Function prologue
    push ebp                 ; Save base pointer
    mov ebp, esp             ; Set up new base pointer

   
        ; Print the first 1
    mov eax, 1               ; F(1)
    push eax                 ; Push the Fibonacci number (F(1))
    push decformat           ; Push the format string
    call printf              ; Print F(1)
    add esp, 8               ; Clean up the stack

    mov ecx, 20 -1              ; Calculate first 20 Fibonacci numbers

    ; Initialize Fibonacci numbers
    mov eax, 1               ; F(1)
    mov edx, 1               ; F(2)

fib_loop:
    ; Save eax, edx, and ecx (loop counter)
    push eax                 ; Save eax (F(n-1))
    push edx                 ; Save edx (F(n))
    push ecx                 ; Save ecx (loop counter)

    ; Push arguments for printf
    push eax                 ; Push the Fibonacci number (F(n-1))
    push decformat           ; Push the format string

    call printf              ; Call printf to print the number

    add esp, 8               ; Clean up the stack (2 pushes of 4 bytes each)

    ; Restore ecx, edx, and eax
    pop ecx                  ; Restore ecx (loop counter)
    pop edx                  ; Restore edx (F(n))
    pop eax                  ; Restore eax (F(n-1))

    ; Calculate next Fibonacci number
    ; eax = F(n-1), edx = F(n)
    mov ebx, eax             ; Save F(n-1) in ebx
    add eax, edx             ; eax = F(n-1) + F(n), update F(n+1)
    mov edx, ebx             ; edx = F(n-1), shift the numbers

    ; Use the loop instruction to decrement ecx and jump back to fib_loop if ecx != 0
    loop fib_loop

loop_end:
    ; Function epilogue
    mov eax, 0               ; Return 0
    mov esp, ebp
    pop ebp
    ret

