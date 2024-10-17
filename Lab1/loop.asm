;---------------------------------------------------------------
; Print numbers from 1 to 10 using a loop in Assembly
; ---------------------------------------------------------------

extern printf           ; Declaration of the C printf function

section .data           ; Data section
    format db "%d\n", 0  ; Format string for printf (decimal output)

section .text           ; Code section

global main

main:
    ; Function prologue
    push ebp
    mov ebp, esp

    ; Initialize loop counter
    mov ecx, 10          ; Set loop counter to 10
    mov edx, 1           ; Start counting from 1

loop_start:
    ; Save registers that will be used by printf
    push ecx
    push edx

    ; Print the current value of edx
    push edx             ; Push the current number onto the stack
    push format          ; Push the format string onto the stack
    call printf          ; Call printf to print the number
    add esp, 8           ; Clean up the stack (2 pushes = 8 bytes)

    ; Restore registers
    pop edx
    pop ecx

    inc edx              ; Increment the counter (edx)

    dec ecx              ; Decrement ecx (loop counter)
    cmp ecx, 0           ; Compare ecx with 0
    jne loop_start       ; Jump back to loop_start if ecx != 0

    ; Exit the program
    mov eax, 0           ; Return 0 (optional, as EAX is typically the return value)
    leave                ; Correctly restore the stack frame
    ret                  ; Return from main

