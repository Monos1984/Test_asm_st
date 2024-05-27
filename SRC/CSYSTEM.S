; **************************
; *       Class System     *
; * ---------------------- *
; * ASM ......: Devpac 3   *
; * CPU ......: M6800      *
; * Cible ....: Atari ST   *
; **************************

; ==================================
; *        Quitter le system       *
; * ------------------------------ *
; * F_QUIT_SYSTEM                  *
; * ------------------------------ *
; * Traps .... : GEMDOS #1         *
; * Fonction ..: Pterm  #0         *
; * CE ........: N/D               *
; * CS ........: N/D               *
; * Effet .....: Quite le programe * 
; ==================================
F_QUIT_SYSTEM:
	clr.w -(sp)   ; Pterm 0
	trap #1       ; GEMDOS
	
; =========================================
; *          Attendre une touche          *
; * ------------------------------------- *
; * F_WAIT_KEY                            *
; * ------------------------------------- *
; * Traps .... : GEMDOS #1                *
; * Fonction ..: Cnecin #8                *
; * CE ........: N/D                      *
; * CS ........: N/D                      *
; * Effet .....: Attendre une touche      * 
; =========================================	
F_WAIT_KEY:
	move.w #8,-(sp) ; Cnecin
	trap   #1       ; Gemdos
	addq.l #2,sp    ; correction pile
	
	rts             ; Return
	
; =========================================
; *        Sauvegarder l'etat du st       *
; * ------------------------------------- *
; * F_SAVE_MODE                           *
; * ------------------------------------- *
; * Traps .... : XBIOS    #14             *
; * Fonction ..: Getrez   #4              *
; * ...........: Setcolor #7              *
; * CE ........: N/D                      *
; * CS ........: N/D                      *
; * Effet .....: Save Etat du St          * 
; =========================================
F_SAVE_MODE:

; +++++++++++++++++++++++++++++
; * Sauvegarder le mode video *
; +++++++++++++++++++++++++++++

; -------------------------------------
; - Sauvegarder dans D0 le mode video -
; -------------------------------------
	move.w #4,-(sp)  ; GetRez
	trap   #14       ; Xbios
	addq.l #2,SP     ; Correction pile

; ------------------------------
; - Memorisation du mode video -
; ------------------------------

    move.w D0,SAVE_MODE ; Save … l'adr SAVE_MODE, le mode video (0-1-2)

; +++++++++++++++++++++++++++++++++++++
; * Sauvegarder la palette de couleur *
; +++++++++++++++++++++++++++++++++++++

; ---------------------------
; - Initation des registres -
; --------------------------- 
	move.l #SAVE_PAL,A3 ; Adresse de SAVE_PAL dans A3    
    moveq  #0,D3        ; Initier D3 … 0 (id_couleur)
 
 .BOUCLE:
 
 ; --------------------------------------------------
 ; - Configuration de SetColor pour lire la couleur -
 ; - La couleur se trouve en D0                     -
 ; --------------------------------------------------
 ; 
    move.w #-1,-(SP) ; Mode Lecture de la couleur
    move.w D3,-(SP)  ; Parametre de la couleur … lire (D3)
    move.w #7,-(SP)  ; Setcolor
    trap #14         ; Xbios
    addq.l #6,SP     ; Correction de la pile
    
 ; -------------------------
 ; - routine de sauvegarde -
 ; -------------------------
    move.w D0,(A3)+   ; Save D0 => ptrs A3 et inc A3
    addq.w #1,D3      ; inc D3 pour la couleur suivate … lire
   
 ; -----------------------------   
 ; - Test de sortie de  boucle -
 ; -----------------------------
    cmp.w #16,D3 ; Tester si D3 est < … 16
    blt .BOUCLE
    
 ; ----------
 ; - Return -
 ; ----------
	rts ; Return
; =========================================
; *        Resoter  l'etat du st          *
; * ------------------------------------- *
; * F_RESTORE_MODE                        *
; * ------------------------------------- *
; * Traps .... : XBIOS    #14             *
; * Fonction ..: Getrez   #4              *
; * ...........: Setcolor #7              *
; * CE ........: N/D                      *
; * CS ........: N/D                      *
; * Effet .....: Save Etat du St          * 
; =========================================	
F_RESTORE_MODE:

; ----------------------
; * Restore Move Video *
; ----------------------
	move.w SAVE_MODE,-(SP)   ; Restore Resolution  
	move.l #-1,-(SP)		 ; Not Update Physic Adresse 
	move.l #-1,-(SP) 		 ; Not UPdate Logic Adresse
	move.w #5,-(SP) 		 ; Setscreen
	trap   #14       		 ; Xbios
	add.l  #12,sp    		 ; Correction pile
	
; -------------------
; * Restore Palette *
; ------------------- 
	move.l #SAVE_PAL,-(SP) ; Offset Palete
	move.w #6,-(sp)          ; Setpalette
	trap   #14               ; Xbios 
	add.l  #6,SP            ; Correction Pile
	rts

; ============================================================
; *                     F_GET_LOGBASE                        *
; ------------------------------------------------------------
; * Recuperer l'adresse logique de la m‚moire ecran dans A	 *
; ============================================================
F_GET_LOGBASE:	   
    move.w #3,-(sp) ;Logbase
	trap #14        ;Xbios
	addq.l #2,sp    ; Correction Pile 
	rts
	
; ==============================
; *              F_CLS         *
; ==============================
F_CLS:
	jsr F_GET_LOGBASE
	move.l D0,A0
    move.w #32000/4-1,D0  
.copy
	move.l #0,(A0)+
	dbf D0,.copy
	
	rts