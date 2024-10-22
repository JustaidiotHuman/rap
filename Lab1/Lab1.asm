;---------------------------------------------------------------
; Lab1.asm - Mupltiplizieren und ausgeben einer Zahl in Hexformat
; Skalarprodukt mit Schleife berechnen (Refined version with newline fix)
; Author: DR
; ---------------------------------------------------------------

extern printf ; Declare printf for output

section .data
    decformat: db `%d\n`, 0    ; Decimal format with newline
    hexformat: db `%x\n`, 0    ; Hexadecimal format with newline
    a: dd 21                   ; Values for a and b
    b: dd 2
    x: dd 17, 11, 4            ; Vector x components
    y: dd 4, -9, 8             ; Vector y components

section .text
    global main

main:

    push ebp
    mov ebp, esp

    ; --Mulitplication and output of a*b--
    mov eax, [a]            ; Load a into eax
    imul eax, [b]           ; Multiply eax by b (a * b)
    push eax                ; Push result onto the stack
    push hexformat          ; Push hex format string onto the stack
    call printf             ; Call printf to print hex result
    add esp, 8              ; Clean up the stack (2 arguments)


    ; --Calculate Scalar Product in Loop--
    xor eax, eax            ; Clear eax (accumulator for scalar product)
    mov ecx, 0              ; Initialize loop counter

loop_start:
    ; Check if loop is done (3 vector components)
    cmp ecx, 3              ; Compare loop counter with 3
    je loop_end             ; If ecx == 3, exit the loop

    ; Load x[ecx] and y[ecx], multiply them
    mov edx, [x + ecx * 4]  ; Load x[ecx] into edx
    imul edx, [y + ecx * 4] ; Multiply edx with y[ecx]
    add eax, edx            ; Add result to eax (accumulator)

    ; Increment loop counter
    inc ecx                 ; Increment counter
    jmp loop_start          ; Repeat the loop

loop_end:
    ; ----------- Print Scalar Product -----------
    push eax                ; Push scalar product onto the stack
    push decformat          ; Push decimal format string onto the stack
    call printf             ; Call printf to print the scalar product
    add esp, 8              ; Clean up the stack (2 arguments)

    ; ----------- Exit Program -----------
    mov eax, 0              ; Return 0
    mov esp, ebp
    pop ebp
    ret                     ; Return from main

