Just apply the fake code into the reg dialog, run it through OllyDBG. The main keygen algorithm starts from around 0053F420 and continues from 0054069D, in which between these procedures there is also some kindof a random seed procedure (**Randproc**) from which the serial counter is initiating with it:

```
004034E8  /$  53            PUSH EBX
004034E9  |.  31DB          XOR EBX,EBX
004034EB  |.  6993 08205400>IMUL EDX,DWORD PTR DS:[EBX+0x542008],0x8088405
004034F5  |.  42            INC EDX                                                                     ;  TurboLau.<ModuleEntryPoint>
004034F6  |.  8993 08205400 MOV DWORD PTR DS:[EBX+0x542008],EDX                                         ;  TurboLau.<ModuleEntryPoint>
004034FC  |.  F7E2          MUL EDX                                                                     ;  TurboLau.<ModuleEntryPoint>
004034FE  |.  89D0          MOV EAX,EDX                                                                 ;  TurboLau.<ModuleEntryPoint>
00403500  |.  5B            POP EBX                                                                     ;  kernel32.7749343D
00403501  \.  C3            RETN
```

In the main algo , there is also a procedure which detects the whole blacklist starting from 00540804 and ignores the names when one of the names is being entered (it usually doesn't take the serial as a valid one, which yes, it's a badboy message.) :

```
0054069D  |.  55            PUSH EBP
0054069E  |.  68 42085400   PUSH TurboLau.00540842
005406A3  |.  64:FF30       PUSH DWORD PTR FS:[EAX]
005406A6  |.  64:8920       MOV DWORD PTR FS:[EAX],ESP
005406A9  |.  8B45 FC       MOV EAX,[LOCAL.1]
005406AC  |.  E8 3348ECFF   CALL TurboLau.00404EE4
005406B1  |.  85C0          TEST EAX,EAX                                                                ;  kernel32.BaseThreadInitThunk
005406B3  |.  74 0C         JE SHORT TurboLau.005406C1
005406B5  |.  8B45 F8       MOV EAX,[LOCAL.2]                                                           ;  kernel32.7749343D
005406B8  |.  E8 2748ECFF   CALL TurboLau.00404EE4
005406BD  |.  85C0          TEST EAX,EAX                                                                ;  kernel32.BaseThreadInitThunk
005406BF  |.  75 07         JNZ SHORT TurboLau.005406C8
005406C1  |>  33DB          XOR EBX,EBX
005406C3  |.  E9 52010000   JMP TurboLau.0054081A
005406C8  |>  8D45 B2       LEA EAX,DWORD PTR SS:[EBP-0x4E]
005406CB  |.  8B55 FC       MOV EDX,[LOCAL.1]
005406CE  |.  E8 E15BF1FF   CALL TurboLau.004562B4
005406D3  |.  6A 00         PUSH 0x0
005406D5  |.  8B45 FC       MOV EAX,[LOCAL.1]
005406D8  |.  E8 0748ECFF   CALL TurboLau.00404EE4
005406DD  |.  8BC8          MOV ECX,EAX                                                                 ; |kernel32.BaseThreadInitThunk
005406DF  |.  8D45 B2       LEA EAX,DWORD PTR SS:[EBP-0x4E]                                             ; |
005406E2  |.  BA 40000000   MOV EDX,0x40                                                                ; |
005406E7  |.  E8 34EDFFFF   CALL TurboLau.0053F420                                                      ; \TurboLau.0053F420
005406EC  |.  8B15 507B5400 MOV EDX,DWORD PTR DS:[0x547B50]                                             ;  TurboLau.00542008
005406F2  |.  8902          MOV DWORD PTR DS:[EDX],EAX                                                  ;  kernel32.BaseThreadInitThunk
005406F4  |.  8D45 F4       LEA EAX,[LOCAL.3]
005406F7  |.  E8 2845ECFF   CALL TurboLau.00404C24
005406FC  |.  BF 01000000   MOV EDI,0x1
00540701  |>  8B45 FC       /MOV EAX,[LOCAL.1]
00540704  |.  E8 DB47ECFF   |CALL TurboLau.00404EE4
00540709  |.  50            |PUSH EAX                                                                   ;  kernel32.BaseThreadInitThunk
0054070A  |.  8BC7          |MOV EAX,EDI
0054070C  |.  48            |DEC EAX                                                                    ;  kernel32.BaseThreadInitThunk
0054070D  |.  5A            |POP EDX                                                                    ;  kernel32.7749343D
0054070E  |.  8BCA          |MOV ECX,EDX                                                                ;  TurboLau.<ModuleEntryPoint>
00540710  |.  99            |CDQ
00540711  |.  F7F9          |IDIV ECX
00540713  |.  8B45 FC       |MOV EAX,[LOCAL.1]
00540716  |.  8A0410        |MOV AL,BYTE PTR DS:[EAX+EDX]
00540719  |.  8845 F3       |MOV BYTE PTR SS:[EBP-0xD],AL
0054071C  |.  33DB          |XOR EBX,EBX
0054071E  |.  BE 13000000   |MOV ESI,0x13
00540723  |.  2BF7          |SUB ESI,EDI
00540725  |.  85F6          |TEST ESI,ESI
00540727  |.  7E 1C         |JLE SHORT TurboLau.00540745
00540729  |>  B8 21000000   |/MOV EAX,0x21
0054072E  |.  E8 B52DECFF   ||CALL TurboLau.004034E8
00540733  |.  8BD8          ||MOV EBX,EAX                                                               ;  kernel32.BaseThreadInitThunk
00540735  |.  43            ||INC EBX
00540736  |.  8A45 F3       ||MOV AL,BYTE PTR SS:[EBP-0xD]
00540739  |.  34 FF         ||XOR AL,0xFF
0054073B  |.  25 FF000000   ||AND EAX,0xFF
00540740  |.  03D8          ||ADD EBX,EAX                                                               ;  kernel32.BaseThreadInitThunk
00540742  |.  4E            ||DEC ESI
00540743  |.^ 75 E4         |\JNZ SHORT TurboLau.00540729
00540745  |>  83FB 21       |CMP EBX,0x21
00540748  |.  7E 08         |JLE SHORT TurboLau.00540752
0054074A  |>  83EB 21       |/SUB EBX,0x21
0054074D  |.  83FB 21       ||CMP EBX,0x21
00540750  |.^ 7F F8         |\JG SHORT TurboLau.0054074A
00540752  |>  8D45 AC       |LEA EAX,[LOCAL.21]
00540755  |.  BA 5C085400   |MOV EDX,TurboLau.0054085C                                                  ;  ASCII "GF2DSA38HJKL7M4NZXCV5BY9UPT6R1EWQ40I1CP7Z7GOEPQLZ"
0054075A  |.  8A541A FF     |MOV DL,BYTE PTR DS:[EDX+EBX-0x1]
0054075E  |.  E8 A946ECFF   |CALL TurboLau.00404E0C
00540763  |.  8B55 AC       |MOV EDX,[LOCAL.21]
00540766  |.  8D45 F4       |LEA EAX,[LOCAL.3]
00540769  |.  E8 7E47ECFF   |CALL TurboLau.00404EEC
0054076E  |.  8BC7          |MOV EAX,EDI
00540770  |.  B9 06000000   |MOV ECX,0x6
00540775  |.  99            |CDQ
00540776  |.  F7F9          |IDIV ECX
00540778  |.  85D2          |TEST EDX,EDX                                                               ;  TurboLau.<ModuleEntryPoint>
0054077A  |.  75 12         |JNZ SHORT TurboLau.0054078E
0054077C  |.  83FF 12       |CMP EDI,0x12
0054077F  |.  7D 0D         |JGE SHORT TurboLau.0054078E
00540781  |.  8D45 F4       |LEA EAX,[LOCAL.3]
00540784  |.  BA 98085400   |MOV EDX,TurboLau.00540898
00540789  |.  E8 5E47ECFF   |CALL TurboLau.00404EEC
0054078E  |>  47            |INC EDI
0054078F  |.  83FF 13       |CMP EDI,0x13
00540792  |.^ 0F85 69FFFFFF \JNZ TurboLau.00540701
00540798  |.  8B45 F4       MOV EAX,[LOCAL.3]
0054079B  |.  8B55 F8       MOV EDX,[LOCAL.2]                                                           ;  kernel32.7749343D
0054079E  |.  E8 8D48ECFF   CALL TurboLau.00405030
005407A3  |.  0F94C3        SETE BL
005407A6  |.  84DB          TEST BL,BL
005407A8  |.  75 50         JNZ SHORT TurboLau.005407FA
005407AA  |.  8D45 A4       LEA EAX,[LOCAL.23]
005407AD  |.  8D55 B2       LEA EDX,DWORD PTR SS:[EBP-0x4E]
005407B0  |.  B9 41000000   MOV ECX,0x41
005407B5  |.  E8 DA46ECFF   CALL TurboLau.00404E94
005407BA  |.  8B45 A4       MOV EAX,[LOCAL.23]
005407BD  |.  8D55 A8       LEA EDX,[LOCAL.22]
005407C0  |.  E8 53FAFFFF   CALL TurboLau.00540218
005407C5  |.  8B45 A8       MOV EAX,[LOCAL.22]
005407C8  |.  8B55 FC       MOV EDX,[LOCAL.1]
005407CB  |.  E8 6048ECFF   CALL TurboLau.00405030
005407D0  |.  74 28         JE SHORT TurboLau.005407FA
005407D2  |.  8D45 9C       LEA EAX,[LOCAL.25]
005407D5  |.  8D55 B2       LEA EDX,DWORD PTR SS:[EBP-0x4E]
005407D8  |.  B9 41000000   MOV ECX,0x41
005407DD  |.  E8 B246ECFF   CALL TurboLau.00404E94
005407E2  |.  8B45 9C       MOV EAX,[LOCAL.25]
005407E5  |.  8D55 A0       LEA EDX,[LOCAL.24]
005407E8  |.  E8 2BFAFFFF   CALL TurboLau.00540218
005407ED  |.  8B45 A0       MOV EAX,[LOCAL.24]
005407F0  |.  8B55 F8       MOV EDX,[LOCAL.2]                                                           ;  kernel32.7749343D
005407F3  |.  E8 70FEFFFF   CALL TurboLau.00540668
005407F8  |.  8BD8          MOV EBX,EAX                                                                 ;  kernel32.BaseThreadInitThunk
005407FA  |>  BF 2E000000   MOV EDI,0x2E
005407FF  |.  BE A0725400   MOV ESI,TurboLau.005472A0
00540804  |>  8B45 FC       /MOV EAX,[LOCAL.1]
00540807  |.  8B16          |MOV EDX,DWORD PTR DS:[ESI]
00540809  |.  E8 2248ECFF   |CALL TurboLau.00405030
0054080E  |.  75 04         |JNZ SHORT TurboLau.00540814
00540810  |.  33DB          |XOR EBX,EBX
00540812  |.  EB 06         |JMP SHORT TurboLau.0054081A
00540814  |>  83C6 04       |ADD ESI,0x4
00540817  |.  4F            |DEC EDI
00540818  |.^ 75 EA         \JNZ SHORT TurboLau.00540804
0054081A  |>  33C0          XOR EAX,EAX                                                                 ;  kernel32.BaseThreadInitThunk
0054081C  |.  5A            POP EDX                                                                     ;  kernel32.7749343D
0054081D  |.  59            POP ECX                                                                     ;  kernel32.7749343D
0054081E  |.  59            POP ECX                                                                     ;  kernel32.7749343D
0054081F  |.  64:8910       MOV DWORD PTR FS:[EAX],EDX                                                  ;  TurboLau.<ModuleEntryPoint>
00540822  |.  68 49085400   PUSH TurboLau.00540849
00540827  |>  8D45 9C       LEA EAX,[LOCAL.25]
0054082A  |.  BA 05000000   MOV EDX,0x5
0054082F  |.  E8 1444ECFF   CALL TurboLau.00404C48
00540834  |.  8D45 F4       LEA EAX,[LOCAL.3]
00540837  |.  BA 03000000   MOV EDX,0x3
0054083C  |.  E8 0744ECFF   CALL TurboLau.00404C48
00540841  \.  C3            RETN
```

And this is the first part of the algo :

```
0053F420  /$  55            PUSH EBP
0053F421  |.  8BEC          MOV EBP,ESP
0053F423  |.  53            PUSH EBX
0053F424  |.  56            PUSH ESI
0053F425  |.  8BDA          MOV EBX,EDX                              ;  TurboLau.<ModuleEntryPoint>
0053F427  |.  85DB          TEST EBX,EBX
0053F429  |.  78 0A         JS SHORT TurboLau.0053F435
0053F42B  |.  C1EB 02       SHR EBX,0x2
0053F42E  |>  8B3498        /MOV ESI,DWORD PTR DS:[EAX+EBX*4]
0053F431  |.  4B            |DEC EBX
0053F432  |.  56            |PUSH ESI
0053F433  |.^ 79 F9         \JNS SHORT TurboLau.0053F42E
0053F435  |>  8BC4          MOV EAX,ESP
0053F437  |.  8B55 08       MOV EDX,[ARG.1]
0053F43A  |.  8BD9          MOV EBX,ECX
0053F43C  |.  85DB          TEST EBX,EBX
0053F43E  |.  7E 28         JLE SHORT TurboLau.0053F468
0053F440  |.  8BC8          MOV ECX,EAX                              ;  kernel32.BaseThreadInitThunk
0053F442  |>  33C0          /XOR EAX,EAX                             ;  kernel32.BaseThreadInitThunk
0053F444  |.  8A01          |MOV AL,BYTE PTR DS:[ECX]
0053F446  |.  C1E0 08       |SHL EAX,0x8
0053F449  |.  33D0          |XOR EDX,EAX                             ;  kernel32.BaseThreadInitThunk
0053F44B  |.  B8 08000000   |MOV EAX,0x8
0053F450  |>  F6C6 80       |/TEST DH,0x80
0053F453  |.  74 0A         ||JE SHORT TurboLau.0053F45F
0053F455  |.  03D2          ||ADD EDX,EDX                            ;  TurboLau.<ModuleEntryPoint>
0053F457  |.  81F2 21100000 ||XOR EDX,0x1021
0053F45D  |.  EB 02         ||JMP SHORT TurboLau.0053F461
0053F45F  |>  03D2          ||ADD EDX,EDX                            ;  TurboLau.<ModuleEntryPoint>
0053F461  |>  48            ||DEC EAX                                ;  kernel32.BaseThreadInitThunk
0053F462  |.^ 75 EC         |\JNZ SHORT TurboLau.0053F450
0053F464  |.  41            |INC ECX
0053F465  |.  4B            |DEC EBX
0053F466  |.^ 75 DA         \JNZ SHORT TurboLau.0053F442
0053F468  |>  8BC2          MOV EAX,EDX                              ;  TurboLau.<ModuleEntryPoint>
0053F46A  |.  25 FFFF0000   AND EAX,0xFFFF
0053F46F  |.  8B75 F8       MOV ESI,[LOCAL.2]                        ;  kernel32.7749343D
0053F472  |.  8B5D FC       MOV EBX,[LOCAL.1]
0053F475  |.  8BE5          MOV ESP,EBP
0053F477  |.  5D            POP EBP                                  ;  kernel32.7749343D
0053F478  \.  C2 0400       RETN 0x4
```

Here is a list of blacklisted names which i've ripped from :
```
zircon / pc97
freeware
registered user
Registered
kOUGER! [CB4]
Cosmo Cramer 1997
Cosmo Cramer MJ13
MJ13 Forever
cH/Phrozen Crew
Everybody
iCEMAN [uCF]
pank
Henry Pan
iTR [CORE]
mpbaer
CORE/JES
Chen Borchang
n03l
ODIN 97
lgb/cORE'97
MCC
blastsoft
CORE/DrRhui
Vizion/CORE
TEAM ViRiLiTY
Nambulu
NuZPc97
Weazel
Phrozen Crew
TEAM VIRILITY
x3u
Reg Name
FiGHTiNG FOR FUN
RaSCaL [TMG]
Nitros^21
TEAM TSRH
ttdown.com
Nitrogen / TSRh TeaM
Free Program
REVENGE Crew
Vladimir Kasho
Alexej Melnikov
Seth W. Hinshaw
```
