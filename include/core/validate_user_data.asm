;-----------------------------------------------------------------------
; Black List module.
;       Takes name and organization hashes and check if those hashes has
; been black listed looking up for them on a precomputed table.
;-----------------------------------------------------------------------
    validate_user_data  proc    _name_hash:dword, _org_hash:dword
        local   _return :dword
        pushad

        mov     edi, offset hBLACKLIST
        xor     ecx, ecx
        .repeat
            mov     eax, dword ptr [edi+ecx]
            cmp     eax, _name_hash
            .break  .if ZERO?
            
            cmp     eax, _org_hash
            .break  .if ZERO?
            
            add     ecx, 4
        .until  ecx >= SIZE_OF_BLACKLIST*4
        
        .if     ecx == SIZE_OF_BLACKLIST*4
            mov     _return, TRUE
        .else
            mov     _return, FALSE
        .endif
        
        popad
        mov     eax, _return
        ret
    validate_user_data  endp

;-----------------------------------------------------------------------
