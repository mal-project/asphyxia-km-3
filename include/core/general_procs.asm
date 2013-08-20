;-----------------------------------------------------------------------
    open_keyfile     proc    lpfileio:dword, lptes:dword
        local   _return:dword
        pushad

        invoke  _createfile, addr szKeyfileName, _FILEIO_READWRITE, OPEN_EXISTING, FILE_MAP_READ, NULL, lpfileio
        
        .if     eax == NULL
            mov     eax, lpfileio
            mov     eax, (sfileio ptr [eax]).hview
            invoke  encrypt_keyfile, eax, lptes
            mov     _return, eax
            invoke  _closefile, lpfileio
        
        .else

            mov     _return, NULL

        .endif
        
        popad
        
        mov     eax, _return
        ret
    open_keyfile endp

;-----------------------------------------------------------------------
    validate_keyfile     proc    hfile:dword
        local   _return :dword
        pushad

        invoke  validate_keyfile_format, hfile
        .if     eax == TRUE

            invoke  authenticate_keyfile, hfile
            mov     _return, eax
            
        .else
        
            mov     _return, NULL

        .endif
                
        
        popad
        
        mov     eax, _return
        ret
    validate_keyfile     endp

;-----------------------------------------------------------------------
    hash_string      proc    lpszName:dword, uSize:dword
        local   _return :dword
        local   ths     :sTHS
        pushad
        
        invoke  THS_INIT, addr ths, 1, 1, 0
        invoke  THS_HASH, addr ths, lpszName, uSize, eax
        m2m     _return, [eax]
        invoke  THS_CLEAR, addr ths
        
        popad
        
        mov     eax, _return
        ret
    hash_string      endp

;-----------------------------------------------------------------------
    registration_info      proc hWnd:dword, wParam:dword
        local   _fileio:sfileio
        pushad
        mov     ecx, wParam
        lea     eax, (sKEY_FILE ptr [ecx]).szOrg
        lea     edx, (sKEY_FILE ptr [ecx]).szName
        invoke  szMultiCat, 4, addr hBuffer, addr szRegistered, edx, addr szSlashes, eax
        
        invoke  SendDlgItemMessage, hWnd, IDE_REG, WM_SETTEXT, 0, eax

        invoke  _createfile, addr szSrcFileName, _FILEIO_READWRITE, OPEN_EXISTING, FILE_MAP_WRITE, NULL, addr _fileio
        .if     eax != NULL
            invoke  decrypt_attachment, wParam

        .else
            invoke  _closefile, addr _fileio

        .endif       
        
        invoke  TES_CLEAR, tes
        popad
        ret
    registration_info       endp

;-----------------------------------------------------------------------
    validate_data    proc   lpszStr:dword
        local   _return:dword
        pushad

        mov     esi, lpszStr
        .while  byte ptr [esi] != 0
            .if byte ptr [esi] <= 'z' && byte ptr [esi] >= 'A'
                
                .break  .if byte ptr [esi] > 'Z' && byte ptr [esi] < 'a'

            .else
                .break

            .endif
            
            inc     esi
        
        .endw

        .if     byte ptr [esi] == 0
            sub     esi, lpszStr
            mov     _return, esi
        
        .else
            mov     _return, 0

        .endif

        popad
        mov     eax, _return
        ret
    validate_data    endp

;-----------------------------------------------------------------------
