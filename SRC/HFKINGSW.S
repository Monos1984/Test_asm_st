; **************************************
; *     Hero Fantasy King's Sword      *
; **************************************
; * Compilateur ....: DevPac3          *
; * ASM ............: M68000           *
; * Machine Cible ..: Atari Ste 512ko  *
; * Version ........: 00/00/00         *
; * Date ...........: 31/03/24         *
; * Programmeur ....: Jean Monos       *
; * Graphismes .....: n/d              *
; * Sound ..........: n/d              *
; **************************************

; =========================
; *     Include Define    *
; =========================

; -----------------
; * Define System *
; -----------------
	INCLUDE DEFSYS.S



; ===================
; *     Startup     *
; ===================


  ;  move.b $FF8001,D3
  ;  cmp.b #%01,D3
  ;  beq QUIT_PROGRAMME
    
    
	bsr F_SAVE_MODE ; Sauvegarde de l'‚tat du ST
	


; ================
; *     MAIN     *
; ================
MAIN:

; ==============
; * Initiation *
; ==============
	move.b #D_TITLE_SCREEN,ID_SCENE ; Initiation ID_SCENE

; ------------
; * Curs Off *
; ------------
	DC.W $A00A

; ------------------------
; * Mode base r‚solution *
; ------------------------
	clr.w -(SP)      ; Mode 0
	move.l #-1,-(SP) ; Not Update Physic Adresse 
	move.l #-1,-(SP) ; Not UPdate Logic Adresse
	move.w #5,-(SP) ; Setscreen
	trap   #14       ; Xbios
	add.l  #12,sp    ; Correction pile 
	

; ========================
; *      GAME LOOPS      *
; ========================
GAME_LOOPS:

; --------------------------------------------
; * Charger l'ID_SCENE pour les tes Workflow *
; --------------------------------------------
  move.b ID_SCENE,D3 ; Charger le type de Scene dans D3

; -----------------------
; * TITLE SCREEN        *
; -----------------------
  cmp.b  #D_TITLE_SCREEN,D3 
  beq    F_SC_TITLE_SCREEN   
  
; --------------
; * Game Map   *
; --------------  
  cmp.b #D_GAME_MAP,D3
  beq   QUIT_PROGRAMME ; Encore provisoir !!!!   
  
; -----------------------
; * Quitter le proramme *
; -----------------------
  cmp.b #D_QUIT,D3
  beq   QUIT_PROGRAMME 



  jmp GAME_LOOPS




; ==========================
; *     QUIT_PROGRAMME     *
; ==========================
QUIT_PROGRAMME:


; ----------------------
; * Restore Paramettre *
; ----------------------
	bsr F_RESTORE_MODE
	
; -------------------
; * Close programme *
; -------------------    
	bsr F_QUIT_SYSTEM

       
; ===================
; * Fichier Include *
; ===================

; -----------------
; * Fichier Class *
; -----------------
	INCLUDE CSYSTEM.S   ; Class System
    INCLUDE CTITSCRE.S  ; Class Titrle Screen
    INCLUDE CINPUT.S    ; Class Input
    INCLUDE CMAP.S      ; Class Map

; -----------------	
; * Fichier SCENE *
; -----------------
 	INCLUDE SSCREENT.S ; Scene Title screen
  
  SECTION DATA 	
 	
; ----------------
; * FICHIER DATA *
; ----------------
DATA_TS:	
	INCBIN TS.PI1 ; A remplacer plus tard avec un load file
	
DATA_TL:
	INCBIN TL.PI1
	
; =======================	
; * Section DATA_SYSTEM *
; =======================	
	SECTION BSS

; -----------------------------------
; * Adresse Sauvegarde Etat Machine *
; -----------------------------------
SAVE_MODE:
	DS.W 1  ; Mode video
	
SAVE_PAL:
	DS.W 16 ; Plaette de couleur
	
; -----------------
; * Adresse SCENE *
; -----------------
ID_SCENE:
	DS.B 1	

; -----------------
; * Adresse Input *
; -----------------
ID_INPUT      DS.B 1
KEY_DIRECTION DS.B 1
KEY_ACTION	  DS.B 1

MAP_PX DS.L 1
MAP_PY DS.L 1