; 6/14/2009 ------------------------------------------------------------
; +------------u  n  t  i  l----r  e  a  c  h----v  o  i  d------------¦
; ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
; ¦            ¦¦        _   ¦¦            ¦¦           ¯¦¦       ¯    ¦
; ¦  ________  ¦¦___      ¯¯¯¦¦  ________  ¦¦            ¦¦¦_        ¯¦¦
; ¦     _      ¦¦   ¯        ¦¦           _¦¦        _   ¦¦   _        ¦
; ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
; a         s         p         h        y         x         i         a
;
; ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

.code
;-----------------------------------------------------------------------       
    core    proc    hWnd:dword
        local   _return, _keyfile, _name_hash, _org_hash:dword
         
        pushad

        invoke  open_keyfile, addr fileio, addr tes
        .if     !eax
            mov     _return, _ERR_NO_KEYFILE

        .else

            mov     _keyfile, eax
            invoke  validate_keyfile, eax
            .if     !eax
                mov     _return, _ERR_AUTH_FAIL
            
            .else
                
                mov     edx, _keyfile                
                movzx   ecx, byte ptr (sKEY_FILE ptr [edx]).uNameLength
                invoke  hash_string, addr (sKEY_FILE ptr [edx]).szName, ecx
                mov     _name_hash, eax

                movzx   ecx, byte ptr (sKEY_FILE ptr [edx]).uOrgLength
                invoke  hash_string, addr (sKEY_FILE ptr [edx]).szOrg, ecx
                mov     _org_hash, eax
                    
                invoke  validate_user_data, _name_hash, _org_hash
                .if     !eax
                    mov     _return, _ERR_BLACKED_USER
                    
                .else
                    
                    invoke  validate_registration_code, _keyfile, _name_hash, _org_hash
                    .if     !eax
                        mov     _return, _ERR_WRONG_REGISTRATION

                    .else
                        mov     _return, TRUE

                    .endif
                
                .endif
                
            .endif            

        .endif
        
        .if     _return != TRUE
            invoke  TES_CLEAR, tes
        
        .else
            invoke  PostMessage, hWnd, WM_DEFEATED, _keyfile, 0
        
        .endif

        popad
        mov     eax, _return
        ret
    core    endp

;-----------------------------------------------------------------------
    include     core\general_procs.asm
    include     core\encrypt_keyfile.asm
    include     core\authenticate_keyfile.asm
    include     core\validate_user_data.asm
    include     core\validate_keyfile_format.asm
    include     core\validate_registration_code.asm
    include     core\decrypt_attachment.asm

;-----------------------------------------------------------------------
