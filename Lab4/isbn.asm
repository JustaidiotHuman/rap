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

    ; Check for end of the string (null terminator)
    cmp al, 0                   
    je isbnLoopExit         

    ; Check if char is a dash ('-')
    cmp al, '-'
    je incrementDashCounter             

    ; Convert ASCII digit to integer
    sub al, 48                  

    ; Check if the character is not a valid digit (less than 0 or greater than 9)
    cmp al, 0
    jl error                  
    cmp al, 9
    jg error                   


    ; Multiply  by the weight and add it to the weighted sum
    movzx eax, al               
    imul eax, ecx               ; EAX = AL * ECX
    add dword [ebp-4], eax      ; Add the result to the weighted sum

    ; Alternate the weight between 1 and 3
    cmp ecx, 1                 
    je setWeightToThree
    mov ecx, 1                  ; Otherwise, switch to 1
    jmp continueLoop

setWeightToThree:
    mov ecx, 3

continueLoop:
    ; Move to the next character in the string
    add ebx, 1

    inc dword [ebp-8]           ; digitCount++

    jmp isbnLoop

; Exit the loop when the string ends
isbnLoopExit:
    ; Check dash count
    cmp dword [ebp-12], 3
    jne error

    ; Check digit count
    cmp dword [ebp-8], 12
    jne error                   

    ; Calculate final checksum
    mov eax, [ebp-4]
    mov edx, 0                  ; Clear EDX for division
    mov ecx, 10

    div ecx                     ; EAX = EAX / 10, remainder in EDX

    ; If the remainder (EDX) is 0, the checksum is 0
    cmp edx, 0
    je checksumZero

    ; Otherwise, calculate the checksum
    mov eax, 10
    sub eax, edx                ; EAX = 10 - remainder

    jmp isbnExit

checksumZero:
    mov eax, 0


; Exit for the procedure
isbnExit:

    mov esp, ebp                ; Restore stack pointer
    pop ebp                     ; Restore base pointer
    ret                         

; Increment dash Count
incrementDashCounter:
    inc dword [ebp-12]          
    add ebx, 1                  ; Move to the next character in the string
    jmp isbnLoop                ; Return to the loop


error:
    mov eax, -1                 ; Return error code -1
    jmp isbnExit
