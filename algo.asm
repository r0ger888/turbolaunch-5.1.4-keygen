GenKey  PROTO	:DWORD

.data 
Charset db "GF2DSA38HJKL7M4NZXCV5BY9UPT6R1EWQ40I1CP7Z7GOEPQLZ",0
NoName  db "Insert ur name.",0
Toolong	db "Too long!",0

.data? 
NameBuffer   db 512 dup(?)
RndSeed 	 dd ?
hLen       	 db 512 dup(?)
SrlBuffer    db 512 dup(?)
Srlcounter   dd ?

.code
GenKey proc hWin:DWORD

		invoke GetDlgItemText,hWin,IDC_NAME,offset NameBuffer,sizeof NameBuffer
		.if eax == 0
			invoke SetDlgItemText,hWin,IDC_SERIAL,addr NoName
			invoke GetDlgItem,hWin,IDB_COPY
			invoke EnableWindow,eax,FALSE
			ret
		.elseif eax == 31
			invoke SetDlgItemText,hWin,IDC_SERIAL,addr Toolong
			invoke GetDlgItem,hWin,IDB_COPY
			invoke EnableWindow,eax,FALSE
			ret
		.endif
		
		mov Srlcounter, 0 ; initialize serial counter with 0
		
		mov ebx, eax
		lea ecx, NameBuffer 
		xor edx, edx
; all u can see below is only ripped code from TL's algo.
part1:
		xor eax, eax
		mov al, [ecx]
		shl eax, 8
		xor edx, eax
		mov eax, 8

part2:
		test dh, 80h
		jz part3
		add edx, edx
		xor edx, 1021h
		jmp part4

part3:
		add edx, edx

part4:
		dec eax
		jnz part2
		inc ecx
		dec ebx
		jnz part1
		mov eax, edx
		and eax, 0FFFFh
		lea edx, RndSeed
		mov [edx], eax
		mov edi, 1

part5:
		lea eax, NameBuffer
		lea eax, [eax]
		invoke lstrlen,eax ; get the length of the name buffer
		push eax
		mov eax, edi
		dec eax
		pop edx
		mov ecx, edx
		cdq
		idiv ecx
		lea eax, NameBuffer
		mov al, [edx+eax]
		mov hLen, al
		xor ebx, ebx
		mov esi, 13h
		sub esi, edi
		test esi, esi
		xor ebx, ebx
		mov esi, 13h
		sub esi, edi
		test esi, esi
		jle part7

part6:
		mov eax, 21h
		call Randproc
		mov ebx, eax
		inc ebx
		mov al, hLen
		xor al, 0FFh
		and eax, 0FFh
		add ebx, eax
		dec esi
		jnz part6

part7:
		cmp ebx, 21h
		jle part9

part8:
		sub ebx, 21h
		cmp ebx, 21h
		jg part8

part9: 			
		lea edx, Charset ; the whole charset is written and initiated to the EDX register.
		mov dl, [ebx+edx-1]
		mov eax, Srlcounter
		mov SrlBuffer[eax], dl
		mov eax, edi
		mov ecx, 6
		cdq
		idiv ecx
		test edx, edx
		jnz part0Ah
		cmp edi, 12h
		jge part0Ah
		inc Srlcounter
		mov eax, Srlcounter
		mov SrlBuffer[eax], 2Dh ; insert dashes after 6 chars each

part0Ah:
		inc edi
		inc Srlcounter
		cmp edi, 13h
		jnz part5
		invoke SetDlgItemText,hWin,IDC_SERIAL,offset SrlBuffer
		call Clean
		invoke GetDlgItem,hWin,IDB_COPY
		invoke EnableWindow,eax,TRUE
		ret

GenKey endp

Randproc proc
		push ebx
		xor ebx, ebx
		imul edx, RndSeed, 8088405h
		inc edx
		mov RndSeed, edx
		mul edx
		mov eax, edx
		pop ebx
		ret
Randproc endp

Clean proc
  	
	invoke RtlZeroMemory,offset SrlBuffer,sizeof SrlBuffer
	invoke RtlZeroMemory,offset RndSeed,sizeof RndSeed
	invoke RtlZeroMemory,offset hLen,sizeof hLen
	Ret
Clean endp