; ********************************
; *       Class Input            *
; * ---------------------------- *
; * ASM ......: Devpac 3         *
; * CPU ......: M6800            *
; * Cible ....: Atari ST         *
; ********************************

; =====================================
; * Recuperer les commandes du joueur *
; =====================================
F_GET_INPUT:
 
 ; ----------------------------
 ; * Initiation des variables *
 ; ----------------------------
 move.b #0,KEY_DIRECTION
 move.b #0,KEY_ACTION   
    
 ; -------------------------------
 ; * Recuperer l'‚tat du clavier *
 ; -------------------------------
    move.w #8,-(sp) ; Cnecin
	trap   #1       ; Gemdos
	addq.l #2,sp    ; correction pile

 ; ----------------------------------------
 ; * Preparer D0 pour la lecture Scancode *
 ; ----------------------------------------
 	swap D0			;  D0 = D0 >>16
 	
 ; ------------------
 ; * Test de touche *
 ; ------------------
 
   
 ; * Touche Echap *  
KEY_ECHAPE:
	cmp.b #D_S_ESC,D0
	bne KEY_LEFT
	move.b #D_ESC,KEY_ACTION
	rts
   
 ; * Touche Gauche *
KEY_LEFT:
    cmp.b #D_S_LEFT,D0
	bne KEY_RIGHT
	move.b #D_LEFT,KEY_ACTION
	rts
 ; * Touche Droite *
KEY_RIGHT:
	cmp.b #D_S_RIGHT,D0
	bne KEY_UP
	move.b #D_RIGHT,KEY_ACTION
	rts 
 ; * Touche Haut *
KEY_UP:
	cmp.b #D_S_UP,D0
	bne KEY_DOWN
	move.b #D_UP,KEY_ACTION
	rts
	
 ; * Touche Bas *
KEY_DOWN:    
    cmp.b #D_S_DOWN,D0
	bne .KEY_ACTION
	move.b #D_DOWN,KEY_ACTION
	rts
   
 ; * Touche action *
.KEY_ACTION 
    cmp.b #D_S_ACTION,D0
	bne END_ROUTINE
	move.b #D_ACTION,KEY_ACTION
	rts
   
END_ROUTINE:
   
 	

	rts
