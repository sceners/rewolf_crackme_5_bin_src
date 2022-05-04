.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
includelib \masm32\lib\kernel32
includelib \masm32\lib\user32
includelib \masm32\lib\gdi32

include \masm32\include\mfmPlayer.inc
includelib \masm32\lib\mfmPlayer.lib

include scroller.inc
includelib scroller

include depack.asm

IDD_DLG1 = 1000

.data
	include checkproctest\check2_pak.inc
	include checkproctest\check_pak.inc
	include checkproctest\fakeMD5_pak.inc
	include checkproctest\hexstr2intbuf_pak.inc
	include checkproctest\md4_pak.inc
	include checkproctest\removeDet0_pak.inc


	music_start dd offset music_end - music_start -4
	include xm.inc
	music_end equ $

	cld1 db 13, 89h, 44h, 24h, 20h, 68h, 0, 40h, 0, 0, 53h, 0ffh, 75h, 0fch

;	strTest db 'Test',0
	strBmpMain db 'MAIN',0
	strBmpGrayD db 'GRAY_D',0
	strBmpGreenD db 'GREEN_D',0
	strBmpRedD db 'RED_D',0
	bFirstPaint db 0
	sttt db 'ReWolf',0;13,10,13,0

	strScrollText db '-=[ Hard.To.Beat.Team.proudly.presents.CrackMe.#5.by.ReWolf ]='
	              db '-=[ cOde:.ReWolf..gFx:.ReWolf..sFx:.zalza ]='
	              db '-=[ visit.my.homepage:.http://www.rewolf.prv.pl ]='
	              db '-=[ e-mail:.rewolf@poczta.onet.pl ]='
	              db '-=[ greetz.goes.to:.renno.Cauchy.ToMKoL.and.all.the.rest.that.I.know ]=-'
	              db '                           -=[ "God.made.the.natural.numbers;.all.else.is.the.work.of.man" ]=-=[ Leopold.Kronecker ]=-'
	              db 0

	Scroll SCROLLSTRUCT <210,SRCPAINT,25,231,0,offset strScrollText,0,0F0F0F0h,0>
        sF db 0

	firstSBox dd 030fb40d4h, 9fa0ff0bh, 06beccd2fh, 3f258c7ah, 1e213f2fh, 9c004dd3h, 06003e540h, 0cf9fc949h
                  dd 0bfd4af27h, 88bbbdb5h, 0e2034090h, 98d09675h, 6e63a0e0h, 15c361d2h, 0c2e7661dh, 022d4ff8eh
        secondSBox dd 08defc240h, 025fa5d9fh, 0eb903dbfh, 0e810c907h, 47607fffh, 0369fe44bh, 08c1fc644h, 0aececa90h
                   dd 0beb1f9bfh, 0eefbcaeah, 0e8cf1950h, 051df07aeh, 920e8806h, 0f0ad0548h, 0e13c8d83h, 0927010d5h


.data?
	nameBuf db 65 DUP (?)
	serialBuf db 65 DUP (?)
	serialBin db 32 DUP (?)
	hashedName db 16 DUP (?)
	hashedSerial db 16 DUP (?)

	dtWndPos RECT <?>
	dtPaintStr PAINTSTRUCT <?>
	hDesktopBitmap dd ?
	hDeskCompDC dd ?
	hDeskCompBmp dd ?
	hBackBmp dd ?
	hBackDC dd ?
	hWndDC dd ?
	hWnd dd ?

	hBmpGrayD dd ?
	hBmpRedD dd ?
	hBmpGreenD dd ?

	ddDPrev dd ?
	ddDCurr dd ?

	cracked db ?

;.shrdata
;segment '.test' readable writeable execuable

.code
include rewolf_int2hex.inc
include rewolf_zeromemory.inc


P1D_start equ $
P1Decrypt proc
	LOCAL hMem : DWORD
	pushad

	push	dword ptr [esp+11*4];8*6+4-8]
	pop	P1_what

	mov	decr, 1

	push	PE32.th32ParentProcessID
	push	0
	push	PROCESS_ALL_ACCESS
	call	OpenProcess
	push	eax

	mov	temp_f1, 0

_wait1:
	push	10
	call	Sleep

        pop	eax
        push	eax

	push	0
	push	1
	push	offset temp_f1
	push	offset decr
	push	eax
	call	ReadProcessMemory

	cmp	byte ptr [temp_f1],1
	jnz	_wait1

        mov	ebx, P1_what
        mov	ebx, dword ptr [ebx]

	push	PAGE_EXECUTE_READWRITE
	push	MEM_COMMIT
	push    ebx
	push	0
	call	VirtualAlloc
	mov	hMem, eax

	pop	eax
	push	eax

        push	0
        push	4
        push	offset P2_where
        push	offset P2_where
        push	eax
        call	ReadProcessMemory

        pop	eax
        push	eax

        push	0
        push	ebx
        push	hMem
        push	P2_where
        push	eax
        call	ReadProcessMemory

	mov	eax, dword ptr [esp+13*4]
	mov	ecx, eax
_next_push:
	test	eax, eax
	je	_call_proc
	push	dword ptr [esp+13*4+ecx*4];+0Ch]
	;inc	ecx
	dec	eax
	jmp	_next_push


_call_proc:
	call	hMem
	mov	dword ptr [esp+20h], eax

	push	MEM_DECOMMIT
	push	ebx
	push	hMem
	call	VirtualFree

	mov	decr, 2

	mov	temp_f1, 0
_wait2:
	push	10
	call	Sleep

        pop	eax
        push	eax

	push	0
	push	1
	push	offset temp_f1
	push	offset decr
	push	eax
	call	ReadProcessMemory

	cmp	byte ptr [temp_f1], 0
	jnz	_wait2

	mov	decr, 0


	;<<<
	;push	100
	;call	Sleep
	;<<<

	pop	eax

	popad
	ret	8
P1Decrypt endp
P1D_end equ $

CM5Th_start equ $
CM5ThProc proc hDlg : DWORD
	LOCAL hDDC : DWORD
	LOCAL ddCntr : DWORD


	mov	ddDPrev, 1
	mov	ddDCurr, 0
	mov	ddCntr, 0

	push	hWndDC
	call	CreateCompatibleDC
	mov	hDDC, eax


_s:

	cmp	ddCntr, 8
	jnz	_skpdd

	mov	ddCntr, 0

	push	hBmpGrayD
	push	hDDC
	call	SelectObject

	push	SRCCOPY
	mov	eax, 13
	mul	ddDPrev
	push	eax
	push	0
	push	hDDC
	push	13
	push	14
	push	eax
	add	dword ptr [esp], 11
	push	9
	push	hWndDC
	call	BitBlt


	cmp	cracked, 1
	je	_green_a

	;push	offset strCMOK
	;push	0
	;push	0
	;call	OpenMutex
	;call	GetLastError
	;cmp	eax, ERROR_ACCESS_DENIED
	;je	_green

	push	hBmpRedD
	push	hDDC
	call	SelectObject
	jmp	_pd
_green:
	;mov	cracked, 1

	;push	0
	;push	TRUE
	;push	EM_SETREADONLY
	;push	1002
	;push	hWnd
	;call	SendDlgItemMessage

	;push	0
	;push	TRUE
	;push	EM_SETREADONLY
	;push	1003
	;push	hWnd
	;call	SendDlgItemMessage


_green_a:
	push	hBmpGreenD
	push	hDDC
	call	SelectObject

_pd:
	push	SRCCOPY
	mov	eax, 13
	mul	ddDCurr
	push	eax
	push	0
	push	hDDC
	push	13
	push	14
	push	eax
	add	dword ptr [esp], 11
	push	9
	push	hWndDC
	call	BitBlt



	mov	eax, ddDCurr
	test	eax, eax
	jne	_n1
	inc	ddDCurr
	dec	ddDPrev
	jmp	_e
_n1:	cmp	eax, 4
	jne	_n2
	dec	ddDCurr
	inc	ddDPrev
	jmp	_e
_n2:	cmp	eax, ddDPrev
	jb	_n3
	inc	ddDCurr
	inc	ddDPrev
	jmp	_e
_n3:	dec	ddDCurr
	dec	ddDPrev
_e:


_skpdd:
	inc	ddCntr


	cmp	sF, 0
	je	_n

	push	offset Scroll
	call	scrollPaint
_n:
	push	30
	call	Sleep

	jmp	_s

	ret
CM5ThProc endp
CM5Th_end equ $

CM5Dlg_start equ $
CM5DlgProc proc hDlg,uMsg,wParam,lParam:DWORD
	pushad

	cmp	uMsg, WM_CLOSE
	je	_close
	cmp	uMsg, WM_INITDIALOG
	je	_init
	cmp	uMsg, WM_MOUSEMOVE
	je	_mousemove
	cmp	uMsg, WM_PAINT
	je	_paint
	cmp	uMsg, WM_CTLCOLOREDIT
	je	_ctlcoloredit
	cmp	uMsg, WM_CTLCOLORSTATIC
	je	_ctlcoloredit
	cmp	uMsg, WM_LBUTTONUP
	je	_lbu
	;cmp	uMsg, WM_PRINT
	;je	_print
	;cmp	uMsg, WM_PRINTCLIENT
	;je	_print


_end:	popad
	xor	eax, eax
	ret

_close:
	push	hDeskCompDC
	call	DeleteDC
	push	hBackDC
	call	DeleteDC
	push	hDeskCompBmp
	call	DeleteObject

	push	offset Scroll
	call	scrollDestroy

	;push	AW_HIDE or AW_SLIDE or AW_VER_POSITIVE
	;push	2000
	;push	hDlg
	;call	AnimateWindow

	push	0
	push	hDlg
	call	EndDialog
	jmp	_end

_lbu:
	mov	eax, lParam

	cmp	ax, 36		;top=16		66x18
	jb	_end
	cmp	ax, 102
	ja	_end

	shr	eax, 16

	cmp	eax, 16
	jb	_end
	cmp	eax, 34
	ja	_lbu_1
	jmp	_close
_lbu_1:
        cmp	eax, 54
        jb	_check

	jmp	_end

_check:
	;start of check proc
	;mov	childCheck, 1

	cmp	cracked, 1
	je	_end

	push	65
	push	offset serialBuf
	push	1003
	push	hDlg
	call	GetDlgItemText

	ror	eax, 6
	dec	eax
	test	eax, eax
	jnz	_end

	mov	ebx, offset serialBin

	push	ebx			;offset serialBin
	push	offset serialBuf
	push	2
	push	offset hexstr2intbuf_pak
	call	P1Decrypt
	add	esp, 8

	push	offset cld1
	push	55
	push	offset firstSBox
	push	ebx			;offset serialBin
	push	4
	push	offset fakeMD5_pak
	call	P1Decrypt
	add	esp, 16


	push	offset cld1
	push	55
	push	offset secondSBox
	push	ebx			;offset serialBin+16
	add	dword ptr [esp], 16
	push	4
	push	offset fakeMD5_pak
	call	P1Decrypt
	add	esp, 16

	push	24
	push	ebx			;offset serialBin
	push	offset hashedSerial
	push	3
	push	offset md4_pak
	call	P1Decrypt
	add	esp, 12

	xor	ecx, ecx
	mov	esi, ebx		;offset serialBin+24
	add	esi, 24
	mov	edi, offset hashedSerial
_nxt:
	lodsb
	cmp	al, byte ptr [edi+ecx*2]
	jnz	_end
	inc	ecx
	cmp	ecx, 8
	jnz	_nxt


	push	65
	push	offset nameBuf
	push	1002
	push	hDlg
	call	GetDlgItemText

	push	eax
	push	offset nameBuf
	push	offset hashedName
	push	3
	push	offset md4_pak
	call	P1Decrypt
	add	esp, 12

	mov	esi, ebx		;offset serialBin - 6
	sub	esi, 6
	mov	edi, offset hashedName - 4

	xor	ecx, ecx
_nxt2:
	add	esi, 6
	add	edi, 4

	push	edi
	push	1
	push	offset removeDet0_pak
	call	P1Decrypt
	add	esp, 4

        push	0100h
        push	edi		;offset hashedName
        push	esi
        push	3
        push	offset check_pak		;offset serialBin
        call	P1Decrypt
        add	esp, 12
	test	eax, eax
	je	_end

        push	0100h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        push	3
        push	offset check2_pak
        call	P1Decrypt
        add	esp, 12
	test	eax, eax
	je	_end

        push	0302h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        push	3
        push	offset check_pak
        call	P1Decrypt
        add	esp, 12
	test	eax, eax
	je	_end

        push	0302h
        push	edi		;offset hashedName
        push	esi		;offset serialBin
        push	3
        push	offset check2_pak
        call	P1Decrypt
        add	esp, 12
	test	eax, eax
	je	_end

	inc	ecx
	cmp	ecx, 4
	jnz	_nxt2

	mov	cracked, 1

	push	0
	push	TRUE
	push	EM_SETREADONLY
	push	1002
	push	hDlg
	call	SendDlgItemMessage

	push	0
	push	TRUE
	push	EM_SETREADONLY
	push	1003
	push	hDlg
	call	SendDlgItemMessage

	;push	offset serialBin
	;push	offset serialBuf
	;push	2
	;push	offset hexstr2intbuf_pak
	;call	P1Decrypt
	;add	esp, 8

	jmp	_end

_init:

	push	103
	push	400000h
	call	LoadIcon

	push	eax

	push	eax
	push	ICON_SMALL
	push	WM_SETICON
	push	hDlg
	call	SendMessage

	push	ICON_BIG
	push	WM_SETICON
	push	hDlg
	call	SendMessage


	push	hDlg
	pop	hWnd

	push	hDlg
	call	GetWindowDC
	mov	hWndDC, eax

	call	GetDesktopWindow
	push	eax
	call	GetWindowDC
	push	eax

	push	eax
	call	CreateCompatibleDC
	mov	hDeskCompDC, eax

	mov	eax, dword ptr [esp]
	push	128
	push	256
	push	eax
	call	CreateCompatibleBitmap
	mov	hDeskCompBmp, eax

	push	eax
	push	hDeskCompDC
	call	SelectObject

	push	offset dtWndPos
	push	hDlg
	call	GetWindowRect

	pop	ecx

	push	SRCCOPY
	push	dtWndPos.top
	add	dword ptr [esp], 128
	push	dtWndPos.left
	push	ecx
	push	128
	push	256
	push	0
	push	0
	push	hDeskCompDC
	call	BitBlt

	push	LR_DEFAULTSIZE
	push	0
	push	0
	push	IMAGE_BITMAP
	push	offset strBmpMain
	push	400000h
	call	LoadImage
	mov	hBackBmp, eax

	push	hDeskCompDC
	call	CreateCompatibleDC
	mov	hBackDC, eax

	push	hBackBmp
	push	eax
	call	SelectObject

	push	SYSTEM_FIXED_FONT
	call	GetStockObject
	push	eax

	push	TRUE
	push	eax
	push	WM_SETFONT
	push	1002
	push	hDlg
	call	SendDlgItemMessage

	pop	eax

	push	TRUE
	push	eax
	push	WM_SETFONT
	push	1003
	push	hDlg
	call	SendDlgItemMessage

	push	LR_DEFAULTSIZE
	push	0
	push	0
	push	IMAGE_BITMAP
	push	offset strBmpGrayD
	push	400000h
	call	LoadImage
	mov	hBmpGrayD, eax

	push	LR_DEFAULTSIZE
	push	0
	push	0
	push	IMAGE_BITMAP
	push	offset strBmpGreenD
	push	400000h
	call	LoadImage
	mov	hBmpGreenD, eax

	push	LR_DEFAULTSIZE
	push	0
	push	0
	push	IMAGE_BITMAP
	push	offset strBmpRedD
	push	400000h
	call	LoadImage
	mov	hBmpRedD, eax

        xor	eax, eax
        push	0
        push	esp
        push	eax
        push	hDlg
        push	offset CM5ThProc
        push	eax
        push	eax
        call	CreateThread

	pop	eax

	jmp	_end

_paint:
	push	offset dtPaintStr
	push	hDlg
	call	BeginPaint

	cmp	bFirstPaint, 0
	jne	_paint_next
	inc	bFirstPaint

	push	SRCCOPY
	push	0
	push	0
	push	hBackDC
	push	128
	push	256
	push	0
	push	0
	push	hWndDC
	call	BitBlt

	push	SRCCOPY
	push	0
	push	0
	push	hDeskCompDC
	push	128
	push	256
	push	128
	push	0
	push	hWndDC
	call	BitBlt

	mov	ebx, 1
_1:
	push	SRCCOPY
	push	256
	sub	dword ptr [esp], ebx
	push	0
	push	hBackDC
	push	ebx
	push	256
	push	128
	push	0
	push	hWndDC
	call	BitBlt

	inc	ebx

	push	40
	call	Sleep
	cmp	ebx, 128
	jne	_1

	push	1002
	push	hDlg
	call	GetDlgItem

	push	SW_SHOW
	push	eax
	call	ShowWindow

	push	1003
	push	hDlg
	call	GetDlgItem

	push	SW_SHOW
	push	eax
	call	ShowWindow

	push	offset sttt
	push	1002
	push	hDlg
	call	SetDlgItemText


	push	SYSTEM_FIXED_FONT
	call	GetStockObject
        mov	Scroll.hFont, eax

        push	hWndDC
        pop	Scroll.hBkgDC


	push	offset Scroll
	call	scrollCreate

	mov	sF, 1

_paint_next:

	push	SRCCOPY
	push	0
	push	0
	push	hBackDC
	push	256
	push	256
	push	0
	push	0
	push	hWndDC
	call	BitBlt

	push	offset dtPaintStr
	push	hDlg
	call	EndPaint

	jmp	_end

_ctlcoloredit:
	push	00F0F0F0h
	push	wParam
	call	SetTextColor

	push	0
	push	wParam
	call	SetBkColor

	push	OPAQUE
	push	wParam
	call	SetBkMode

	popad
	push	BLACK_BRUSH
	call	GetStockObject
	ret

_mousemove:
	push	hDlg
	call	UpdateWindow

	cmp	wParam, 1
	je	_moveok
	jmp	_end
_moveok:
	call	ReleaseCapture
	push	0
	push	0F012h
	push	WM_SYSCOMMAND
	push	hDlg
	call	SendMessage
	jmp	_end

;_print:
	;push	SRCCOPY
	;push	0
	;push	0
	;push	hBackDC
	;push	256
	;push	256
	;push	0
	;push	0
	;push	wParam
	;call	BitBlt

;	call	GetLastError
	;jmp	_end

CM5DlgProc endp
CM5Dlg_end equ $

.data
	_SI STARTUPINFO <sizeof STARTUPINFO,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>
	strCMEND db 'CM5END',0
	;strCMOK db 'CMOK',0
	decr db 0

.data?
	P1_what dd ?
	P2_where dd ?

	hTool dd ?
	PE32 PROCESSENTRY32 <?>
	ddCurrentProcessID dd ?
	P2ID dd ?
	strHexID db 10 DUP (?)
	_PI PROCESS_INFORMATION <?>
	strFileName db 256 DUP (?)
	childEnd db ?
	childCheck db ?

	temp_f1 db ?

.code

start:
	finit
	call	GetCurrentProcessId
	mov	ddCurrentProcessID, eax
	push	eax

	mov	PE32.dwSize, sizeof PROCESSENTRY32

	push	0
	push	TH32CS_SNAPPROCESS
	call	CreateToolhelp32Snapshot
	mov	hTool, eax

	push	offset PE32
	push	eax
	call	Process32First

	pop	eax
	push	eax
	cmp	eax, PE32.th32ProcessID
	je	_end_process

_next_process:
	push	offset PE32
	push	hTool
	call	Process32Next

	pop	eax
	push	eax
	cmp	eax, PE32.th32ProcessID
	jnz	_next_process

_end_process:
	push	hTool
	call	CloseHandle

	push	PE32.th32ParentProcessID
	push	9
	push	offset strHexID
	call	_int2hex


	push	offset strHexID
	push	0
	push	0
	call	OpenMutex

	call	GetLastError
	;cmp	eax, ERROR_INVALID_NAME		;Win9x
	cmp	eax, ERROR_FILE_NOT_FOUND	;WinNT
	jnz	_second_process

	push	CM5Dlg_end - CM5Dlg_start
	push	CM5Dlg_start
	call	_zeromemory

	push	CM5Th_end - CM5Th_start
	push	CM5Th_start
	call	_zeromemory

	push	P1D_end - P1D_start
	push	P1D_start
	call	_zeromemory

	pop	eax

	push	eax
	push	9
	push	offset strHexID
	call	_int2hex

	xor	ebx, ebx

	push	offset strHexID
	push	ebx
	push	ebx
	call	CreateMutex

	push	offset _PI
	push	offset _SI
	push	ebx
	push	ebx
	push	NORMAL_PRIORITY_CLASS
	push	ebx
	push	ebx
	push	ebx
	push	ebx

	push	256
	push	offset strFileName
	push	0
	call	GetModuleFileName

	push	offset strFileName
	call	CreateProcess

_here:
	mov	temp_f1, 0
	push	0
	push	1
	push	offset temp_f1
	push	offset decr
	push	_PI.hProcess
	call	ReadProcessMemory
	cmp	temp_f1, 0
	jz	_event1

	push	0
	push	4
	push	offset P1_what
	push	offset P1_what
	push	_PI.hProcess
	call	ReadProcessMemory

	mov	ebx, P1_what
	add	P1_what, 4
	mov	ebx, dword ptr [ebx]


	push	PAGE_EXECUTE_READWRITE
	push	MEM_COMMIT
	push	ebx
	push	0
	call	VirtualAlloc
	mov	P2_where, eax
	push	eax

        push	eax
        push	P1_what
        call	_aP_depack_asm
        add	esp, 8

        mov	decr, 1

	mov	temp_f1, 0
_wait3:
	push	10
	call	Sleep

	push	0
	push	1
	push	offset temp_f1
	push	offset decr
	push	_PI.hProcess
	call	ReadProcessMemory

	cmp	byte ptr [temp_f1], 2	;!!!!!!!!
	jnz	_wait3

	pop	eax

	push	MEM_DECOMMIT
	push	ebx
	push	eax
	call	VirtualFree

	mov	decr, 0

	;<<<
	push	10
	call	Sleep
	;<<<

	;push	offset strCMOK
	;push	0
	;push	0
	;call	CreateMutex


_event1:

	push	0
	push	1
	push	offset childEnd
	push	offset childEnd
	push	_PI.hProcess
	call	ReadProcessMemory
	cmp	childEnd, 1
	je	_exit_s

	push	50
	call	Sleep
	jmp	_here

_exit_s:
	push	_PI.hThread
	call	CloseHandle
	push	_PI.hProcess
	call	CloseHandle

	push	offset strCMEND
	push	0
	push	0
	call	CreateMutex

	push	100
	call	Sleep

	jmp	_exit

_second_process:
	;push	eax		;mutex handle
	;call	CloseHandle


	push	offset music_start
	call	mfmPlay

	push	0
	push	offset CM5DlgProc
	push	0
	push	IDD_DLG1
	push	400000h
	call	DialogBoxParam

	push	0
	call	mfmPlay

	mov	childEnd, 1
_wfe:
	push	offset strCMEND
	push	0
	push	0
	call	OpenMutex
	call	GetLastError
	;cmp	eax, ERROR_INVALID_NAME		;Win9x
	cmp	eax, ERROR_FILE_NOT_FOUND	;WinNT
	jz	_wfe

_exit:
	push	0
	call	ExitProcess
end start
