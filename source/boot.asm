; The FoxyOS bootloader
; (MainFox) 2023 - 2024
; =====================

; [NASM] Настройка компиляции
[org 0x7C00]              ; Установка смещения 0x7C00
bits 16                   ; Генерация 16 битного кода

; [Symbols]
%define ENTER 0x0D, 0x0A

; [Code] Основной код FoxyOS
setup:
    ; [RAM] Настройка сегментов / Очистка (Стек растёт вниз)
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    jmp main

; [Function] Print
%include "source/kernel/print.asm"

main:
    mov si, msg_welcome   ; "Приветствие"
    call print

    hlt    

.halt: 
    jmp .halt             ; Создаём бесконечный цикл (остановка)

; [Messages]
msg_welcome: db "Welcome...", ENTER, 0

times 510-($-$$) db 0     ; Заполняем 0 до 510 байта
dw 0AA55h                 ; Ставим подпись AA55 (для BIOS)
