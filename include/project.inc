;-----------------------------------------------------------------------
include     includes.inc

;-----------------------------------------------------------------------
MainDlgProc     proto    :HWND, :UINT, :WPARAM, :LPARAM

;-----------------------------------------------------------------------
core                proto   :HWND
encrypt_keyfile     proto   :dword, :dword
decrypt_attachment  proto   :dword
validate_user_data  proto   :dword, :dword
authenticate_keyfile        proto   :dword
validate_keyfile_format     proto   :dword
validate_registration_code  proto   :dword, :dword, :dword

open_keyfile        proto   :dword, :dword
validate_keyfile    proto   :dword
hash_string         proto   :dword, :dword
registration_info   proto   :dword, :dword
validate_data       proto   :dword

;-----------------------------------------------------------------------
CRLF    equ 13, 10
TAB     equ 9

;-----------------------------------------------------------------------
WM_DEFEATED     equ     WM_USER+1337h
_BZ_SIGNATURE   equ     39685A42h
_ERR_NO_KEYFILE equ     100
_ERR_AUTH_FAIL  equ     101
_ERR_BLACKED_USER   equ 102
_ERR_WRONG_REGISTRATION equ 103

;-----------------------------------------------------------------------
_MAX_NAME_LENGTH    equ 0Fh
_MAX_ORG_LENGTH     equ 0Fh
_REG_KEY_SIZE       equ 10h
_AUTH_HASH_SIZE     equ 10h

;-----------------------------------------------------------------------
sKEY_FILE    struct

    Signature dword ?
    
    uNameLength byte  ?                               ; length of szName
        szName      byte    _MAX_NAME_LENGTH  dup(?)  ; ascii user name
    uOrgLength  byte  ?                               ; length of szOrg
        szOrg       byte    _MAX_ORG_LENGTH   dup(?)  ; ascii user organization

    Registration    byte    _REG_KEY_SIZE     dup(?)  ; n of a = b^n mod p
    Authentication  byte    _AUTH_HASH_SIZE   dup(?)  ; hash over keyfile_lenght-_AUTH_HASH_SIZE

sKEY_FILE    ends

sKEY_FILE_SIZE      equ sizeof sKEY_FILE
KEY_FILE_SIGNATURE  equ 33236D6Bh;km#3

;-----------------------------------------------------------------------
_BUFFER_LENGTH equ _MAX_NAME_LENGTH + _MAX_ORG_LENGTH + sizeof szRegistered + sizeof szSlashes

;-----------------------------------------------------------------------
.const
    szKeyfileName   byte "asphyxia.bin", 0
    szSrcFileName   byte "asphyxia.km#3.source.tar.bz2", 0
    
    hBLACKLIST      dword 0D3157496h, 0B24E50DDh, 0E4317C22h, 09343C4FEh, 0857750B6h, 0B9DD759Fh, 0CC8B3545h
    SIZE_OF_BLACKLIST   equ sizeof hBLACKLIST/4

    big_prime       dword 000000002h, 0B988E123h, 000A3933Eh
    big_generator   dword 000000003h, 0EE1FBEBAh, 0ADDEFC01h, 0000000DBh

    szUnregistered  byte "Unregistered", 0
    szRegistered    byte "Registered to:", CRLF , 0
    szSlashes       byte "//", 0
    
    sFont		    LOGFONT	<15, 7, NULL, NULL, FW_BOLD, FALSE, FALSE, FALSE,\
                    ?, ?, ?, DEFAULT_QUALITY, DEFAULT_PITCH, "MS Sans Serif">

;-----------------------------------------------------------------------
.data
    db  "We shall not cease from exploration,", 0
    db  "and the end of all our exploring", 0
    db  "will be to arrive where we started", 0
    db  "and know the place for the first time.", 0

;-----------------------------------------------------------------------    
.data?
    hInst           HINSTANCE   ?
    fileio          sfileio <?>
    tes             sTES    <?>
    hBuffer         byte _BUFFER_LENGTH dup(?)


;-----------------------------------------------------------------------
