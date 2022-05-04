.586
.model flat, stdcall
option casemap:none


include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32
includelib \masm32\lib\user32

include fake_md5.inc
include rewolf_md4.inc

.data
	cld1 db 0,6Ah,0Ah
	nm db 'ReWolf^HTB',0
	;bf db 64 DUP (0)

	firstSBox dd 030fb40d4h, 9fa0ff0bh, 06beccd2fh, 3f258c7ah, 1e213f2fh, 9c004dd3h, 06003e540h, 0cf9fc949h
                  dd 0bfd4af27h, 88bbbdb5h, 0e2034090h, 98d09675h, 6e63a0e0h, 15c361d2h, 0c2e7661dh, 022d4ff8eh
        secondSBox dd 08defc240h, 025fa5d9fh, 0eb903dbfh, 0e810c907h, 47607fffh, 0369fe44bh, 08c1fc644h, 0aececa90h
                   dd 0beb1f9bfh, 0eefbcaeah, 0e8cf1950h, 051df07aeh, 920e8806h, 0f0ad0548h, 0e13c8d83h, 0927010d5h


;004030CF  DD 4D 2F 03 BA 08 21 B5 D7 3A 61 3D C1 2A 0C 15
;004030DF  5A 4D 81 F3 09 84 6B 6D 79 4F DF 74 9D BF 63 B7


        ;ReWolf      - 3BF90808AFAD315AC1757F565D7A9E6B3C2D75ACA1AE389BB9A8D1F7B71E4F9F
        ;ReWolf^HTB  - DD4D2F03BA0821B5D73A613DC12A0C155A4D81F309846B6D794FDF749DBF63B7
	;crackmes.de - 9B4EEFA869D33D3A37143CA6BE48DD381C684396B8FBDC22E2E815D1E19CBE89

	serialBuf db 'DD4D2F03BA0821B5D73A613DC12A0C155A4D81F309846B6D794FDF749DBF63B7',0 ;ReWolf^HTB
	serialBin db 32 DUP (0)

	hashedName db 16 DUP (0)
	hashedSerial db 16 DUP (0)


.code
include rewolf_strlen.inc

;push	offset outBuf
;push	lpString
hexstr2intbuf proc
	push	eax
	push	edi
	push	esi
	push	ecx

	mov	edi, dword ptr [esp+8+4*4]
	mov	esi, dword ptr [esp+4+4*4]

_hi_0:
	xor	ecx, ecx
	xor	ah, ah
_hi_1:
	lodsb
	test	al, al
	je	_hi_end

	shl	ah, 4
	cmp	al, 60h
	jb	_hi_2
	sub	al, 57h
	jmp	_hi_4
_hi_2:	cmp	al, 40h
	jb	_hi_3
	sub	al, 37h
	jmp	_hi_4
_hi_3:	sub	al, 30h
_hi_4:	or	ah, al
	inc	ecx
	cmp	ecx, 2
	jnz	_hi_1

	xchg	ah, al
	stosb
	jmp	_hi_0

_hi_end:

	pop	ecx
	pop	esi
	pop	edi
	pop	eax
	ret	8
hexstr2intbuf endp

;push	what
;push	offset hashedName
;push	offset serialBin
_check proc
	pushad
        mov	esi, dword ptr [esp+8*4+8]	;offset hashedName
        mov	edi, dword ptr [esp+8*4+4]	;offset serialBin
        mov	ebx, dword ptr [esp+8*4+0Ch]	;what

	push	ebx
	and	ebx, 0FFh
	movsx	eax, byte ptr [esi+ebx]
	pop	ebx

	push	eax
	fild	dword ptr [esp]
	pop	eax
	fimul	word ptr [edi]
	movsx	eax, byte ptr [edi+5]
	push	eax				;D
	fimul	dword ptr [esp]
	;pop	eax

	shr	ebx, 8				;dla ret1->ebx:0100; ret2->ebx:0302
	movsx	eax, byte ptr [esi+ebx]
	push	eax
	fild	dword ptr [esp]
	pop	eax
	fimul	word ptr [edi+2]
	movsx	eax, byte ptr [edi+4]
	push	eax				;C
	fimul	dword ptr [esp]
	;pop	eax

	fsubp	st(1), st(0)

	fild	word ptr [edi]
	fimul	dword ptr [esp]
	fimul	dword ptr [esp+4]

	fild	word ptr [edi+2]
	fimul	dword ptr [esp]
	fimul	dword ptr [esp+4]

	fsubp	st(1), st(0)

	fdivp	st(1), st(0)

	dec	ebx
	test	ebx, ebx
	jnz	_ret0

	fld1
	fsubp	st(1), st(0)
_ret0:
	fstp	qword ptr [esp]
	pop	eax
	test	eax, eax
	jnz	_bad_p
	pop	eax
	and	eax, 7FFFFFFFh
	test	eax, eax
	jnz	_bad

	popad
	xor	eax, eax
	inc	eax
	ret	0Ch

_bad_p:	pop	eax
_bad:	popad
	xor	eax, eax
	ret	0Ch
_check endp

;push	what
;push	offset hashedName
;push	offset serialBin
_check2 proc
	pushad
        mov	esi, dword ptr [esp+8*4+8]	;offset hashedName
        mov	edi, dword ptr [esp+8*4+4]	;offset serialBin
        mov	ebx, dword ptr [esp+8*4+0Ch]	;what

	push	ebx
	shr	ebx, 8
	movsx	eax, byte ptr [esi+ebx]
	pop	ebx

	push	eax				;b	->d
	fild	dword ptr [esp]
	movsx	eax, byte ptr [edi+4]
	push	eax				;C
	fimul	dword ptr [esp]

	and	ebx, 0FFh
	movsx	eax, byte ptr [esi+ebx]
	push	eax				;a	->c
	fild	dword ptr [esp]
	movsx	eax, byte ptr [edi+5]
	push	eax				;D
	fimul	dword ptr [esp]
	fsubp	st(1), st(0)

	fild	word ptr [edi]
	fild	word ptr [edi+2]
	fsubp	st(1), st(0)

	fdivp	st(1), st(0)

	test	ebx, ebx
	jz	_ret0

	fld1
	fsubp	st(1), st(0)
_ret0:
	pop	eax
	pop	eax
	fstp	qword ptr [esp]

	pop	eax
	test	eax, eax
	jnz	_bad_p
	pop	eax
	and	eax, 7FFFFFFFh
	test	eax, eax
	jnz	_bad


	popad
	xor	eax, eax
	inc	eax
	ret	0Ch

_bad_p:	pop	eax
_bad:	popad
	xor	eax, eax
	ret	0Ch
_check2 endp

;push	offstet to hashed name
removeDet0 proc
	pushad

	mov	esi, dword ptr [esp+8*4+4]

	movsx	eax, byte ptr [esi]
	movsx	ebx, byte ptr [esi+1]
	movsx	ecx, byte ptr [esi+2]
	movsx	edx, byte ptr [esi+3]

	mov	ebp, eax

        test	eax, eax
	setne	ah

	and	eax, 0FF00h
	;shl	eax, 1
	or	al, ah

	test	edx, edx
	setne	ah
	shl	al, 1
	or	al, ah

	test	ebx, ebx
	setne	ah
	shl	al, 1
	or	al, ah

	test	ecx, ecx
	setne	ah
	shl	al, 1
	or	al, ah

	xor	ah, ah

	cmp	eax, 0Fh
	je	_next_test

	cmp	eax, 1
	jnz	_nt1
	inc	byte ptr [esi+1]
	jmp	_end
_nt1:
	cmp	eax, 2
	jnz	_nt2
	inc	byte ptr [esi+2]
	jmp	_end
_nt2:
	test	eax, eax
	jnz	_nt3
	inc	byte ptr [esi]
	inc	byte ptr [esi+3]
	jmp	_end
_nt3:
	cmp	eax, 4
	je	_ia
	cmp	eax, 5
	je	_ia
	cmp	eax, 6
	jnz	_nt5
_ia:
	inc	byte ptr [esi]
	jmp	_end
_nt5:
	cmp	eax, 8
	je	_id
	cmp	eax, 9
	je	_id
	cmp	eax, 10
	jnz	_end
_id:
	inc	byte ptr [esi+3]
	jmp	_end


_next_test:

	push	ebp
	fild	dword ptr [esp]
	push	edx
	fimul	dword ptr [esp]
	fld	st(0)
	push	ebx
	fild	dword ptr [esp]
	fdivp	st(1), st(0)
	frndint
	fimul	dword ptr [esp]
	fsub	st(0), st(1)
	fabs
	fistp	qword ptr [esp]
	pop	eax
	test	eax, eax
	jnz	_end_p
	pop	eax
	test	eax, eax
	jnz	_end_n

        push	ecx
        fild	dword ptr [esp]
        fsubp	st(1), st(0)
        fabs

        fistp	qword ptr [esp]

	pop	eax
	test	eax, eax
	jnz	_end_n
	pop	eax
	test	eax, eax
	jnz	_end

        inc	byte ptr [esi]
        jmp	_end


;_end_k:
;	add	esp, 4
_end_p:
	add	esp, 4
_end_n:
	add	esp, 4
_end:	popad
	ret	4
removeDet0 endp

start:
	;na starcie proga init FPU




	finit


	push	offset serialBuf
	call	_strlen

	ror	eax, 6
	dec	eax
	test	eax, eax
	jnz	_bad_boy

	mov	ebx, offset serialBin

	push	ebx			;offset serialBin
	push	offset serialBuf
	call	hexstr2intbuf

	push	offset cld1
	push	55
	push	offset firstSBox
	push	ebx			;offset serialBin
	call	_fake_md5

	push	offset cld1
	push	55
	push	offset secondSBox
	push	ebx			;offset serialBin+16
	add	dword ptr [esp], 16
	call	_fake_md5

	push	24
	push	ebx			;offset serialBin
	push	offset hashedSerial
	call	_rwf_md4


	xor	ecx, ecx
	mov	esi, ebx		;offset serialBin+24
	add	esi, 24
	mov	edi, offset hashedSerial
_nxt:
	lodsb
	cmp	al, byte ptr [edi+ecx*2]
	jnz	_bad_boy
	inc	ecx
	cmp	ecx, 8
	jnz	_nxt


	push	offset nm
	call	_strlen

	push	eax
	push	offset nm
	push	offset hashedName
	call	_rwf_md4

	mov	esi, ebx		;offset serialBin - 6
	sub	esi, 6
	mov	edi, offset hashedName - 4

	xor	ecx, ecx
_nxt2:
	add	esi, 6
	add	edi, 4

	push	edi
	call	removeDet0

        push	0100h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        call	_check
	test	eax, eax
	je	_bad_boy

        push	0100h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        call	_check2
	test	eax, eax
	je	_bad_boy

        push	0302h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        call	_check
	test	eax, eax
	je	_bad_boy

        push	0302h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        call	_check2
	test	eax, eax
	je	_bad_boy

	inc	ecx
	cmp	ecx, 4
	jnz	_nxt2

	nop
	nop

_bad_boy:

	push	0
	call	ExitProcess
end start


