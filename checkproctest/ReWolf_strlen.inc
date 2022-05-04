;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;push	offset string
;call	_strlen
;
; procedura oblica dlugosc lancucha ASCIIZ
;
; na wejsciu:
; offset string - offset do lancucha ASCIIZ
;
; na wyjsciu:
; eax - dlugosc lancucha
;
; modyfikowane rejestry:
; eax
;
; Autor : ReWolf^HTB (rewolf@poczta.onet.pl)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴asmpak�

_strlen proc
	push	edi
	push	ecx
	mov	edi,dword ptr [esp+0Ch]
	xor	eax,eax
	xor	ecx,ecx
	dec	ecx
	repne	scasb
	not	ecx
	dec	ecx
	mov	eax,ecx
	pop	ecx
	pop	edi
	ret	4
_strlen endp
