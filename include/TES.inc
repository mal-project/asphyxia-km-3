;-----------------------------------------------------------------------
; TES (Tiny Encryption Shit)
; A crappy encryption scheme from Asphyxia's motherfucker
; version 0.4.004
; 4:51 PM 5/16/2009
;-----------------------------------------------------------------------
sTES    struct
    hSBOX    dword   ?
    hPBOX    dword   ?
    hCIPHER  dword   ?
    hPLAIN   dword   ?
sTES    ends

;-----------------------------------------------------------------------

; Set key
TES_SETKEY  proto   :dword, :dword, :dword  ; lpsTES, lptKey, ddLength
											; return in eax addr of key buffer
; Update S_BOX
TES_UPDATE	proto   :dword                  ; lpsTES
											; return pointer to S_BOX if everything ok

; Encrypt lptData. ddDataBytes is data length in bytes.
TES_ENCRYPT proto   :dword, :dword, :dword, :dword, :dword; lpsTES, lptData, uLength, uRounds, lptOutput
											; return in eax pointer to encrypted data (if lptOutput is null then uses VirtualAlloc), -1 if something wrong
											; return in edx length in dwords of encrypted data

; Decrypt lptData. ddDataBytes is data length in bytes.
TES_DECRYPT proto   :dword, :dword, :dword, :dword, :dword; lpsTES, lptData, uLength, uRounds, lptOutput
											; return in eax pointer to decrypted data (if lptOutput is null then uses VirtualAlloc); -1 if something wrong
											; return in edx length in dwords of encrypted data

; Free memory
TES_CLEAR	proto   :sTES                   ; sTES
											; nothing
;-----------------------------------------------------------------------
