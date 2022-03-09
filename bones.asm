.686
.model	flat, stdcall
option	casemap :none

USE_BRUSH = 1

include	resID.inc
include algo.asm
include lineanim.asm
include aboutbox.asm

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	InitCommonControls
	invoke LoadBitmap,hInstance,400
	mov hIMG,eax
	invoke CreatePatternBrush,eax
	mov hBrush,eax
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
	invoke	ExitProcess, eax

DlgProc proc hDlg:HWND,uMessg:UINT,wParams:WPARAM,lParam:LPARAM
LOCAL X:DWORD
LOCAL Y:DWORD
LOCAL ps:PAINTSTRUCT

	.if [uMessg] == WM_INITDIALOG
 
		mov eax, 349
		mov nHeight, eax
		mov eax, 262
		mov nWidth, eax                
		invoke GetSystemMetrics,0                
		sub eax, nHeight
		shr eax, 1
		mov [X], eax
		invoke GetSystemMetrics,1               
		sub eax, nWidth
		shr eax, 1
		mov [Y], eax
		invoke SetWindowPos,hDlg,0,X,Y,nHeight,nWidth,40h
            	
		invoke	LoadIcon,hInstance,200
		invoke	SendMessage, hDlg, WM_SETICON, 1, eax
		invoke CreateThread,0,0,offset LineAnim,hDlg,0,offset hAnim
		mov xThread, eax
		invoke  SetWindowText,hDlg,addr WindowTitle
		;invoke 	MakeDialogTransparent,hDlg,TRANSPARENT_VALUE
		invoke  SetDlgItemText,hDlg,IDC_NAME,addr DefaultName
		invoke 	SendDlgItemMessage, hDlg, IDC_NAME, EM_SETLIMITTEXT, 31, 0
		invoke CreateFontIndirect,addr TxtFont
		mov hFont,eax
		invoke GetDlgItem,hDlg,IDC_NAME
		mov hMail,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		invoke GetDlgItem,hDlg,IDC_SERIAL
		mov hSerial,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		
		invoke ImageButton,hDlg,18,216,500,502,501,IDB_COPY
		mov hCopy,eax
		invoke ImageButton,hDlg,130,217,600,602,601,IDB_ABOUT
		mov hAbout,eax
		invoke ImageButton,hDlg,267,218,700,702,701,IDB_EXIT
		mov hExit,eax
		
		invoke GenKey,hDlg
		
		invoke uFMOD_PlaySong, addr xm, xm_length, XM_MEMORY
		
	.elseif [uMessg] == WM_LBUTTONDOWN

		invoke SendMessage, hDlg, WM_NCLBUTTONDOWN, HTCAPTION, 0

	.elseif [uMessg] == WM_CTLCOLORDLG

		return hBrush

	.elseif [uMessg] == WM_PAINT
                
		invoke BeginPaint,hDlg,addr ps
		mov edi,eax
		lea ebx,r3kt
		assume ebx:ptr RECT
                
		invoke GetClientRect,hDlg,ebx
		invoke CreateSolidBrush,0
		invoke FrameRect,edi,ebx,eax
		invoke EndPaint,hDlg,addr ps                   
     
    .elseif [uMessg] == WM_CTLCOLOREDIT
    
		invoke SetBkMode,wParams,TRANSPARENT
		invoke SetTextColor,wParams,White
		invoke GetWindowRect,hDlg,addr WndRect
		invoke GetDlgItem,hDlg,IDC_NAME
		invoke GetWindowRect,eax,addr NameRect
		mov edi,WndRect.left
		mov esi,NameRect.left
		sub edi,esi
		mov ebx,WndRect.top
		mov edx,NameRect.top
		sub ebx,edx
		invoke SetBrushOrgEx,wParams,edi,ebx,0
		mov eax,hBrush
		ret        
	
	.elseif [uMessg] == WM_CTLCOLORSTATIC
	
		invoke SetBkMode,wParams,TRANSPARENT
		invoke SetTextColor,wParams,White
		invoke GetWindowRect,hDlg,addr XndRect
		invoke GetDlgItem,hDlg,IDC_SERIAL
		invoke GetWindowRect,eax,addr SerialRect
		mov edi,XndRect.left
		mov esi,SerialRect.left
		sub edi,esi
		mov ebx,XndRect.top
		mov edx,SerialRect.top
		sub ebx,edx
		invoke SetBrushOrgEx,wParams,edi,ebx,0
		mov eax,hBrush
		ret

	.elseif [uMessg] == WM_COMMAND
        
		mov eax,wParams
		mov edx,eax
		shr edx,16
		and eax,0FFFFh      
		.if edx == EN_CHANGE
			.if eax == IDC_NAME
				invoke GenKey,hDlg
			.endif
		.endif  
		.if	eax==IDB_COPY
			invoke SendDlgItemMessage,hDlg,IDC_SERIAL,EM_SETSEL,0,-1
			invoke SendDlgItemMessage,hDlg,IDC_SERIAL,WM_COPY,0,0
			invoke MessageBox,hDlg,addr Msg1,addr Cpt1,MB_OK
		.elseif eax == IDB_ABOUT
			invoke DialogBoxParam,0,IDD_ABOUT,hDlg,offset AboutProc,0
		.elseif eax == IDB_EXIT
			invoke SendMessage,hDlg,WM_CLOSE,0,0
		.endif 
   
             
	.elseif [uMessg] == WM_CLOSE	
	
		invoke uFMOD_PlaySong,0,0,0
		invoke TerminateThread,xThread,0
		invoke EndDialog,hDlg,0    
		 
	.endif
         xor eax,eax
         ret
DlgProc endp

end start