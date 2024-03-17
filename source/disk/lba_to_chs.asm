; The FoxyOS disk / FAT12
; (MainFox) 2023 - 2024
; =======================

; [Disk] Перевод LBA адреса в CHS адрес (% - остаток от деления)
; Параметры:
;   - ax - LBA
; Вывод:
;   - cx [bits 0-5] - сектор
;   - cx [bits 6-15] - циллиндр
;   - dh - голова
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [bdb_sectors_per_track] ; Делим, получая в ax = LBA / SectorsPerTrack и в dx = LBA % SectorsPerTrack

    inc dx                           ; Получаем сектор (dx = LBA % SectorsPerTrack + 1)
    mov cx, dx                       ; Перемещаем в нужный регистр (cx)

    xor dx, dx
    div word [bdb_heads]             ; Делим, получяя циллиндр (ax = (LBA / SectorsPerTrack) / Heads) и голову (dx = (LBA / SectorsPerTrack) % Heads)

    mov dh, dl                       ; Перемещаем в нужный регистр (dh = голова)
    mov ch, al                       ; Перемещаем в нужный регистр (ch = циллиндр (последние 8 bits)

    shl ah, 6                        ; Двигаем ah регистр на 6 байтов влево (оставляя 2 верхних)
    or cl, ah                        ; Махинации над номером циллиндра (Помещаем верхние 2 байта - цилиндр в CL)

    pop ax                           ; Восстанавливаем значение dx в ax
    mov dl, al                       ; Восстанавливаем dl
    pop ax

    ret