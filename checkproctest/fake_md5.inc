;|	push	offset clear_data
;|	push	size of datablock                                          |
;|	push	offset datablock                                           |
;|	push	offset destHash                                            |
;|	call	_rwf_md5                                                   |

comment *
xor_r32_r32 macro _a,_b
	push	edi						;1
	push	_b						;1
	inc	byte ptr [$+9];[_c1+1]				;6
	push	_a						;1
	push	_b						;1
	call	$+10;_1-1	;;				;5
	call	$+26;_33	;;				;5
	db	0ebh		;;				;1
	dec	byte ptr [$-10];[_c1+1]				;6
	not	_a		;;				;2
	inc	byte ptr [$+7];[_c2+1]				;6
	call	$+43;_2-1	;;				;5
	ret			;;				;1
	pop	edi		;;				;1
	pop	edi						;1
	call	$+15;_55	;;				;5
	db	0ebh		;;				;1
	dec	byte ptr [$+45];[_c3+1]				;6
	and	_a, _b		;;				;2
	ret			;;				;1
	pop	_b		;;				;1
	pop	_b						;1
	inc	byte ptr [$+7];[_c5+1]				;6
	call	$+40;_5-1	;;				;5
	or	_a, _b						;2
	call	$+26;_44	;;				;5
	db	0ebh		;;				;1
	dec	byte ptr [$-43];[_c2+1]				;6
	not	_b		;;				;2
	inc	byte ptr [$+7];[_c3+1]				;6
	call	$-45;_3-1	;;				;5
	ret			;;				;1
	pop	_b		;;				;1
	pop	_b						;1
	call	$+15;_66	;;				;5
	db	0ebh		;;				;1
	dec	byte ptr [$-38h];[_c5+1]				;6
	and	_b, edi		;;				;2
	ret			;;				;1
	pop	edi		;;				;1
	pop     edi						;1
	not	_a						;2
endm xor_r32_r32
*

xor_r32_r32 macro _a,_b
	push	edi						;1
	push	_b						;1

	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1

	inc	byte ptr [_b+8];[_c1+1]			;3
	pop	_b		;<<<				1

	push	_a						;1
	push	_b						;1
	call	$+10;_1-1	;;				;5	;+10
	call	$+36;_33	;;				;5
	db	0ebh		;;				;1


	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	dec	byte ptr [_b-16];[_c1+1]			;6
	pop	_b		;<<<


	not	_a		;;				;2


	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	inc	byte ptr [_b+6];[_c2+1]			;3
	pop	_b


	call	$+53;_2-1	;;				;5	;+21
	ret			;;				;1
	pop	edi		;;				;1
	pop	edi						;1
	call	$+20;_55	;;				;5
	db	0ebh		;;				;1

	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	dec	byte ptr [_b+3bh];[_c3+1]				;6
	pop	_b

	and	_a, _b		;;				;2
	ret			;;				;1
	pop	_b		;;				;1
	pop	_b						;1


	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	inc	byte ptr [_b+6];[_c5+1]				;6
	pop	_b

	call	$+50;_5-1	;;				;5
	or	_a, _b						;2
	call	$+36;_44	;;				;5
	db	0ebh		;;				;1


	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	dec	byte ptr [_b-59];[_c2+1]			;6
	pop	_b

	not	_b		;;				;2

	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	inc	byte ptr [_b+6];[_c3+1]				;3
	pop	_b

	call	$-65;_3-1	;;				;5
	ret			;;				;1
	pop	_b		;;				;1
	pop	_b						;1
	call	$+20;_66	;;				;5
	db	0ebh		;;				;1

	push	_b		;<<<				1
	call	$+5		;<<<				5
	pop	_b		;<<<				1
	dec	byte ptr [_b-38h];[_c5+1]				;6
	pop	_b

	and	_b, edi		;;				;2
	ret			;;				;1
	pop	edi		;;				;1
	pop     edi						;1
	not	_a						;2
endm xor_r32_r32

xor2_r32_r32 macro _xor2_a, _xor2_b
	push	edi
	push	esi
	push	_xor2_b
	push	_xor2_a
	push	_xor2_b
	call	$+10
	db	68h
	not	_xor2_a
	or	_xor2_a, _xor2_b
	pop	edi
	push	14C258h
	push	5F00C604h
	push	24448B50h
	push	dword ptr [edi+1]
	push	esp
	call	dword ptr [esp]
        pop	edi
        pop	_xor2_b
        call	$+10
        db	68h
        or	edi, _xor2_b
        and	_xor2_a, edi
	pop	esi
	push	18C258h
	push	9000C604h
	push	24448B50h
	push	dword ptr [esi+1]
	push	90D7F790h
	push	esp
	call	dword ptr [esp]
	nop
        pop	_xor2_b
        pop	esi
        call	$+10
        db	68h
        nop
	not	_xor2_a
	nop
	pop	edi
	push	0CC2h
	push	dword ptr [edi+1]
	push	esp
	call	dword ptr [esp]
	pop	edi
endm xor2_r32_r32

S11 = 7
S12 = 12
S13 = 17
S14 = 22
S21 = 5
S22 = 9
S23 = 14
S24 = 20
S31 = 4
S32 = 11
S33 = 16
S34 = 23
S41 = 6
S42 = 10
S43 = 15
S44 = 21

FF macro a,b,c,d,k,s,i
	mov	ebp, d
	xor2_r32_r32	ebp, c
	xor2_r32_r32	ebp, b
	lea	a,dword ptr [a+ebp+i]
	add	a,dword ptr [esi+k*4]
	rol	a,s
	add	a,b
endm FF

GG macro a,b,c,d,k,s,i
	mov	ebp, c
	xor_r32_r32	ebp, b
	xor_r32_r32	ebp, d
	lea	a,dword ptr [a+ebp+i]
	add	a,dword ptr [esi+k*4]
	rol	a,s
	add	a,b
endm GG

HH macro a,b,c,d,k,s,i
	mov	ebp,b
	xor_r32_r32	ebp, c
	xor2_r32_r32	ebp, d
	lea	a,dword ptr [a+ebp+i]
	add	a,dword ptr [esi+k*4]
	rol	a,s
	add	a,b
endm HH

II macro a,b,c,d,k,s,i
	mov	ebp,d
	xor2_r32_r32	ebp, b
	xor_r32_r32	ebp, c
	lea	a,dword ptr [a+ebp+i]
	add	a,dword ptr [esi+k*4]
	rol	a,s
	add	a,b
endm II

.code
_fake_md5 proc
	pushad
	mov	eax, dword ptr [esp+0Ch+8*4]	;size of data block
	push	eax
	xor	edx, edx
	mov	ecx, 64
	div	ecx
	inc	eax
	pop	edx
	sub	esp, 64
	mov	ebx, esp
	mov	esi, dword ptr [esp+08h+24*4]	;offset to data block
	xchg	eax, edx
_n0:
	mov	edi, ebx
	dec	edx
	jne	_n1
	test	eax, eax
	js	_nD
	mov	byte ptr [ebx+eax], 80h
	jmp	_nC
_nD:
	xor	eax, eax
	dec	eax
_nC:
	mov	ecx, 64
	sub	ecx, eax
	add	edi, eax
	push	eax
	xor	eax, eax
	inc	edi
	dec	ecx
	rep	stosb
	pop	eax
	test	eax, eax
	js	_nB
	cmp	eax, 56
	jnb	_nE
_nB:
        push	eax
	mov	eax, dword ptr [esp+0Ch+25*4]
	push	edx
	xor	edx, edx
	mov	ecx, 8
	mul	ecx
	mov	dword ptr [ebx+56], eax
	mov	dword ptr [ebx+60], edx
	pop	edx
	pop	eax
	jmp	_n1
_nE:
	inc	edx
_n1:
	test	eax, eax
	js	_nA
	cmp	eax, 64
	jnb	_n2
	jmp	_n10
_nA:
	xor	eax, eax
_n10:
	mov	ecx, eax
	jmp	_n3
_n2:
	mov	ecx, 64
_n3:
	mov	edi, ebx
	rep	movsb
	push	eax
	push	edx
	push	ebx
	push	esi
	lea	esi, dword ptr [esp+10h]
	mov	edi, dword ptr [esp+4+28*4]
	push	edi
	mov	eax, dword ptr [edi]
	mov	ebx, dword ptr [edi+04h]
	mov	ecx, dword ptr [edi+08h]
	mov	edx, dword ptr [edi+0Ch]

	FF	eax, ebx, ecx, edx, 0, S11, 0d76aa478h
	FF	edx, eax, ebx, ecx, 1, S12, 0e8c7b756h
	FF	ecx, edx, eax, ebx, 2, S13, 0242070dbh
	FF	ebx, ecx, edx, eax, 3, S14, 0c1bdceeeh
	FF	eax, ebx, ecx, edx, 4, S11, 0f57c0fafh
	FF	edx, eax, ebx, ecx, 5, S12, 04787c62ah
	FF	ecx, edx, eax, ebx, 6, S13, 0a8304613h
	FF	ebx, ecx, edx, eax, 7, S14, 0fd469501h
	FF	eax, ebx, ecx, edx, 8, S11, 0698098d8h
	FF	edx, eax, ebx, ecx, 9, S12, 08b44f7afh
	FF	ecx, edx, eax, ebx, 10, S13, 0ffff5bb1h
	FF	ebx, ecx, edx, eax, 11, S14, 0895cd7beh
	FF	eax, ebx, ecx, edx, 12, S11, 06b901122h
	FF	edx, eax, ebx, ecx, 13, S12, 0fd987193h
	FF	ecx, edx, eax, ebx, 14, S13, 0a679438eh
	FF	ebx, ecx, edx, eax, 15, S14, 049b40821h

	GG	eax, ebx, ecx, edx, 1, S21, 0f61e2562h
	GG	edx, eax, ebx, ecx, 6, S22, 0c040b340h
	GG	ecx, edx, eax, ebx,11, S23, 0265e5a51h
	GG	ebx, ecx, edx, eax, 0, S24, 0e9b6c7aah
	GG	eax, ebx, ecx, edx, 5, S21, 0d62f105dh
	GG	edx, eax, ebx, ecx,10, S22, 002441453h
	GG	ecx, edx, eax, ebx,15, S23, 0d8a1e681h
	GG	ebx, ecx, edx, eax, 4, S24, 0e7d3fbc8h
	GG	eax, ebx, ecx, edx, 9, S21, 021e1cde6h
	GG	edx, eax, ebx, ecx,14, S22, 0c33707d6h
	GG	ecx, edx, eax, ebx, 3, S23, 0f4d50d87h
	GG	ebx, ecx, edx, eax, 8, S24, 0455a14edh
	GG	eax, ebx, ecx, edx,13, S21, 0a9e3e905h
	GG	edx, eax, ebx, ecx, 2, S22, 0fcefa3f8h
	GG	ecx, edx, eax, ebx, 7, S23, 0676f02d9h
	GG	ebx, ecx, edx, eax,12, S24, 08d2a4c8ah

	HH	eax, ebx, ecx, edx, 5, S31, 0fffa3942h
	HH	edx, eax, ebx, ecx, 8, S32, 08771f681h
	HH	ecx, edx, eax, ebx,11, S33, 06d9d6122h
	HH	ebx, ecx, edx, eax,14, S34, 0fde5380ch
	HH	eax, ebx, ecx, edx, 1, S31, 0a4beea44h
	HH	edx, eax, ebx, ecx, 4, S32, 04bdecfa9h
	HH	ecx, edx, eax, ebx, 7, S33, 0f6bb4b60h
	HH	ebx, ecx, edx, eax,10, S34, 0bebfbc70h
	HH	eax, ebx, ecx, edx,13, S31, 0289b7ec6h
	HH	edx, eax, ebx, ecx, 0, S32, 0eaa127fah
	HH	ecx, edx, eax, ebx, 3, S33, 0d4ef3085h
	HH	ebx, ecx, edx, eax, 6, S34, 004881d05h
	HH	eax, ebx, ecx, edx, 9, S31, 0d9d4d039h
	HH	edx, eax, ebx, ecx,12, S32, 0e6db99e5h
	HH	ecx, edx, eax, ebx,15, S33, 01fa27cf8h
	HH	ebx, ecx, edx, eax, 2, S34, 0c4ac5665h

	II	eax, ebx, ecx, edx, 0, S41, 0f4292244h
	II	edx, eax, ebx, ecx, 7, S42, 0432aff97h
	II	ecx, edx, eax, ebx,14, S43, 0ab9423a7h
	II	ebx, ecx, edx, eax, 5, S44, 0fc93a039h
	II	eax, ebx, ecx, edx,12, S41, 0655b59c3h
	II	edx, eax, ebx, ecx, 3, S42, 08f0ccc92h
	II	ecx, edx, eax, ebx,10, S43, 0ffeff47dh
	II	ebx, ecx, edx, eax, 1, S44, 085845dd1h
	II	eax, ebx, ecx, edx, 8, S41, 06fa87e4fh
	II	edx, eax, ebx, ecx,15, S42, 0fe2ce6e0h
	II	ecx, edx, eax, ebx, 6, S43, 0a3014314h
	II	ebx, ecx, edx, eax,13, S44, 04e0811a1h
	II	eax, ebx, ecx, edx, 4, S41, 0f7537e82h
	II	edx, eax, ebx, ecx,11, S42, 0bd3af235h
	II	ecx, edx, eax, ebx, 2, S43, 02ad7d2bbh
	II	ebx, ecx, edx, eax, 9, S44, 0eb86d391h

	pop	edi
	mov	dword ptr [edi],eax
	mov	dword ptr [edi+04h],ebx
	mov	dword ptr [edi+08h],ecx
	mov	dword ptr [edi+0Ch],edx
	pop	esi
	pop	ebx
	pop	edx
	pop	eax
	sub	eax, 64
	test	edx, edx
	jne	_n0
	add	esp, 64
	mov	esi, dword ptr [esp+10h+8*4]
	movzx	ecx, byte ptr [esi]
	inc	esi
	mov	edi, dword ptr [esp+8*4]
	rep	movsb
	popad
	ret	16
_fake_md5 endp
