section .text
global isbn

isbn:
    ; Function prologue
    push ebp
    mov ebp, esp

    ; Load address of ISBN string into EBX
    mov ebx, [esp + 8]

    ; Initialize counters and accumulators
    xor ecx, ecx            ; ECX = 0 (digits)
    xor edx, edx            ; EDX = 0 (dashes)
    xor eax, eax            ; EAX = 0 (sum)
    mov esi, 1              ; Weight (1 to 3)

iterate_isbn:
    mov al, [ebx]           ; Load current character
    cmp al, 0               ; Check for string termination
    je validate_counts       ; If null terminator, validate counts

    cmp al, '-'             ; Check if character is a dash
    je handle_dash

    ; Check if character is a digit
    sub al, '0'             ; Convert ASCII to integer
    cmp al, 9
    ja error_nan            ; If not a valid digit, error

    ; Add weighted value to the sum
    imul eax, esi           ; Multiply digit by weight (EAX *= ESI)
    add edx, eax            ; Add weighted value to total sum
    inc ecx                 ; Increment digit count

    ; Toggle weight between 1 and 3
    xor esi, 2              ; Toggle weight: 1 <-> 3

    jmp next_char

handle_dash:
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
