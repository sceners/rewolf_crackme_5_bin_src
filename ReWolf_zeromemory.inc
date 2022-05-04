;push	sizeof buffer
;push	offset buffer
;call	_zeromemory

_zeromemory proc
	push	edi
	push	ecx
	push	eax
	mov	ecx,dword ptr [esp+8+0Ch]
	mov	edi,dword ptr [esp+4+0Ch]
	xor	eax,eax
	shr	ecx,2
	rep	stosd
        push	edi		;
        sub	edi,dword ptr [esp+8+0Ch]
        mov	ecx,dword ptr [esp+12+0Ch]
        sub	ecx,edi
        pop	edi		;
        rep	stosb
	pop	eax
	pop	ecx
	pop	edi
	ret	8
_zeromemory endp
