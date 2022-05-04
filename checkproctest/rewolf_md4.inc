comment  ~
----------------------------------------------------------------------------
|                     The MD4 Message-Digest Algorithm                     |
----------------------------------------------------------------------------
|   Description:                                                           |
|   ============                                                           |
|                                                                          |
|   The MD4 algorithm is designed to be quite fast on 32-bit machines. In  |
|   addition,  the MD4 algorithm  does not require any large substitution  |
|   tables, the algorithm can be coded quite compactly.                    |
|                                                                          |
|   The MD5 algorithm is being placed in the public domain for review and  |
|   possible adoption as a standard.                                       |
|                                                                          |
----------------------------------------------------------------------------
|   Implementation based on rfc1320 (fully rewritten in asm, not ripped :))|
----------------------------------------------------------------------------
|   Usage:                                                                 |
|   ======                                                                 |
|                                                                          |
|   Simply include this file to your project:                              |
|   exp: include \..path..\rewolf_md4.inc                                  |
|                                                                          |
|   Target compiler...: MASM                                               |
|   Calling convention:                                                    |
|                                                                          |
|	push	size of datablock                                          |
|	push	offset datablock                                           |
|	push	offset destHash                                            |
|	call	_rwf_md4                                                   |
|                                                                          |
|   datablock -> (input)  -> buffer that contains data to hash             |
|   destHash  -> (output) -> 16-bytes buffer for hashed data               |
|                                                                          |
|   Modified registers: none                                               |
|   Stack is automatically cleared                                         |
----------------------------------------------------------------------------
|   Coder.: ReWolf^HTB                                                     |
|   Date..: 20.XII.2004                                                    |
|   E-mail: rewolf@poczta.onet.pl                                          |
|   WWW...: http://www.rewolf.prv.pl                                       |
----------------------------------------------------------------------------
~

S11 = 3
S12 = 7
S13 = 11
S14 = 19
S21 = 3
S22 = 5
S23 = 9
S24 = 13
S31 = 3
S32 = 9
S33 = 11
S34 = 15

FF macro a,b,c,d,k,s
	mov	edi,b
	mov	ebp,b
	and	edi,c
	not	ebp
	and	ebp,d
	or	edi,ebp
	add	a,edi
	add	a,dword ptr [esi+k*4]
	rol	a,s
endm FF

GG macro a,b,c,d,k,s
	mov	ebp,b
	mov	edi,c
	or	edi,d
	and	ebp,edi
	mov	edi,c
	and	edi,d
	or	ebp,edi
	lea	a,dword ptr [a+ebp+05A827999h]
	add	a,dword ptr [esi+k*4]
	rol	a,s
endm GG

HH macro a,b,c,d,k,s
	mov	ebp,b
	xor	ebp,c
	xor	ebp,d
	lea	a,dword ptr [a+ebp+06ED9EBA1h]
	add	a,dword ptr [esi+k*4]
	rol	a,s
endm HH

.code
_rwf_md4 proc
	pushad
	mov	esi,dword ptr [esp+04h+8*4]
	mov	dword ptr [esi], 067452301h
	mov	dword ptr [esi+04h], 0efcdab89h
	mov	dword ptr [esi+08h], 098badcfeh
	mov	dword ptr [esi+0Ch], 010325476h
	mov	eax,dword ptr [esp+0Ch+8*4]
	push	eax
	xor	edx,edx
	mov	ecx,64
	div	ecx
	inc	eax
	pop	edx
	sub	esp,64
	mov	ebx,esp
	mov	esi,dword ptr [esp+08h+24*4]
	xchg	eax,edx
_n0:
	mov	edi,ebx
	dec	edx
	jne	_n1
	test	eax,eax
	js	_nD
	mov	byte ptr [ebx+eax],80h
	jmp	_nC
_nD:
	xor	eax,eax
	dec	eax
_nC:
	mov	ecx,64
	sub	ecx,eax
	add	edi,eax
	push	eax
	xor	eax,eax
	inc	edi
	dec	ecx
	rep	stosb
	pop	eax
	test	eax,eax
	js	_nB
	cmp	eax,56
	jnb	_nE
_nB:
        push	eax
	mov	eax,dword ptr [esp+0Ch+25*4]
	push	edx
	xor	edx,edx
	mov	ecx,8
	mul	ecx
	mov	dword ptr [ebx+56],eax
	mov	dword ptr [ebx+60],edx
	pop	edx
	pop	eax
	jmp	_n1
_nE:
	inc	edx
_n1:
	test	eax,eax
	js	_nA
	cmp	eax,64
	jnb	_n2
	jmp	_n10
_nA:
	xor	eax,eax
_n10:
	mov	ecx,eax
	jmp	_n3
_n2:
	mov	ecx,64
_n3:
	mov	edi,ebx
	rep	movsb
	push	eax
	push	edx
	push	ebx
	push	esi
	lea	esi,dword ptr [esp+10h]
	mov	edi,dword ptr [esp+4+28*4]
	push	edi
	mov	eax,dword ptr [edi]
	mov	ebx,dword ptr [edi+04h]
	mov	ecx,dword ptr [edi+08h]
	mov	edx,dword ptr [edi+0Ch]

	FF	eax, ebx, ecx, edx, 0, S11
	FF	edx, eax, ebx, ecx, 1, S12
	FF	ecx, edx, eax, ebx, 2, S13
	FF	ebx, ecx, edx, eax, 3, S14
	FF	eax, ebx, ecx, edx, 4, S11
	FF	edx, eax, ebx, ecx, 5, S12
	FF	ecx, edx, eax, ebx, 6, S13
	FF	ebx, ecx, edx, eax, 7, S14
	FF	eax, ebx, ecx, edx, 8, S11
	FF	edx, eax, ebx, ecx, 9, S12
	FF	ecx, edx, eax, ebx, 10, S13
	FF	ebx, ecx, edx, eax, 11, S14
	FF	eax, ebx, ecx, edx, 12, S11
	FF	edx, eax, ebx, ecx, 13, S12
	FF	ecx, edx, eax, ebx, 14, S13
	FF	ebx, ecx, edx, eax, 15, S14

	GG	eax, ebx, ecx, edx, 0, S21
	GG	edx, eax, ebx, ecx, 4, S22
	GG	ecx, edx, eax, ebx, 8, S23
	GG	ebx, ecx, edx, eax,12, S24
	GG	eax, ebx, ecx, edx, 1, S21
	GG	edx, eax, ebx, ecx, 5, S22
	GG	ecx, edx, eax, ebx, 9, S23
	GG	ebx, ecx, edx, eax,13, S24
	GG	eax, ebx, ecx, edx, 2, S21
	GG	edx, eax, ebx, ecx, 6, S22
	GG	ecx, edx, eax, ebx,10, S23
	GG	ebx, ecx, edx, eax,14, S24
	GG	eax, ebx, ecx, edx, 3, S21
	GG	edx, eax, ebx, ecx, 7, S22
	GG	ecx, edx, eax, ebx,11, S23
	GG	ebx, ecx, edx, eax,15, S24

	HH	eax, ebx, ecx, edx, 0, S31
	HH	edx, eax, ebx, ecx, 8, S32
	HH	ecx, edx, eax, ebx, 4, S33
	HH	ebx, ecx, edx, eax,12, S34
	HH	eax, ebx, ecx, edx, 2, S31
	HH	edx, eax, ebx, ecx,10, S32
	HH	ecx, edx, eax, ebx, 6, S33
	HH	ebx, ecx, edx, eax,14, S34
	HH	eax, ebx, ecx, edx, 1, S31
	HH	edx, eax, ebx, ecx, 9, S32
	HH	ecx, edx, eax, ebx, 5, S33
	HH	ebx, ecx, edx, eax,13, S34
	HH	eax, ebx, ecx, edx, 3, S31
	HH	edx, eax, ebx, ecx,11, S32
	HH	ecx, edx, eax, ebx, 7, S33
	HH	ebx, ecx, edx, eax,15, S34

	pop	edi
	add	dword ptr [edi],eax
	add	dword ptr [edi+04h],ebx
	add	dword ptr [edi+08h],ecx
	add	dword ptr [edi+0Ch],edx
	pop	esi
	pop	ebx
	pop	edx
	pop	eax
	sub	eax,64
	test	edx,edx
	jne	_n0
	add	esp,64
	popad
	ret	12
_rwf_md4 endp
