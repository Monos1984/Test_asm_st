; ********************************
; *       Class Title Screen     *
; * ---------------------------- *
; * ASM ......: Devpac 3         *
; * CPU ......: M6800            *
; * Cible ....: Atari ST         *
; ********************************


; ============================================
; * Afficher … l'ecran, l'‚cran titre du jeu *
; ============================================
F_DRAW_TITLE_SCREEN:

; ----------------------------
; * Chargement de la palette *
; ----------------------------
	move.l #DATA_TL+2,-(SP) ; Offset Palete
	move.w #6,-(sp)          ; Setpalette
	trap  #14               ; Xbios 
	add.l #6,SP            ; Correction Pile
	
; ---------------------------------
; * Chargement du Logbase dans D0 *
; ---------------------------------
	jsr F_GET_LOGBASE
	
; --------------------------------
; * Initiation de la copie image *
; --------------------------------
	move.l D0,A3             ; Adresse logique en A3
	move.l #DATA_TL+34,A0	 ; Offset image en A0 (Source)
	
	move.w #32000/4-1,D0     ; Compteur d'octet
	
.COPIE:
	move.l (A0)+,(A3)+
	dbf d0,.COPIE

	rts
