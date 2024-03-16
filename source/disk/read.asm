; The FoxyOS disk / FAT12
; (MainFox) 2023 - 2024
; =======================

; [Disk] ������ � �����
; ���������:
;   - ax - LBA �����
;   - cl - ���-�� �������� ��� ������ (�� 128)
;   - dl - ��� ����� (�����)
;   - es:bx - ����� ������
disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx                  ; ��������� cl (���-�� �������� ��� ������)
    call lba_to_chs          ; ��������� CHS �����
    pop ax                   ; ��������������� cl � al = ���-�� �������� ��� ������
    
    mov ah, 02h              ; [Setting] �������� ��� ������
    mov di, 3                ; [Setting] ���-�� �������

.retry:
    pusha                    ; ��������� ��� �������� (�� ����� ��� BIOS �������)
    stc                      ; ������������� carry flag (��������� BIOS �� ������������� ��)
    int 13h                  ; �������� ���������� �� �������� � ������
    jnc .done                ; Carry flag ���� = �������� � ��������� � ".done"

    ; [Fail] ������ �� �������
    popa                     ; ��������� ��� ��������
    call disk_reset          ; ������� ����

    dec di
    test di, di              ; ��������� di (����� 0?)
    jnz .retry               ; ���� ���, ������� ������

.fail:
    jmp floppy_error         ; ��� ������� ���������

.done:   
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax

.output:
    test cl, cl              ; ��������� cl
    jz .leave                ; ���� 0, ������ ��� ��������� ������

    mov si, msg_read_success ; "�������� ������ ������� �� ������: "
    call print

    push ax
    call print_register      ; "{lba address}"
    pop ax

    mov si, new_line         ; "Enter"
    call print

    inc ax                   ; ����������� ax (lba address)
    dec cl                   ; ��������� cl (���-�� �������� ��� ������)

    jmp .output              ; ������� ������

.leave:
    ret

; [Disk] ���������� ���������� �����
; ���������:
;   dl - ��� ����� (�����)
disk_reset:
    pusha

    mov ah, 0        ; [Setting] �������� ��� ������ �����
    stc              ; ������������� carry flag (��������� BIOS �� ������������� ��)
    int 13h          ; �������� ���������� �� �������� � ������
    jc floppy_error  ; ���� carry flag �� ����, ������ ���� ��������...

    popa

    ret

; [Disk] ������
floppy_error:
    mov si, err_read_failed   ; "������ � ����� �� �������"
    call print
    jmp wait_key_and_reboot

wait_key_and_reboot:
    mov ah, 0                 ; [Setting] �������� ��� ������ � ����������
    int 16h                   ; ��� ������� �� ������
    jmp 0FFFFh:0              ; ��������� � ����� BIOS ��� ������������

.halt:
    cli                       ; ��������� ����������, ����� �������, ��������� �� ������ ����� �� ��������� "halt".
    hlt                       ; ��������� CPU