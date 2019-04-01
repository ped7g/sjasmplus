    DEVICE ZXSPECTRUM1024

; This is very crude prototype of something like "SAVENEX" implemented in sjasmplus MACRO
; It is not supposed to be used for real projects, it was done half way as challenge to
; see if sjasmplus v1.11.0 macros can handle it (almost, needs v1.11.1 with minor fix),
; and halfway to get some idea how the real "SAVENEX" syntax may be defined.

; Hopefully in few next weeks the native sjasmplus support for NEX will be added, and this
; macro variant will remain as curiosity, or example of the power of the macro language.
; (the main issue with macro version is speed and the damage to the listing file, as the
; whole file output is visible in listing, i.e. 200kiB NEX file = ~2MiB mess of listing)

; The produced "test.nex" file should show black vertical lines on light cyan screen,
; with file size ~208kiB ... (most of it being the same bank 2 duplicated over and over
; also as content for other banks, just to test saving the header).

    org     0
    db      'abcdabcdabcdabcd'

    org     $8000
Start:
    ; set global transparency to ULA-white && set transparency fallback to light cyan
    nextreg $14, %10110110, $4A, $1F
    ld      hl,$4000
    ld      de,$4001
    ld      bc,$17FF
    ld      (hl),0x18
    ldir
    ld      hl,$5800
    ld      de,$5801
    ld      bc,$02FF
    ld      (hl),7*8+0
    ldir
.loopyLoop:
    jr      .loopyLoop

;SAVESNA "E_Next.sna", Start

    org     $ffff
    db      1

    INCLUDE one_bank_nex_support.i.asm

; __NEX_H_BORDERCOL,__NEX_H_LOADBAR,__NEX_H_LOADBARCOL,__NEX_H_LOADDELAY,__NEX_H_STARTDELAY,
; __NEX_H_LOADSCR,__NEX_H_HIRESCOL,

    DEFINE __NEX_H_BORDERCOL 2
    DEFINE __NEX_H_LOADBAR 1
    DEFINE __NEX_H_LOADBARCOL $E7
    SAVENEX_SET_PCSP Start, -1
    SAVENEX_SET_DEVICE_REQ 0, 0, 2, 0, 26
    SAVENEX_SET_ENTRYB_FILEH 0, bc
    SAVENEX_OPEN "test.nex"

;     SAVENEX_SET_PCSP 0, -1
;     UNDEFINE __NEX_H_LOADSCR
;     DEFINE __NEX_H_LOADSCR 129
;     _NEX_SAVE__HEADER
;     _NEX_SAVE__OPEN_OUTPUT a
;     DEVICE NONE
;     DUP 768     ; 64x768 = 49152 bytes
;     HEX 000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F
;     EDUP

    SAVENEX_SET_PCSP Start, -1
    SAVENEX_SAVEBANK 5, $8000
    SAVENEX_SAVEBANK 2, $8000
    SAVENEX_SAVEBANK 0, $8000
    SAVENEX_SAVEBANK 1, $8000
    SAVENEX_SAVEBANK 3, $8000
    SAVENEX_SAVEBANK 4, $8000
    SAVENEX_SAVEBANK 6, $8000
    SAVENEX_SAVEBANK 7, $8000
    SAVENEX_SAVEBANK 8, $8000
    SAVENEX_SAVEBANK 9, $8000
    SAVENEX_SAVEBANK 3, $8000
    SAVENEX_SAVEBANK 10, $8000
    SAVENEX_SAVEBANK 11, $8000
    SAVENEX_SAVEBANK 12, $8000
    SAVENEX_SAVEBANK 12, $8000

    SAVENEX_END