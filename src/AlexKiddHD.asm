; ---------------------------------------------------------------------------
; Alex Kidd in the Enchanted Castle - native A1200 port
; WHDLoad slave source for Phase 7X
; Ported by MATRIX 2026
;
; Requires the WHDLoad DEV include file: whdload.i
; Build with vasm (Motorola syntax), for example:
;   vasmm68k_mot -m68020 -Fhunkexe -kick1hunks -nosym \
;       -I<path-to-WHDLoad-Include> -o AlexKidd.slave AlexKiddHD.asm
;
; Disk.1 is the Phase 7X ADF.  The slave bypasses the Amiga bootblock and
; loads the native payload directly from ADF offset $400.
; ---------------------------------------------------------------------------

        INCLUDE "whdload.i"

GAMEBASE        = $1000
DISK_OFFSET     = $400
LOAD_SIZE       = $DB200
CHIP_REQUIRED   = $F6000

; Phase 7X executable offsets, verified against Disk.1
FRAME_ENTRY     = $0278
FRAME_GAMEWAIT  = $0280
FRAME_BOTTOMWAIT= $029A

QUITKEY         = $59                   ; F10 rawkey
FLAGS           = WHDLF_NoError|WHDLF_ClearMem|WHDLF_Req68020|WHDLF_ReqAGA

; ---------------------------------------------------------------------------
; WHDLoad Slave header.  Version 17 is used so Req68020/ReqAGA and modern
; header fields are explicit.  Slave code/data below stays PC-relative.
; ---------------------------------------------------------------------------

_header:
        dc.l    $70FF4E75               ; security: moveq #-1,d0 / rts
        dc.b    "WHDLOADS"
        dc.w    17                      ; ws_Version
        dc.w    FLAGS                   ; ws_Flags
        dc.l    CHIP_REQUIRED           ; ws_BaseMemSize
        dc.l    0                       ; ws_ExecInstall
        dc.w    _start-_header          ; ws_GameLoader
        dc.w    0                       ; ws_CurrentDir
        dc.w    0                       ; ws_DontCache
        dc.b    0                       ; ws_keydebug
        dc.b    QUITKEY                 ; ws_keyexit
        dc.l    0                       ; ws_ExpMem
        dc.w    _name-_header           ; ws_name
        dc.w    _copy-_header           ; ws_copy
        dc.w    _info-_header           ; ws_info
        ; v16
        dc.w    0                       ; ws_kickname
        dc.l    0                       ; ws_kicksize
        dc.w    0                       ; ws_kickcrc
        ; v17
        dc.w    0                       ; ws_config

_name:
        dc.b    "Alex Kidd in the Enchanted Castle - A1200 Port",0
_copy:
        dc.b    "1989 Sega / A1200 port 2026",0
_info:
        dc.b    "WHDLoad slave for the native A1200 port",10
        dc.b    "PORTED BY MATRIX  2026",10
        dc.b    "Phase 7X - F10 quits to Workbench",0
        even

_resload:
        dc.l    0

; ---------------------------------------------------------------------------
; WHDLoad entry
; A0 = resload jump table
; ---------------------------------------------------------------------------

_start:
        lea     _resload(pc),a1
        move.l  a0,(a1)
        move.l  a0,a2

        ; Load the native game payload exactly as the bootblock does, but
        ; directly from Disk.1.  The ADF bootblock itself is skipped.
        move.l  #DISK_OFFSET,d0
        move.l  #LOAD_SIZE,d1
        moveq   #1,d2
        lea     GAMEBASE,a0
        jsr     (resload_DiskLoad,a2)
        tst.l   d0
        bne.s   .loaded

        ; DiskLoad failed: d1 contains the trackdisk/DOS error code.
        move.l  #1,-(sp)                ; secondary: disk number
        move.l  d1,-(sp)                ; primary: I/O error
        move.l  #TDREASON_DISKLOAD,-(sp)
        move.l  (_resload,pc),a2
        jmp     (resload_Abort,a2)

.loaded:
        ; Patch the first 8 bytes of the main frame dispatcher:
        ;   cmpi.w #4,d7
        ;   bne.w  FRAME_BOTTOMWAIT
        ; becomes JMP _framehook + NOP.
        ; _framehook reproduces the original dispatch after checking F10.
        lea     GAMEBASE+FRAME_ENTRY,a1
        move.w  #$4EF9,(a1)+            ; JMP abs.l
        lea     _framehook(pc),a0
        move.l  a0,(a1)+
        move.w  #$4E71,(a1)             ; NOP (keeps patch exactly 8 bytes)

        move.l  (_resload,pc),a2
        jsr     (resload_FlushCache,a2)

        ; Phase 7X begins with MOVEA.L A0,A3, so A0 must be the payload base.
        lea     GAMEBASE,a0
        jmp     (a0)

; ---------------------------------------------------------------------------
; Direct quit-key hook
;
; The native port takes over the hardware and masks interrupts, so this reads
; the keyboard CIA directly instead of depending on an AmigaOS key handler.
; It then reproduces the two original targets of FRAME_ENTRY exactly.
; ---------------------------------------------------------------------------

_framehook:
        move.l  d0,-(sp)
        move.b  $BFEC01,d0
        ror.b   #1,d0
        not.b   d0
        cmp.b   #QUITKEY,d0
        beq.s   .quit

        move.l  (sp)+,d0
        cmpi.w  #4,d7
        beq.s   .gameplay
        jmp     GAMEBASE+FRAME_BOTTOMWAIT

.gameplay:
        jmp     GAMEBASE+FRAME_GAMEWAIT

.quit:
        addq.l  #4,sp                    ; discard saved d0
        move.l  #TDREASON_OK,-(sp)
        move.l  (_resload,pc),a2
        jmp     (resload_Abort,a2)

        even