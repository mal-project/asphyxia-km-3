;-----------------------------------------------------------------------
; Authentication module.
;      Hash KEY_FILE_SIZE-_AUTH_HASH_SIZE bytes of keyfile and compares
; result (hash_y) with stored hash in keyfile (hash_x) if match then
; keyfile has been authenticated correctly.
;-----------------------------------------------------------------------
    authenticate_keyfile        proc    hfile:dword
        local   _return :dword
        local   ths     :sTHS
        pushad
        mov     _return, 0

        invoke  THS_INIT, addr ths, _AUTH_HASH_SIZE/4, 2, NULL
        invoke  THS_HASH, addr ths, hfile, sKEY_FILE_SIZE-4-_AUTH_HASH_SIZE, eax

        mov     edi, eax

        mov     eax, hfile
        lea     esi, (sKEY_FILE ptr [eax]).Authentication

        mov     ecx, _AUTH_HASH_SIZE/4
        repe    cmpsd
        sete    byte ptr [_return]

        invoke  THS_CLEAR, addr ths
        popad
        
        mov     eax, _return
        ret
    authenticate_keyfile        endp
;-----------------------------------------------------------------------
