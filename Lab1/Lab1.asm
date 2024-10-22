;---------------------------------------------------------------
; Lab1.asm - Mupltiplizieren und ausgeben einer Zahl in Hexformat
; Skalarprodukt mit Schleife berechnen (version with newline fix)
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
    mov eax, [a]            ; load a into eax
    imul eax, [b]           ; multiply eax by b (a * b)
    push eax                ; push result onto the stack
    push hexformat          ; set hex format string
    call printf             ; print 42 in hex
    add esp, 8              ; clean up the stack (2 arguments)

    ; --Calculate Scalar Product in Loop--
    xor eax, eax            ; clear eax (for later use)
    mov ecx, 0              ; initialize loop counter

loop_start:
    ; Check if loop is done (3 vector components)
    cmp ecx, 3              ; compare loop counter with 3 --sets zero flag
    je loop_end             ; if ecx == 3, exit the loop

    ; Load x[ecx] and y[ecx], multiply them
    mov edx, [x + ecx * 4]  ; load x[ecx] into edx (ecx * 4 for 4 byte integers offset)
    imul edx, [y + ecx * 4] ; multiply edx with y[ecx]
    add eax, edx            ; add result to eax (summe)

    ; Increment loop counter
    inc ecx
    jmp loop_start

loop_end:
    ; --Print Scalar Product--
    push eax                ; push scalar product onto the stack
    push decformat          ; set decimal format string
    call printf             ; print scalar product
    add esp, 8              ; clean up the stack (2 arguments)

    ; --Exit--
    mov eax, 0              ; return 0
    mov esp, ebp
    pop ebp
    ret                     ; return from main

