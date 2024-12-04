;---------------------------------------------------------------
;Lab4.asm Berechnung der ISBN-13 Prüfziffer
;Author: DR
;
; Beispiele: 
; 978-3-8458-3851 : Prüfziffer = 9 
; 978-3-455-01430 : Prüfziffer = 3 
; 978-3-518-46920 : Prüfziffer = 0 
;
; ---------------------------------------------------------------

extern printf
extern isbn

section .data
  errorArgCountMsg: db `Falsche anzahl an Argumenten übergeben\n`, 0
  errorInvalidIsbnMsg: db `Bitte eine Valide ISBN eingeben\n`, 0
  checksumMsg: db `Prüfziffer: %d\n`, 0

section .text
  global main

main:
    ; Function prologue
    push ebp                 ; Save base pointer
    mov ebp, esp             ; Set up new base pointer

	; Check if one argument was passed (argc == 2)
    mov eax, [ebp + 8]
	cmp eax, 2
	jne errorArgCount

    ; Load the argument (argv[1])
    mov eax, [ebp+12]        
    add eax, 4              
    mov eax, [eax]   

	; Call the ISBN procedure to check the format
	push eax ; Pass the ISBN to the stack
	call isbn

    ; Check if eax is -1 -> invalid ISBN
    cmp eax, -1
	je errorInvalidIsbn
	add esp, 4 ; Clean up the stack

	; Output the checksum
	push eax
	push checksumMsg
	call printf
	add esp, 8 ; Clean up the stack

	jmp end


; error wrong arc count
errorArgCount:
	push errorArgCountMsg
	call printf

	add esp, 4 ; Clean up the stack

	jmp end


; error invalid ISBN
errorInvalidIsbn:
	push errorInvalidIsbnMsg
	call printf

	add esp, 4 ; Clean up the stack

	jmp end


end:

    mov eax, 0               ; Return 0
    mov esp, ebp
    pop ebp
    ret