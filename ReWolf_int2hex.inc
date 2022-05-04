;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; push dword
; push size of bufor
; push offset bufor
; call _int2hex
;
; procedura konwertuje DWORD na nalncuch HEX
;
; na wejsciu:
; dword         - wartosc, ktora ma zostac przekonwertowana
; size of bufor - rozmiar bufora (czyli jezeli chcemy miec wartosc 32-bitowa
;                 to podajemy rozmiar 9, 16-bitowa to rozmiar 5 itd.)
; bufor         - bufor, w ktorym zostanie zwrocony przekonwertowany string.
;                 string jest zakanczany zerem.
;
; na wyjsciu:
; brak
;
; modyfikowane rejestry:
; brak
;
; Autor : ReWolf^HTB (rewolf@poczta.onet.pl)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

_int2hex proc
	push	ecx
	push	eax
	push	edi
	add	esp,10h
	pop	edi
	pop	ecx
        dec	ecx
_i2h_1:	pop	eax
	rol	eax,4
	push	eax
	and	al,0Fh
	cmp	al,0Ah
	jb	_i2h_2
	add	al,37h
	jmp	_i2h_3
_i2h_2:	add	al,30h
_i2h_3:	mov	byte ptr [edi],al
	inc	edi
	inc	ch
	cmp	ch,cl
	jne	_i2h_1
	mov	byte ptr [edi],0
	sub	esp,18h
	pop	edi
	pop	eax
	pop	ecx
	ret	0Ch
_int2hex endp
