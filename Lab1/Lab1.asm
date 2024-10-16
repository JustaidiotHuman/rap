;
;---------------------------------------------------------------
; Lab1.asm
; 
;
; Author: NSFR
;
; ---------------------------------------------------------------

; declaration of functions that are not defined in the module being assembled, i.e. this file

extern printf; Using the  c function for output - the object file needs to be linked with a C library

section .data ; defines which section of the output file the code will be assembled into
              ; here: initialised data
              ; segment can be used instead (exactly equivalent synonym)

  decformat: db `%d \n`,0 ; we define the decimal format for use with C's printf function
  hexformat: db `%x\n`,0    ; and the hex format
  a: dd 21
  b: dd 2



section .text    ;code segment starts here

global main

main:

    push ebp
    mov ebp, esp
    mov eax, [a]
    mov ebx, [b]
    imul eax,ebx
    push eax
    push hexformat
    call printf
    add esp, 8
    mov eax,0      ; returning 0 by convention
    mov esp, ebp   ; clean up after ourselves 
    pop ebp        ; leave could be used alternatively for the last two commands
   ret
