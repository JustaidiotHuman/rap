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

section .data
  weightedSum: dd 0          ; Accumulates the weighted sum of ISBN digits
  digitCount: dd 0           ; Counts the number of digits in the ISBN
  dashCount: dd 0            ; Counts the number of dashes in the ISBN

section .text
	global isbn

isbn:
	; Prologue: Set up stack frame
	push ebp                  ; Save base pointer
	mov ebp, esp              ; Set new base pointer

	; Load the address of the ISBN string into EBX
	mov ebx, [esp + 8]        ; EBX points to the input string (ISBN)

	; Initialize the weight alternating variable
	mov ecx, 3                ; Weight starts at 3

	; Clear EAX (used for calculations)
	xor eax, eax

	; Loop through the ISBN string
isbnLoop:
	; Load the current character into AL
	mov al, [ebx]

	; Check for the end of the string (null terminator)
	cmp al, 0                 ; Is the character null?
	je isbnLoop_exit          ; If yes, exit the loop

	; Check if the character is a dash ('-')
	cmp al, '-'
	je handle_dash            ; If it's a dash, handle it

	; Convert ASCII digit ('0'-'9') to integer by removing ASCII bias
	sub al, 48                ; Subtract ASCII value of '0'

	; Check if the character is not a valid digit (less than 0 or greater than 9)
	cmp al, 0
	jl error                  ; If less than 0, jump to error
	cmp al, 9
	jg error                  ; If greater than 9, jump to error

	; At this point, AL contains a valid digit

	; Alternate the weight between 1 and 3
	xor ecx, 2                ; Toggle ECX between 1 and 3

	; Multiply the digit by the weight and add it to the weighted sum
	mul ecx                   ; EAX = AL * ECX
	add dword [weightedSum], eax ; Add the result to the weighted sum

	; Move to the next character in the string
	add ebx, 1

	; Increment the digit counter
	add dword [digitCount], 1 ; Increment the digit count by 1

	; Repeat the loop
	jmp isbnLoop

; Exit the loop when the string ends
isbnLoop_exit:
	; Check if the number of dashes is correct (must be 3)
	cmp dword [dashCount], 3
	jne error                 ; If not 3, jump to error

	; Check if the number of digits is correct (must be 12)
	cmp dword [digitCount], 12
	jne error                 ; If not 12, jump to error

	; Calculate the final checksum
	; Load the weighted sum into AX for division
	mov ax, [weightedSum]
	mov dl, 10                ; Divisor is 10

	div dl                    ; AX = AX / DL (AX contains quotient, remainder in AH)

	; If the remainder (AH) is 0, the checksum is 0
	cmp ah, 0
	je checksum_already_zero

	; Otherwise, calculate the checksum
	mov ebx, 10
	movzx edx, ah             ; Load the remainder (AH) into EDX

	sub ebx, edx              ; EBX = 10 - remainder
	mov eax, ebx              ; EAX contains the final checksum

	; Exit the procedure
	jmp calc_isbn_checksum_exit

checksum_already_zero:
	mov eax, 0                ; If remainder is 0, checksum is 0

; Exit point for the procedure
calc_isbn_checksum_exit:
	; Epilogue: Restore stack and return
	leave                     ; Clean up the stack frame
	ret                       ; Return to caller

; Handle a dash character ('-')
handle_dash:
	add dword [dashCount], 1  ; Increment the dash count
	add ebx, 1                ; Move to the next character in the string
	jmp isbnLoop              ; Return to the loop

; Consolidated error handling
error:
	mov eax, -1               ; Return error code -1
	jmp calc_isbn_checksum_exit
