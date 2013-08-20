;-----------------------------------------------------------------------
; Decrypt Attachement module.
;        Decrypts attached (resource) tar.bz2 package with this source.
; Uses as decryption key keyfile.Authentication (5 dwords). Writes decrypted
; package to szSrcFileName file name.
;-----------------------------------------------------------------------
    decrypt_attachment  proc    hfile:dword
        local   _res, _size:dword
        local   _tes:sTES
        pushad

        mov     ebx, hfile
        lea     eax, (sKEY_FILE ptr [ebx]).Authentication
        
        invoke  TES_SETKEY, addr _tes, eax, _AUTH_HASH_SIZE
        invoke  TES_UPDATE, addr _tes
        
        invoke  FindResource, hInst, IDR_SRC, RT_RCDATA
        mov     _res, eax
        invoke  SizeofResource, hInst, eax
        mov     _size, eax
        invoke  LoadResource, hInst, _res
        invoke  LockResource, eax

        invoke  TES_ENCRYPT, addr _tes, eax, _size, 1, 0

        .if dword ptr [eax] == _BZ_SIGNATURE

            invoke  _writefile, addr szSrcFileName, eax, _size, CREATE_NEW, NULL

        .endif
        
        invoke  TES_CLEAR, _tes
        invoke  _closefile, addr fileio

        popad
        ret
    decrypt_attachment  endp

;-----------------------------------------------------------------------
