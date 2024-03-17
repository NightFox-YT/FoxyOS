; The FoxyOS disk / FAT12
; (MainFox) 2023 - 2024
; =======================

; [Disk] ������� LBA ������ � CHS ����� (% - ������� �� �������)
; ���������:
;   - ax - LBA
; �����:
;   - cx [bits 0-5] - ������
;   - cx [bits 6-15] - ��������
;   - dh - ������
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [bdb_sectors_per_track] ; �����, ������� � ax = LBA / SectorsPerTrack � � dx = LBA % SectorsPerTrack

    inc dx                           ; �������� ������ (dx = LBA % SectorsPerTrack + 1)
    mov cx, dx                       ; ���������� � ������ ������� (cx)

    xor dx, dx
    div word [bdb_heads]             ; �����, ������� �������� (ax = (LBA / SectorsPerTrack) / Heads) � ������ (dx = (LBA / SectorsPerTrack) % Heads)

    mov dh, dl                       ; ���������� � ������ ������� (dh = ������)
    mov ch, al                       ; ���������� � ������ ������� (ch = �������� (��������� 8 bits)

    shl ah, 6                        ; ������� ah ������� �� 6 ������ ����� (�������� 2 �������)
    or cl, ah                        ; ��������� ��� ������� ��������� (�������� ������� 2 ����� - ������� � CL)

    pop ax                           ; ��������������� �������� dx � ax
    mov dl, al                       ; ��������������� dl
    pop ax

    ret