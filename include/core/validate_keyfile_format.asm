;-----------------------------------------------------------------------
; Validate Format module.
;         Determines if key file has a correct format; also check that
; name and organization sizes are below _MAX_LENGTH and that name and organization 
; have correct charsets (a..z, A..Z)
;-----------------------------------------------------------------------
    validate_keyfile_format     proc    lpFile:dword
        local   _return :dword
        pushad
        mov     eax, lpFile
        
        .if     dword ptr (sKEY_FILE ptr [eax]).Signature != KEY_FILE_SIGNATURE
            mov     _return, FALSE
        .else
            mov     edx, eax
            lea     eax, (sKEY_FILE ptr [edx]).szName
            invoke  validate_data, eax
            .if     eax > 0 && eax <= _MAX_NAME_LENGTH && al == byte ptr (sKEY_FILE ptr [edx]).uNameLength
                
                lea     eax, (sKEY_FILE ptr [edx]).szOrg
                invoke  validate_data, eax
                .if     eax > 0 && eax <= _MAX_ORG_LENGTH && al == byte ptr (sKEY_FILE ptr [edx]).uOrgLength

                    mov     _return, TRUE
                    
                .else
                    mov     _return, FALSE

                .endif
                
            .else
                mov     _return, FALSE

            .endif
        .endif

        popad
        mov     eax, _return
        ret
    validate_keyfile_format     endp

;-----------------------------------------------------------------------
