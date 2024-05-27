; ********************************
; *       Scene Title Screen     *
; * ---------------------------- *
; * ASM ......: Devpac 3         *
; * CPU ......: M6800            *
; * Cible ....: Atari ST         *
; ********************************

; ======================
; * SCENE TITLE SCREEN *
; ======================
F_SC_TITLE_SCREEN:

; ----------------------------
; * Afficher le title screen *
; ----------------------------
	jsr F_DRAW_TITLE_SCREEN
    jsr F_CLS
  jsr F_DRAW_MAP

  
  
 

; ----------------------
; * Boucle de la scene *
; ----------------------
BC_SC_TITLE_SCREEN:

	jsr F_GET_INPUT
	
	move.b KEY_ACTION,D0
	
	cmp.b #D_ESC,D0
	BNE END_TEST_ESC
    move.b #D_QUIT,ID_SCENE
END_TEST_ESC
	cmp.b #D_ACTION,D0
	bne END_ACTION
	jsr F_CLS
END_ACTION:
; ------------------------------------------
; * Tester si on est encore dans la boucle *
; ------------------------------------------
	move.b ID_SCENE,D3
	cmp.b #D_TITLE_SCREEN,D3
	BEQ BC_SC_TITLE_SCREEN
	
; -------------------------
; * Retour a la game loop *
; -------------------------

	jmp GAME_LOOPS
