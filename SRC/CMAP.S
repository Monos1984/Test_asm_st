; **************************
; *       Class MAP        *
; * ---------------------- *
; * ASM ......: Devpac 3   *
; * CPU ......: M6800      *
; * Cible ....: Atari ST   *
; **************************

; /////////////////
; - Documentation -
; /////////////////

; 4 octets pour encoder 8 pixel
; 8 octets pour encoder 16 pixel
; 1 ligne fait 160 octets
; 20 Tiles de 16x16 sur une ligne

; ///////////////////////////////////////////////////
; * Algo pour transformer un index en coordonn‚     *
; ///////////////////////////////////////////////////
;
; * Calculer une Ligne : Index/20 = Ligne (en case) *
; * Calculer une colonne : Index -(Ligne * 20)      *



; ************************************
; *                                  *
; ********** COPIE MODE CPU **********
; *                                  *
; ************************************

; ============================
; * F_DRAW_TILES : CPU       *
; ----------------------------
; * Paramettre               *
; ----------------------------
; * D0 : Id Tiles            *
; * D3 : Cible X (case)      *
; * D4 : Cible Y (case)      *
; ============================
F_DRAW_TILES:

; --------------------------------------------  
; * Calcule de l'adresse Source pour le test *
; --------------------------------------------
	move.l d0,d1 ; Copie id tiles dans D1 

; - calcule de la ligne -     
    divu #20,d1 ; D1 = Ligne

; - Calcule de colonne -
	move.l d1,d6 ; ligne dans D6 
    mulu #20,d6  ; ligne * 20 
    sub.l D6,D0  ; index-D6 :  D0 = colonne  
    
    MULU #(160*16),D1 ; Offset Y
  ;  MULU #8,D0        ; Offset X
     lsl.l #3,D0

; Offset Y
; 00 ... 19 = 0
; 20 ....39 = 1
	
; id/20 * (160*16)
	
	MOVE.L #DATA_TL+34,A3 ; Start Offset
	ADD.L D0,A3
	ADD.L D1,A3
	
	
; -------------------------------------------	
; * Calcule de l'adresse CIBLE pour le test *
; -------------------------------------------
; D3 = X en case
; D4 = Y en case
; start offset = (Y*160*16)
 
	jsr F_GET_LOGBASE
 
; ///////////// 
; - A3 Source -
; - A4 Cible  -
; /////////////

    move.l D0,A4    ; adr LOGBASE dans CIBLE
	
;	mulu #8,D3      ; calcul offset X
	lsl.l #3,D3
	mulu #160*16,D4 ; calcul offset Y 
	
	add.l D3,D4
	add.l D4,A4
	
; -----------------------------------
; * Initiation du compteur de ligne *
; -----------------------------------		
	move.W  #15,D0  ; 16 ligne-1 

.copy 
; -------------------------------
; * Copier les Data souce/cible *
; -------------------------------
	move.l (A3)+,(A4)+
 	move.l (A3)+,(A4)+

; -------------------------------------------------------------
; * Update les adresses Source/cible pour la ligne en dessous *
; ------------------------------------------------------------- 	
 	add.l #160-8,A3
 	add.l #160-8,A4
 	
; --------------------- 	
; * Test de la boucle *
; --------------------- 
	dbf D0,.copy
 
 
	rts
	
; ====================
; *     Draw Map     *
; ====================          
F_DRAW_MAP:	
	
; ----------------------------------
; - Initiation de MAP_PX et MAP_PY -
; ----------------------------------
	move.l #0,MAP_PX
    move.l #0,MAP_PY
   
.BC  
; --------------------------------
; - Affichage d'une ligne (case) -
; --------------------------------
	move.l #1,D0         ; Init id tiles(D0)
	move.l MAP_PX,D3     ; Init PX (D3)
	move.l MAP_PY,D4     ; Init PY (D4)
	jsr    F_DRAW_TILES  ; Draw Tiles
  
; --------------------------------------  
; - Test si on est au bout de la ligne -
; --------------------------------------
	add.l #1,MAP_PX ; inc px
	cmp.l #8,MAP_PX ; Tester si on afficher 8 cases
    bne   .BC       ; Retour … BC pour la prochaine case H

; ----------------------
; - Next Ligne et Test -
; ----------------------  
    move.l #0,MAP_PX ;Remise … 0 Map PX
    add.l  #1,MAP_PY ; inc MAP_PY
    cmp.l  #8,MAP_PY ; Tester si on a les 8 lignes (case)
    bne   .BC        ; Retour … BC Pour afficher la prochaine ligne 

; ----------
; - Return -
; ----------
	rts ; return 