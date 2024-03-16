; The FoxyOS disk / FAT12
; (MainFox) 2023 - 2024
; =======================

; [Disk] Чтение с диска
; Параметры:
;   - ax - LBA адрес
;   - cl - кол-во секторов для чтения (до 128)
;   - dl - тип диска (номер)
;   - es:bx - адрес памяти
disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx                  ; Сохраняем cl (кол-во секторов для чтения)
    call lba_to_chs          ; Вычисляем CHS адрес
    pop ax                   ; Восстанавливаем cl в al = кол-во секторов для чтения
    
    mov ah, 02h              ; [Setting] Значение для чтения
    mov di, 3                ; [Setting] Кол-во попыток

.retry:
    pusha                    ; Сохраняем все регистры (не знаем что BIOS изменит)
    stc                      ; Устанавливаем carry flag (некоторые BIOS не устанавливают их)
    int 13h                  ; Вызываем прерывание на операцию с диском
    jnc .done                ; Carry flag чист = прочтено и переходим в ".done"

    ; [Fail] Чтение не удалось
    popa                     ; Выгружаем все регистры
    call disk_reset          ; Очищаем диск

    dec di
    test di, di              ; Проверяем di (равен 0?)
    jnz .retry               ; Если нет, пробуем заново

.fail:
    jmp floppy_error         ; Все попытки исчерпаны

.done:   
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax

.output:
    test cl, cl              ; Проверяем cl
    jz .leave                ; Если 0, значит все сообщения вывели

    mov si, msg_read_success ; "Успешное чтение сектора по адресу: "
    call print

    push ax
    call print_register      ; "{lba address}"
    pop ax

    mov si, new_line         ; "Enter"
    call print

    inc ax                   ; Увеличиваем ax (lba address)
    dec cl                   ; Уменьшаем cl (кол-во секторов для чтения)

    jmp .output              ; Выводим заново

.leave:
    ret

; [Disk] Сбрасываем контроллер диска
; Параметры:
;   dl - тип диска (номер)
disk_reset:
    pusha

    mov ah, 0        ; [Setting] Значение для сброса диска
    stc              ; Устанавливаем carry flag (некоторые BIOS не устанавливают их)
    int 13h          ; Вызываем прерывание на операцию с диском
    jc floppy_error  ; Если carry flag не чист, значит диск сломался...

    popa

    ret

; [Disk] Ошибки
floppy_error:
    mov si, err_read_failed   ; "Чтение с диска не удалось"
    call print
    jmp wait_key_and_reboot

wait_key_and_reboot:
    mov ah, 0                 ; [Setting] Значение для чтения с клавиатуры
    int 16h                   ; Ждём нажатия на кнопку
    jmp 0FFFFh:0              ; Переходим в конец BIOS для перезагрузки

.halt:
    cli                       ; Отключаем прерывания, таким образом, процессор не сможет выйти из состояния "halt".
    hlt                       ; Остановка CPU