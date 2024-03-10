; =================================
; The FoxyOS bootloader
; Copyright(C) 2023 - 2024 MainFox
; =================================

; [NASM] ��������� ����������

[org 0x7C00]              ; ��� ������� �������������� �� ��������� � 0x7C00
bits 16                   ; ��������� 16 ������� ����


; [Code] ������ ��������� ���� FoxyOS

main:
	hlt                   ; ��������� CPU       

.halt: 
	jmp .halt             ; ������ ����������� ���� (���������)

times 510-($-$$) db 0     ; ��������� ����� 0 �� 510 �����
dw 0x55AA                 ; ������ ������� 55AA