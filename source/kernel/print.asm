; The FoxyOS print
; (MainFox) 2023 - 2024
; ================

; [Print] Вывод строки
; Параметры:
;   - ds:si - строка для вывода
print:
	push si
	push ax
	push bx

	mov bh, 0           ; [Setting] Номер страницы, текстового режима

.loop:
	lodsb               ; Загружаем символ из si в al
	or al, al           ; Проверяем, является ли символ нулевым?
	jz .done            ; Если да, переходим к .done, если нет - идём дальше

	mov ah, 0x0E        ; Включаем TTY mode (вывод символа с прокруткой курсора сразу)
	int 0x10            ; Вызываем прерывание вывода на экран

	jmp .loop           ; Так как символ не нулевой, то возращаемся к .loop и выводим следующий

.done:
	pop bx
	pop ax
	pop si

	ret
