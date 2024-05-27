@echo off
echo **********************************************
echo * Programmation ASM VBCC                       *
echo * Atari st                                     *                      
echo * ASM 68000                                    *
echo **********************************************

set as=..\vbcc\bin\vasmm68k_mot.exe
set source=SRC\
set entry=HFKINGSW.ASM
set out=d7\
set prg=game.prg

if exist D7\game.prg del D7\game.prg
%AS% %source%%entry% -Ftos -o %out%%prg%

pause