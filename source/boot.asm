; The FoxyOS bootloader
; (MainFox) 2023 - 2024
; =====================

; [NASM] Настройка компиляции
[org 0x7C00]              ; Установка смещения 0x7C00
bits 16                   ; Генерация 16 битного кода

; [Symbols]
%define ENTER 0x0D, 0x0A

; [FAT12] Настройка / 48 байт
jmp short setup
nop

bdb_oem:                   db 'MSWIN4.1'           ; Идентификатор OEM (Часто бессмысленно / 8 байт)
bdb_bytes_per_sector:      dw 512                  ; Кол-во байт на сектор (floppy: 512)
bdb_sectors_per_cluster:   db 1                    ; Кол-во секторов на кластер (floppy: 1)
bdb_reserved_sectors:      dw 1                    ; Кол-во зарезервированных секторов (+сектор загрузчика)
bdb_fat_count:             db 2                    ; Кол-во fat таблиц (обычно: 2)
bdb_dir_entries_count:     dw 0E0h                 ; Кол-во записей корневого каталога
bdb_total_sectors:         dw 2880                 ; Кол-во секторов (2880 * 512 = 1.44 мб)
bdb_media_descriptor_type: db 0F0h                 ; Тип диска (F0 = 3.5" floppy disk)
bdb_sectors_per_fat:       dw 9                    ; Кол-во секторов на fat таблицу
bdb_sectors_per_track:     dw 18                   ; Кол-во секторов на дорожку
bdb_heads:                 dw 2                    ; Кол-во голов
bdb_hidden_sectors:        dd 0                    ; Кол-во скрытых секторов
bdb_large_sector_count:    dd 0                    ; Кол-во секторов, следующих дальше 65535 сектора

; Дополнительные параметры файловой системы (extended boot record)
ebr_drive_number:          db 0                    ; Номер диска (0x00 floppy / 0x80 hdd )
                           db 0                    ; Резерв
ebr_signature:             db 29h                  ; Подпись (0x28 или 0x29)
ebr_volume_id:             db 91h, 98h, 21h, 66h   ; Серийный номер (не имеет значения на систему)
ebr_volume_label:          db '   FOXYOS  '        ; Название тома (11 байт, дополнять пробелами)
ebr_system_id:             db 'FAT12   '           ; Версия FAT (FAT12, FAT16..., 8 байт)

; [Code] Основной код FoxyOS / 448 байт
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
    mov dl, [ebr_drive_number] ; Устройство для чтения - floppy диск

    mov ax, 1                  ; LBA = 1 / Второй сектор
    mov cl, 1                  ; Кол-во секторов
    mov bx, 0x7E00             ; Записываем данные по этому адресу (после загрузчика)
    call disk_read

    mov si, msg_welcome        ; "Приветствие"
    call print

    cli
    hlt

; [Disk] Чтение диска и др.
%include "source/disk/lba_to_chs.asm"
%include "source/disk/read.asm"

; [Messages]
msg_welcome:        db 'Welcome.', ENTER, 0

err_read_failed:    db '[Critical] Read failed...', 0
msg_read_success:   db '[Success] Read LBA ', 0

new_line: db 0x0D, 0x0A

times 510-($-$$) db 0     ; Заполняем 0 до 510 байта
dw 0AA55h                 ; Ставим подпись AA55 (для BIOS)
