SCROLLSTRUCT struc
	;public:
	ddWidth dd ?
	ddROP dd ?
	X dd ?
	Y dd ?
	hBkgDC dd ?
	lpstrText dd ?
	hFont dd ?
	ddTxtColor dd ?
	ddBkgColor dd ?
	;private:
        hTxtBmp dd ?
        hTmpBmp dd ?
        hBakTmpBmp dd ?
        hInDC dd ?
        ddHeight dd ?
        ddPos dd ?
        ddTxtWidth dd ?
SCROLLSTRUCT ends

scrollCreate	PROTO :DWORD
scrollPaint	PROTO :DWORD
scrollDestroy	PROTO :DWORD
