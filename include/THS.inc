;-----------------------------------------------------------------------
; THS (Tiny Hash Shit)
; A crappy hash scheme from Asphyxia motherfucker
; 0.2.026
; 6:25 PM 5/16/2009
;-----------------------------------------------------------------------
sTHS    struct
    hVECTORS    dword   ?
    hROUNDS     dword   ?
    hSIZE       dword   ?
sTHS    ends

;-----------------------------------------------------------------------

; initializes buffers, and set hash propieties
THS_INIT	proto	:dword, :dword, :dword, :dword
                                        ; lpsTHS     : pointer to sTHS structure
										; ddHashSize : hash size in dwords
										; ddRounds   : rounds to do
										; lptOutput	 : output buffer for hash (if null then VirtualAlloc is used)
											
										; return pointer to buffer (initialized)
; hash given data
THS_HASH	proto	:dword, :dword, :dword, :dword
                                        ; lpsTHS        : pointer to sTHS structure
										; lptData		: data to hash
										; ddLength      : length of data to hash in bytes
										; lptOutput 	: output buffer (use THS_INIT to get an initialized buffer)
										
										; return pointer to buffer (the hash); -1 if something bad
; clear THS data
THS_CLEAR   proto   :dword
                                        ; lpsTHS

;-----------------------------------------------------------------------
