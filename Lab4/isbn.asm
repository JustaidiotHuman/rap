;---------------------------------------------------------------
;isbn.asm Berechnung der ISBN-13 Prüfziffer
;Author: DR
;
; Beispiele: 
; 978-3-8458-3851 : Prüfziffer = 9 
; 978-3-455-01430 : Prüfziffer = 3 
; 978-3-518-46920 : Prüfziffer = 0 
;
; ---------------------------------------------------------------

section .text
    global isbn

isbn:
    ; Prologue: Set up stack frame
    push ebp                    ; Save base pointer
    mov ebp, esp                ; Set new base pointer
    sub esp, 12                 ; Allocate space for local variables

    ; Initialize local variables
    mov dword [ebp-4], 0        ; weightedSum = 0
    mov dword [ebp-8], 0        ; digitCount = 0
    mov dword [ebp-12], 0       ; dashCount = 0

    ; Load the address of the ISBN string into EBX
    mov ebx, [ebp+8]           

    ; Initialize the weight alternating variable
    mov ecx, 1                  ; Start with weight = 1

    ; Clear EAX (used for calculations)
    xor eax, eax

    ; Loop through the ISBN string
isbnLoop:
    ; Load the current character
    mov al, [ebx]

    ; Check for the end of the string (null terminator)
    cmp al, 0                   ; Is character null?
    je isbnLoopExit         

    ; Check if the character is a dash ('-')
    cmp al, '-'
    je handle_dash             

    ; Convert ASCII digit ('0'-'9') to integer
    sub al, 48                  ; Subtract ASCII value of '0'

    ; Check if the character is not a valid digit (less than 0 or greater than 9)
    cmp al, 0
    jl error                    ; If less than 0, jump to error
    cmp al, 9
    jg error                    ; If greater than 9, jump to error


    ; Multiply  by the weight and add it to the weighted sum
    movzx eax, al               ; Zero-extend AL into EAX
    imul eax, ecx               ; EAX = AL * ECX
    add dword [ebp-4], eax      ; Add the result to the weighted sum

    ; Alternate the weight between 1 and 3
    cmp ecx, 1                  ; If weight is 1, switch to 3
    je setWeightToThree
    mov ecx, 1                  ; Otherwise, switch to 1
    jmp continueLoop
setWeightToThree:
    mov ecx, 3

continueLoop:
    ; Move to the next character in the string
    add ebx, 1

    ; Increment the digit counter
    inc dword [ebp-8]           ; digitCount++

    ; Repeat the loop
    jmp isbnLoop

; Exit the loop when the string ends
isbnLoopExit:
    ; Check if the number of dashes is correct (must be 3)
    cmp dword [ebp-12], 3
    jne error                   ; If not 3, jump to error

    ; Check if the number of digits is correct (must be 12)
    cmp dword [ebp-8], 12
    jne error                   ; If not 12, jump to error

    ; Calculate the final checksum
    ; Load the weighted sum into EAX
    mov eax, [ebp-4]
    mov edx, 0                  ; Clear EDX for division
    mov ecx, 10                 ; Divisor is 10

    div ecx                     ; EAX = EAX / 10, remainder in EDX

    ; If the remainder (EDX) is 0, the checksum is 0
    cmp edx, 0
    je checksum_already_zero

    ; Otherwise, calculate the checksum
    mov eax, 10
    sub eax, edx                ; EAX = 10 - remainder

    ; Exit the procedure
    jmp calc_isbn_checksum_exit

checksum_already_zero:
    mov eax, 0                  ; If remainder is 0, checksum is 0

; Exit point for the procedure
calc_isbn_checksum_exit:
    ; Epilogue: Restore stack and return
    mov esp, ebp                ; Restore stack pointer
    pop ebp                     ; Restore base pointer
    ret                         ; Return to caller

; Handle a dash character ('-')
handle_dash:
    inc dword [ebp-12]          ; Increment the dash count
    add ebx, 1                  ; Move to the next character in the string
    jmp isbnLoop                ; Return to the loop

; Consolidated error handling
error:
    mov eax, -1                 ; Return error code -1
    jmp calc_isbn_checksum_exit
