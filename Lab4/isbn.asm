section .text
global isbn

isbn:
    ; Prologue
    push ebp
    mov ebp, esp

    ; Initialize variables
    mov esi, [ebp + 8]     ; ESI points to the input string
    xor edx, edx           ; EDX = 0 (weighted sum)
    xor ecx, ecx           ; ECX = 0 (digit count)
    xor ebx, ebx           ; EBX = 0 (dash count)
    mov edi, 1             ; Weight starts at 1

isbnLoop:
    mov al, [esi]          ; Load current character
    cmp al, 0              ; Check for null terminator
    je validate_counts      ; If end of string, validate counts

    cmp al, '-'            ; Check if character is a dash
    je handle_dash

    ; Convert ASCII to integer
    sub al, '0'
    cmp al, 0
    jl error               ; If invalid digit (< 0)
    cmp al, 9
    jg error               ; If invalid digit (> 9)

    ; Calculate weighted sum
    cmp edi, 1
    je weight_one
    lea eax, [al*3]        ; AL * 3
    jmp add_to_sum

weight_one:
    movzx eax, al          ; AL * 1

add_to_sum:
    add edx, eax           ; Add to weighted sum
    inc ecx                ; Increment digit count

    ; Toggle weight
    xor edi, 2             ; Toggle between 1 and 3
    jmp next_char

handle_dash:
    inc ebx                ; Increment dash count
    jmp next_char

next_char:
    inc esi                ; Move to next character
    jmp isbnLoop

validate_counts:
    cmp ecx, 12            ; Check if digit count is 12
    jne error
    cmp ebx, 3             ; Check if dash count is 3
    jne error

    ; Calculate checksum
    mov eax, edx           ; Load weighted sum
    xor edx, edx           ; Clear EDX
    mov ecx, 10            ; Set divisor
    div ecx                ; Perform 32-bit division, remainder in EDX

    cmp edx, 0             ; If remainder is 0, checksum is 0
    je checksum_zero

    mov eax, 10
    sub eax, edx           ; EAX = 10 - remainder
    and eax, 0xF           ; Ensure single digit
    jmp exit_isbn

checksum_zero:
    xor eax, eax           ; Checksum is 0

exit_isbn:
    leave
    ret

error:
    mov eax, -1            ; Return -1 for error
    leave
    ret
