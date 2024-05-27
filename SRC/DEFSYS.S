; **************************
; *      Define System     *
; * ---------------------- *
; * ASM ......: Devpac 3   *
; * CPU ......: M6800      *
; * Cible ....: Atari ST   *
; **************************

; ===================
; * Define Workflow *
; ===================
D_TITLE_SCREEN = 0
D_GAME_MAP     = 1
D_GAME_OVER    = 2
D_INTRODUCTION = 3
D_QUIT         = 4

; ================
; * Define Input *
; ================

; -------------------
; * Touche Scancode *
; -------------------
D_S_ESC    = $01
D_S_LEFT   = $4B
D_S_RIGHT  = $4D
D_S_UP     = $45
D_S_DOWN   = $50
D_S_ACTION = $10

; -----------------------
; * Direction Generique *
; -----------------------
D_LEFT   =  4
D_RIGHT  =  6
D_UP     =  8
D_DOWN   =  2
D_ESC    = 10
D_ACTION = 20