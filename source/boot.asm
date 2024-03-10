; =================================
; The FoxyOS bootloader
; Copyright(C) 2023 - 2024 MainFox
; =================================

; [NASM] Настройка компиляции

[org 0x7C00]              ; Все символы просчитываются со смещением в 0x7C00
bits 16                   ; Генерация 16 битного кода

; [Symbols] Таблица

%define ENTER 0x0D, 0x0A

; [Code] Запуск основного кода FoxyOS

setup:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    jmp main

; [Function] Print
%include "/root/FoxyOS/source/kernel/print.asm"

main:
    mov si, msg_welcome
    call print

    hlt                   ; Остановка CPU       

.halt: 
    jmp .halt             ; Создаём бесконечный цикл (остановка)

; [Messages] Раздел

msg_welcome: db "Welcome...", ENTER, 0

times 510-($-$$) db 0     ; Заполняем байты 0 до 510 байта
dw 0AA55h                 ; Ставим подпись 55AA
