;-----------------------------------------------------------------------
; Encrypt File module.
;        Encrypts key file (mapped) with volume serial of "c:\" drive
; as key (dword).
;-----------------------------------------------------------------------
    encrypt_keyfile     proc    hfile:dword, lptes:dword
        local   encrypted, lpRoot, hVolSerial:dword
        
        pushad
        mov     lpRoot, 005C3A63h
        xor     edx, edx
        invoke  GetVolumeInformation, addr lpRoot, edx, edx, addr hVolSerial, edx, edx, edx, edx
        
        invoke  TES_SETKEY, lptes, addr hVolSerial, 1
        invoke  TES_UPDATE, lptes
        invoke  TES_ENCRYPT, lptes, hfile, sKEY_FILE_SIZE, 1, NULL

        push    eax
        pop     encrypted

        popad
        mov     eax, encrypted
        ret
    encrypt_keyfile     endp

;-----------------------------------------------------------------------
