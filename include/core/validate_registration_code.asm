;-----------------------------------------------------------------------
; Discrete Logarithm module.
;      Take name and organization hashes (dword size) and 'xor' both. If
; result of this operation is zero (both hash are equal) then procedure
; return -1. Otherwise makes this result a big number (y) and creates
; other tree big numbers (g, x, p).
;   g = DBADDEFC01EE1FBEBA
;   x = keyfile.registration
;   p = 98DB4C75E91AC3 (prime)
;
; And computes
;                        x = g^x (mod p)
;
; if x == y registration is correct.
;
; This is the discrete lograrithm problem. If u dont know how to solve
; i recommend u to read "Hand Book Of Applied Cryptography"
;
; A few notes for now:
; stolen from [http://modular.fas.harvard.edu/edu/Fall2001/124/lectures/lecture8/html/node5.html]
; Let a,b,n be positive real numbers. Recall that 
;               LOGb(a) = n if and only if a = b^n
;
; Thus the LOGb function solves the following problem: Given a base b and
; a power a of b, find an exponent n such that 
;                       a = b^n
; That is, given b and b^n, find n. 
;
; Example 4.1   a=19683, b=3. A calculator quickly gives that 
;                 n = log(19683)/log(3) = 9
;
; The discrete log problem is the analogue of this problem modulo P: 
;
; Discrete Log Problem: Given b(mod p) and b^n(mod p), find n. Put another
; way, compute LOGb(a), when a,b E Z/pZ. 
;
; As far as we know, this problem is VERY HARD to solve quickly. Nobody
; has admitted publicly to having proved that the discrete log can't be
; solved quickly, but many very smart people have tried hard and not
; succeeded. It's easy to write a slow program to solve the discrete log
; problem. (There are better methods but we won't discuss them in this class.)
; [...]
;-----------------------------------------------------------------------
; return FALSE if auth key is wrong
; return TRUE if its correct
   validate_registration_code    proc    _hFile:dword, _name_hash:dword, _org_hash:dword
        local   _return, hbig_registration, hbig_user_hash:dword
        pushad
        
        mov     _return, FALSE
        
        mov     eax, dword ptr [_name_hash]
        xor     eax, dword ptr [_org_hash]
        .if     !ZERO?
            mov     dword ptr [_name_hash], eax
        
            invoke  _BigCreate, 0
            mov     hbig_user_hash, eax
            invoke  _BigIn32, _name_hash, eax

            invoke  _BigCreate, 0
            mov     hbig_registration, eax

            mov     edi, _hFile
            lea     edi, (sKEY_FILE ptr [edi]).Registration

            invoke  _BigPowMod, addr big_generator, edi, addr big_prime, hbig_registration
            
            invoke  _BigCompare, hbig_registration, hbig_user_hash
            .if     ZERO?
                mov     _return, TRUE
            .endif
            
            invoke  _BigDestroy, hbig_user_hash
            invoke  _BigDestroy, hbig_registration
            
        .endif
        
        popad
        mov     eax, _return
        ret
   validate_registration_code    endp

;-----------------------------------------------------------------------
