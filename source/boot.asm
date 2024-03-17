; The FoxyOS bootloader
; (MainFox) 2023 - 2024
; =====================

; [NASM] Настройка компиляции
[org 0x7C00]           ; Установка смещения 0x7C00
bits 16                ; Генерация 16 битного кода

; [Code] Основной код FoxyOS
main:
    hlt                ; Остановка CPU

.halt:
    jmp .halt          ; Создаём бесконечный цикл (остановка)

times 510-($-$$) db 0  ; Заполняем 0 до 510 байта
dw 0AA55h              ; Ставим подпись AA55 (для BIOS)
