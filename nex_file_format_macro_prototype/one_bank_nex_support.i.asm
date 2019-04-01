    DEVICE NONE

    ;; structures definitions (HEADER mostly)
    ; - must be built from smaller parts for the macro code dealing with banks array :/

    STRUCT NEX_HEADER_FILE_VERSION
                DS      1, 'V'
V_MAJOR         DB      '1'
                DS      1, '.'
V_MINOR         DB      '2'
    ENDS

    STRUCT NEX_HEADER_CORE_VERSION
V_MAJOR         DB      2
V_MINOR         DB      0
V_SUBMINOR      DB      0
    ENDS

NEX_MAX_BANK    EQU     112
    DEFARRAY __NEX_BANK_MAPPING 5, 2, 0, 1, 3, 4, 6, 7

NEX_HEADER_LOADSCR_LAYER2   EQU     1       ; loads palette by default
NEX_HEADER_LOADSCR_ULA      EQU     2       ; can't have palette
NEX_HEADER_LOADSCR_LORES    EQU     4       ; loads palette by default
NEX_HEADER_LOADSCR_HIRES    EQU     8       ; Timex HiRes (no palette)
NEX_HEADER_LOADSCR_HICOL    EQU     16      ; Timex HiCol (no palette)
NEX_HEADER_LOADSCR_NOPAL    EQU     128     ; no palette for Layer2/Lores

    STRUCT NEX_HEADER_PART_0
                DS      1, 'N'
                DS      1, 'e'
                DS      1, 'x'
                DS      1, 't'
NEXVERSION      NEX_HEADER_FILE_VERSION     ; file version (V1.2 is current)
RAMREQ          DB              ; 0 = 768k, 1 = 1792k
NUMBANKS        DB              ; number of 16k banks to load (0..112)
LOADSCR         DB              ; see NEX_HEADER_LOADSCR constants (bitmask flags)
BORDERCOL       DB              ; 0-7
SP              DW              ; stack pointer
PC              DW      0       ; entry point (in default MMU 16k mapping FF:5:2:0) (0=no start, only load)
                DS      2, 0    ; "NUMFILES" - obsolete, keep zeroed
    ENDS
    STRUCT NEX_HEADER_PART_1
BANKS           DS      NEX_MAX_BANK, 0 ; 112 banks in total = 1.75MiB ; 0/1 false/true array
    ENDS
    STRUCT NEX_HEADER_PART_2
LOADBAR         DB      0       ; 0/1 show Layer2 progress bar
LOADBARCOL      DB      0       ; colour of progress bar
LOADDELAY       DB      0       ; delay after each bank is loaded (1/50th of sec)
STARTDELAY      DB      0       ; delay after whole file is loaded (before app entry) 1/50th
PRESERVENEXTREG DB      0       ; 0/1: 0=reset NextRegs to almost-defaults, 1=keep them as they are
COREVERSION     NEX_HEADER_CORE_VERSION     ; required minimal core version
HIRESCOL        DB      0       ; Timex 512x192 mode colour for port 255 (bits 5-3)
ENTRYBANK       DB      0       ; Bank to page into C000..FFFF area before start
FILEHANDLERET   DW      0       ; 0 = close file, 1..$3FFF = BC contains file handle
                                ; $4000+ = file handle is written into memory at this address
    ENDS

    STRUCT NEX_HEADER_WHOLE
P0      NEX_HEADER_PART_0
P1      NEX_HEADER_PART_1
P2      NEX_HEADER_PART_2
    ENDS

    ;; Macros to save NEX files

    ;; first mostly-internal macros with _NEX_SAVE__*** file names are defined
    MACRO   _NEX_SAVE__ERR errid?, text?
        IFNDEF ___NEX_ERR_ID : DEFINE ___NEX_ERR_ID errid? : DISPLAY text? : ENDIF
    ENDM

    MACRO   _NEX_SAVE__CHECK_HEADER_VALUES
        ; file version (empty = default)
        IFNDEF __NEX_H_FILE_VER : DEFINE __NEX_H_FILE_VER : ENDIF   ; default is "V1.2"
        ; RAM-required
        IFNDEF __NEX_H_RAMREQ : DEFINE  __NEX_H_RAMREQ 0
        ELSE
            IF __NEX_H_RAMREQ < 0 || 1 < __NEX_H_RAMREQ : _NEX_SAVE__ERR RAMREQ, "RAMREQ value is not 0/1 (0 = 768k, 1 = 1792k)" : ENDIF
        ENDIF
        ; load screen bitflag
        IFNDEF __NEX_H_LOADSCR : DEFINE  __NEX_H_LOADSCR 0
        ELSE
            IF __NEX_H_LOADSCR < 0 || 255 < __NEX_H_LOADSCR : _NEX_SAVE__ERR LSCR, "LOADSCR value is not 0..255 (byte bitmask)" : ENDIF
        ENDIF
        ; border colour
        IFNDEF __NEX_H_BORDERCOL : DEFINE  __NEX_H_BORDERCOL 0
        ELSE
            IF __NEX_H_BORDERCOL < 0 || 7 < __NEX_H_BORDERCOL : _NEX_SAVE__ERR BCOL, "BORDERCOL value is not 0..7" : ENDIF
        ENDIF
        ; PC value
        IFNDEF __NEX_H_PC : DEFINE  __NEX_H_PC 0
        ELSE
            IF __NEX_H_PC < 0 || $FFFF < __NEX_H_PC : _NEX_SAVE__ERR PCV, "PC value is not 16b" : ENDIF
        ENDIF
        ; SP value
        IFNDEF __NEX_H_SP : DEFINE  __NEX_H_SP $FF40
            ;;TODO pre-fill bank 0 with "BASIC" stack: FF40:2B2D65330000ED10ED0053002F20ED1FDB1F761B0313 - PRINT USR 32768
            ;;TODO or even add here some heuristic where the stack should land
        ELSE
            IF __NEX_H_SP < 0 || $FFFF < __NEX_H_SP : _NEX_SAVE__ERR SPV, "SP value is not 16b" : ENDIF
        ENDIF
        ; loading bar in layer 2 enabled
        IFNDEF __NEX_H_LOADBAR : DEFINE  __NEX_H_LOADBAR 0
        ELSE
            IF __NEX_H_LOADBAR < 0 || 1 < __NEX_H_LOADBAR : _NEX_SAVE__ERR LBR, "LOADBAR value is not 0/1" : ENDIF
        ENDIF
        ; loading bar colour (if enabled, gets $19 by default, otherwise 0 by default)
        IFNDEF __NEX_H_LOADBARCOL
            IF 0 < __NEX_H_LOADBAR : DEFINE __NEX_H_LOADBARCOL $19 ; light green by default if LOADBAR is enabled
            ELSE : DEFINE __NEX_H_LOADBARCOL 0 : ENDIF
        ELSE
            IF __NEX_H_LOADBARCOL < 0 || 255 < __NEX_H_LOADBARCOL : _NEX_SAVE__ERR LBRCOL, "LOADBARCOL value is not 8b" : ENDIF
        ENDIF
        ; delay after screen is loaded (frames, 0 = OFF)
        IFNDEF __NEX_H_LOADDELAY : DEFINE __NEX_H_LOADDELAY 0
        ELSE
            IF __NEX_H_LOADDELAY < 0 || 255 < __NEX_H_LOADDELAY : _NEX_SAVE__ERR LDDEL, "LOADDELAY value is not 8b" : ENDIF
        ENDIF
        ; delay after whole file is loaded (frames, 0 = OFF)
        IFNDEF __NEX_H_STARTDELAY : DEFINE __NEX_H_STARTDELAY 0
        ELSE
            IF __NEX_H_STARTDELAY < 0 || 255 < __NEX_H_STARTDELAY : _NEX_SAVE__ERR STRDEL, "STARTDELAY value is not 8b" : ENDIF
        ENDIF
        ; preserve current NextReg values 0/1
        IFNDEF __NEX_H_PRESERVENEXTREG : DEFINE  __NEX_H_PRESERVENEXTREG 0
        ELSE
            IF __NEX_H_PRESERVENEXTREG < 0 || 1 < __NEX_H_PRESERVENEXTREG : _NEX_SAVE__ERR PRNR, "PRESERVENEXTREG value is not 0/1" : ENDIF
        ENDIF
        ; required core version
        IFNDEF __NEX_H_COREVERSION : DEFINE  __NEX_H_COREVERSION 2,0,26 : ENDIF
        ; Timex Hires 512x192 mode ink colour (for port 255)
        IFNDEF __NEX_H_HIRESCOL : DEFINE __NEX_H_HIRESCOL 0
        ELSE
            IF __NEX_H_HIRESCOL < 0 || 56 < __NEX_H_HIRESCOL || __NEX_H_HIRESCOL&7 : _NEX_SAVE__ERR HRCOL, "HIRESCOL value is not (0..7)*8 value" : ENDIF
            IF __NEX_H_HIRESCOL && !(__NEX_H_LOADSCR&NEX_HEADER_LOADSCR_HIRES) : DISPLAY LSCRHRCOL, "HIRESCOL defined, but HiRes screen not added" : ENDIF
        ENDIF
        ; Entry bank (bank for C000..FFFF slot) after NEX is loaded
        IFNDEF __NEX_H_ENTRYBANK : DEFINE __NEX_H_ENTRYBANK 0
        ELSE
            IF __NEX_H_ENTRYBANK < 0 || NEX_MAX_BANK <= __NEX_H_ENTRYBANK : _NEX_SAVE__ERR ENTRB, "ENTRYBANK value is not 0..111" : ENDIF
        ENDIF
        ; file handle address (0 = OFF, close NEX file, 1..3FFF = loads file handle into BC, 4000..FFFF = stores file handle into memory)
        IFNDEF __NEX_H_FILEHANDLERET : DEFINE __NEX_H_FILEHANDLERET 0
        ELSE
            IF __NEX_H_FILEHANDLERET < 0 || $FFFF < __NEX_H_FILEHANDLERET : _NEX_SAVE__ERR FHR, "FILEHANDLERET value is not 16b" : ENDIF
        ENDIF
    ENDM

    MACRO   _NEX_SAVE__OPEN_OUTPUT mode?
        IFNDEF __NEX_OUTPUT_FILE : _NEX_SAVE__ERR OFNNONE, "output filename for NEX file not defined"
        ELSE
            OUTPUT __NEX_OUTPUT_FILE,mode?
        ENDIF
    ENDM

    DEFINE _NEX_SAVE__CLOSE_OUTPUT OUTEND

    MACRO   _NEX_SAVE__HEADER
        _NEX_SAVE__CHECK_HEADER_VALUES
__NEX_LAST_ORG=$
        DEVICE NONE             ; create header bytes outside of device memory
        ; if stage 0, init banks counter and move to stage 1
        IF 0 = __NEX_SAVE_STAGE
__NEX_H_NUMBANKS=0
__NEX_SAVE_STAGE=1
        ENDIF
        ; if particular bank is being written, increment number of written banks
        IF 100 <= __NEX_SAVE_STAGE && __NEX_SAVE_STAGE < 100 + NEX_MAX_BANK
__NEX_H_NUMBANKS=__NEX_H_NUMBANKS+1
        ENDIF
        ; write header bytes into file
        ORG     0
        _NEX_SAVE__OPEN_OUTPUT r
        ; write V1.1 header part
        NEX_HEADER_PART_0 {__NEX_H_FILE_VER},__NEX_H_RAMREQ,__NEX_H_NUMBANKS,__NEX_H_LOADSCR,__NEX_H_BORDERCOL,__NEX_H_SP,__NEX_H_PC
        ; write banks array
        IF __NEX_SAVE_STAGE < 100 : NEX_HEADER_PART_1 : ELSE    ;; just reset whole banks area in early stages
            IF __NEX_SAVE_STAGE < 100 + NEX_MAX_BANK            ;; particular bank stage, mark it!
                IF 100+8 <= __NEX_SAVE_STAGE : FPOS NEX_HEADER_WHOLE.P1.BANKS + __NEX_SAVE_STAGE - 100
                ELSE : FPOS NEX_HEADER_WHOLE.P1.BANKS + __NEX_BANK_MAPPING[__NEX_SAVE_STAGE-100] : ENDIF
                DB 1
            ENDIF
            ORG  NEX_HEADER_WHOLE.P2 : FPOS NEX_HEADER_WHOLE.P2
        ENDIF
        ; write V1.2 header part
        NEX_HEADER_PART_2 __NEX_H_LOADBAR,__NEX_H_LOADBARCOL,__NEX_H_LOADDELAY,__NEX_H_STARTDELAY,__NEX_H_PRESERVENEXTREG,{__NEX_H_COREVERSION},__NEX_H_HIRESCOL,__NEX_H_ENTRYBANK,__NEX_H_FILEHANDLERET
        ds      512 - $, 0      ; pad the header bytes to 512 size
        _NEX_SAVE__CLOSE_OUTPUT
        DEVICE ZXSPECTRUM1024   ; restore the device back
        ORG __NEX_LAST_ORG
    ENDM

    ;; "public" API (one should manage to do most of the things with these only)
    ; for more obscure variables, do something like `DEFINE __NEX_H_FILE_VER 1,5` *BEFORE* calling any macro (or UNDEFINE the var if defined)
    ; calling some "public" macro will eventually reach `_NEX_SAVE__CHECK_HEADER_VALUES` which will define all missing header values to defaults

    MACRO SAVENEX_SET_PCSP pc?, sp?
        IFDEF __NEX_H_PC : UNDEFINE __NEX_H_PC : ENDIF
        IFDEF __NEX_H_SP : UNDEFINE __NEX_H_SP : ENDIF
        DEFINE __NEX_H_PC pc?
        IF -1 != sp? : DEFINE __NEX_H_SP sp? : ENDIF
        _NEX_SAVE__CHECK_HEADER_VALUES
    ENDM

    MACRO SAVENEX_SET_DEVICE_REQ RAMreq?, PreserveNextRegs?, CoreVerMajor?, CoreVerMinor?, CoreVerSubMinor?
        IFDEF __NEX_H_RAMREQ : UNDEFINE __NEX_H_RAMREQ : ENDIF
        IFDEF __NEX_H_PRESERVENEXTREG : UNDEFINE __NEX_H_PRESERVENEXTREG : ENDIF
        IFDEF __NEX_H_COREVERSION : UNDEFINE __NEX_H_COREVERSION : ENDIF
        DEFINE __NEX_H_RAMREQ RAMreq?
        DEFINE __NEX_H_PRESERVENEXTREG PreserveNextRegs?
        DEFINE __NEX_H_COREVERSION CoreVerMajor?, CoreVerMinor?, CoreVerSubMinor?
        IF CoreVerMajor? < 0 || 15 < CoreVerMajor? : _NEX_SAVE__ERR CRV1, "Core version major is not 0..15" : ENDIF
        IF CoreVerMinor? < 0 || 15 < CoreVerMinor? : _NEX_SAVE__ERR CRV2, "Core version minor is not 0..15" : ENDIF
        IF CoreVerSubMinor? < 0 || 255 < CoreVerSubMinor? : _NEX_SAVE__ERR CRV3, "Core version subminor is not 8b" : ENDIF
        _NEX_SAVE__CHECK_HEADER_VALUES
    ENDM

    MACRO SAVENEX_SET_ENTRYB_FILEH entryBank?, fileHandleAddress?
        IFDEF __NEX_H_ENTRYBANK : UNDEFINE __NEX_H_ENTRYBANK : ENDIF
        IFDEF __NEX_H_FILEHANDLERET : UNDEFINE __NEX_H_FILEHANDLERET : ENDIF
        DEFINE __NEX_H_ENTRYBANK entryBank?
        ; fileHandleAddress? can be also "bc" as register pair
        DEFINE .._fileHandleAddress?
        IFDEF .._bc
            DEFINE __NEX_H_FILEHANDLERET 1
        ELSE
            IF 0 < fileHandleAddress? && fileHandleAddress? < $4000 : _NEX_SAVE__ERR FHR2, "you can use: `SAVENEX_SET_ENTRYB_FILEH 0, bc` instead of low address" : ENDIF
            DEFINE __NEX_H_FILEHANDLERET fileHandleAddress?
        ENDIF
        IFDEF .._
            UNDEFINE .._
        ELSE
            UNDEFINE .._fileHandleAddress?
        ENDIF
        _NEX_SAVE__CHECK_HEADER_VALUES
    ENDM

    MACRO   SAVENEX_OPEN fname?
        IFDEF __NEX_OUTPUT_FILE : _NEX_SAVE__ERR OFNDUP, "output filename for NEX file already defined"
__NEX_SAVE_STAGE=999
        ELSE
            DEFINE __NEX_OUTPUT_FILE fname?
__NEX_SAVE_STAGE=0
            _NEX_SAVE__OPEN_OUTPUT t
            _NEX_SAVE__CLOSE_OUTPUT
        ENDIF
    ENDM

    MACRO SAVENEX_END
        _NEX_SAVE__CLOSE_OUTPUT
        UNDEFINE __NEX_OUTPUT_FILE
__NEX_SAVE_STAGE=999
    ENDM

    MACRO SAVENEX_SAVEBANK saveAsBank?, address?
__NEX_SAVE_STAGE_OLD=__NEX_SAVE_STAGE       ;; remember original stage (if save fails)
        ;; save header if nothing was outputted yet
        IF 0 = __NEX_SAVE_STAGE : _NEX_SAVE__HEADER : ENDIF
        ;; if still in images stages, move into bank stage
        IF __NEX_SAVE_STAGE < 100
__NEX_SAVE_STAGE=100
        ENDIF
        ;; find if the requested bank is in correct order (and skip banks as needed)
        ; calculate at which stage the requested bank will be stored
        IF 8 <= saveAsBank?
__NEX_STAGE_FOR_BANK=100+saveAsBank?
        ELSE
__NEX_STAGE_FOR_BANK=0
            DUP 8
                IF saveAsBank? != __NEX_BANK_MAPPING[__NEX_STAGE_FOR_BANK]
__NEX_STAGE_FOR_BANK=__NEX_STAGE_FOR_BANK+1
                ENDIF
            EDUP
__NEX_STAGE_FOR_BANK=__NEX_STAGE_FOR_BANK+100
        ENDIF

        IF __NEX_SAVE_STAGE <= __NEX_STAGE_FOR_BANK : DISPLAY "Storing bank ",/D,saveAsBank?," (stage ",/D,__NEX_STAGE_FOR_BANK,")"
            ;; the requested bank may be saved at this stage, go ahead
__NEX_LAST_ORG=$
__NEX_SAVE_STAGE=__NEX_STAGE_FOR_BANK   ;; make the correct bank to save (set stage)
            _NEX_SAVE__HEADER
            _NEX_SAVE__OPEN_OUTPUT a
            ORG address? : DUP $800 : dw {$},{$+2},{$+4},{$+6} : EDUP  ;; copy 16384 from device memory
            _NEX_SAVE__CLOSE_OUTPUT
            ORG __NEX_LAST_ORG
__NEX_SAVE_STAGE=__NEX_SAVE_STAGE+1
        ELSE : DISPLAY "Save of bank ",/D,saveAsBank?," requested too late."
__NEX_SAVE_STAGE=__NEX_SAVE_STAGE_OLD   ;; nothing was saved, so restore stage back
        ENDIF
    ENDM

    DEVICE ZXSPECTRUM1024
