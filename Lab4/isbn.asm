section .text
global isbn

isbn:
    ; Prologue
    push ebp
    mov ebp, esp

    ; Load address of ISBN string into EBX
    mov ebx, [esp + 8]

    ; Initialize counters and accumulators
    xor ecx, ecx            ; ECX = 0 (digit count)
    xor edx, edx            ; EDX = 0 (dash count)
    xor eax, eax            ; EAX = 0 (accumulated weighted sum)
    mov esi, 1              ; Weight (alternates between 1 and 3)

iterate_isbn:
    mov al, [ebx]           ; Load current character
    cmp al, 0               ; Check for string termination
    je validate_counts      ; If null terminator, validate counts

    cmp al, '-'             ; Check if character is a dash
    je count_dash           ; Jump if it's a dash

    ; Check if character is a digit
    cmp al, '0'
    jl error_nan            ; If less than '0', it's invalid
    cmp al, '9'
    jg error_nan            ; If greater than '9', it's invalid

    ; Valid digit
    sub al, '0'             ; Convert ASCII to integer
    imul eax, esi           ; Multiply digit by weight (EAX *= ESI)
    add edx, eax            ; Add weighted value to total sum
    inc ecx                 ; Increment digit count

    ; Toggle weight between 1 and 3
    xor esi, 2              ; Toggle weight: 1 <-> 3
    jmp next_char

count_dash:
    inc edx                 ; Increment dash count
    jmp next_char

next_char:
    inc ebx                 ; Move to next character
    jmp iterate_isbn

validate_counts:
    ; Check for correct number of digits and dashes
    cmp ecx, 12             ; Check if digit count is 12
    jne error_nan
    cmp edx, 3              ; Check if dash count is 3
    jne error_nan

    ; Calculate check digit
    xor eax, eax            ; Clear EAX
    mov eax, edx            ; Load accumulated weighted sum
    mov ecx, 10             ; Modulo base (10)
    xor edx, edx            ; Clear EDX for division
    div ecx                 ; EDX = Weighted Sum % 10, EAX = Sum / 10

    mov eax, edx            ; Load remainder (EDX) into EAX
    sub ecx, eax            ; EAX = 10 - Remainder
    and ecx, 0xF            ; Ensure EAX is within 0-9
    mov eax, ecx            ; Final check digit

    jmp exit_isbn

error_nan:
    mov eax, -1             ; Return error code (-1)

exit_isbn:
    ; Epilogue
    leave
    ret
