; =================================
; The FoxyOS print
; Copyright(C) 2023 - 2024 MainFox
; =================================

; [Print] Вывод строки на экран 
; Параметры: 
;   - ds:si - строка для вывода
;
print:
	push si
	push ax
	push bx

.loop:
	lodsb               ; Загружает символ в al
	or al, al           ; Проверяет, является ли символ нулевым?
	jz .done            ; Если выше верно, то переходим к .done, если нет - идём дальше

	mov ah, 0x0E        ; Включаем функцию TTY mode, вывод символа с прокруткой курсора сразу.
	mov bh, 0           ; Номер страницы, текстового режима
	int 0x10            ; Вызываем прерывание вывода на экран

	jmp .loop           ; Так как символ не нулевой, то возращаемся к .loop и смотрим следующий символ

.done:
	pop bx
	pop ax
	pop si

	ret                 ; Выход из функции