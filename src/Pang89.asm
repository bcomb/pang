;//////////////////////////////////////////////////////
;/////////////////////PANG V1.01///////////////////////
;//////////////////////////////////////////////////////
;VERSION DOORS OS pour ti89
;Compiler avec DoorsOS II v0.96 (AMS 2.0x)

	include "doorsOS.h"
	include "graphlib.h"
	include "userlib.h"
		xdef _ti89
		xdef _main
		xdef _comment

;******************************************************
;*********************Les macros***********************
;******************************************************
WriteTxt MACRO
	move.w  \4,-(a7)
	pea     \1(pc)
	move.w  \3,-(a7)
	move.w  \2,-(a7)
	jsr     doorsos::DrawStrXY
	lea     10(a7),a7
	ENDM

;*****************************************************
Police MACRO
	move.w  \1,-(a7)
	jsr	  doorsos::FontSetSys
	lea	  2(a7),a7
	ENDM

;*****************************************************
WriteStrA1 MACRO
	move.w  \3,-(a7)
	move.l  \4,-(a7)
	move.w  \2,-(a7)
	move.w  \1,-(a7)
	jsr doorsos::DrawStrXY
	lea	 10(a7),a7
	ENDM

;*****************************************************
;*********************Le programme********************
;*****************************************************
_main:
	clr.w   -(a7)
	jsr     doorsos::ST_busy
	lea     2(a7),a7

	move.l  #3840,-(a7)			;place pour BUFFER
 	jsr     doorsos::HeapAllocThrow
	lea     4(a7),a7
 	move.w  d0,hnum
 	doorsos::DEREF d0,a0
 	move.l  a0,hptr				;hptr pointe sur l'handle (BUFFER)

;**********on effece le buffer*********
	move.l	hptr,a1
	move.w	#120,d0
ClearBuf0:
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.w		(a1)+
	dbra.w	d0,ClearBuf0

;*******Defile le texte d'intro*********
	move.w		#0,perdu
	jsr		graphlib::clr_scr2

	move.w		#55,d3

DefilTitre:
	move.w		d3,d1
	lea		titre(PC),a1
	bsr		AfficheTitre

	move.w		#4000,d7
wait0:
	nop
	nop
	nop
	dbra.w		d7,wait0

	sub.w		#1,d3
	cmp.w		#0,d3
	bne		DefilTitre

	jsr		graphlib::clr_scr2
	move.w		#0,d1
	lea		titre(PC),a1
	bsr		AfficheTitre
	Police		#0
	WriteTxt	pub,#0,#95,#4
	Police		#2
	move.w  	#1,a3
;***************Menu d'intro******************
menu:
	cmp.w    #1,a3
	bne  	non1
	move.w  #0,a0
	move.w  #4,a5
	move.w  #4,a2
non1:
	cmp.w   	#2,a3
	bne  	non2
	move.w  #4,a0
	move.w  #0,a5
	move.w  #4,a2
non2:
	cmp.w    #3,a3
	bne  	non3
	move.w  #4,a0
	move.w  #4,a5
	move.w  #0,a2
non3:
	WriteTxt  MenuTxt1,#48,#60,a0
	WriteTxt  MenuTxt2,#48,#70,a5
	WriteTxt  MenuTxt3,#48,#80,a2

	jsr userlib::idle_loop 	                 ;attend l'appuy d'une touche
	cmp.w	#264,d0                   	   	   ;test de la touche echap
	beq     	fin2

	cmp.w	#KEY_DOWN,d0		                  ;test de la touche bas
	bne     	non_bas
	add.w	#1,a3
non_bas:
	cmp     #KEY_UP,d0                      ;test de la touche haut
	bne     non_haut
		sub.w   #1,a3
non_haut:
	cmp     #13,d0
	beq     end_menu

	cmp     #0,a3                        ;test si le curseur du menu depasse en haut
	bne     test1_ok
		move.w   #3,a3
test1_ok:
	cmp     #4,a3                        ;test si le curseur du menu depasse en bas
	bne     test2_ok
		move.w   #1,a3
test2_ok:

	bra     menu


end_menu:                                  ;Le joueur a appuyer sur entrer
	cmp     #1,a3                        ;le joueur a choisi depart ?
	beq     game_start
	cmp     #2,a3                        ;le joueur a choisi option ?
	beq     game_option
	cmp     #3,a3                        ;le joueur a choisi aide ?
	beq     game_help

;****************Menu option*************
game_option:                               ;gere le menu option
	jsr		graphlib::clr_scr2
	WriteTxt	opetoil,#48,#0,#4
	WriteTxt	option0,#48,#9,#4
	WriteTxt	opetoil,#48,#18,#4
	WriteTxt	option1,#0,#36,#4
	move.w	#1,a3
	lea	 	tmpstr+5(PC),a0
	move.w 	vitesseop,d0
	bsr 		ConvStr
	WriteStrA1 	#100,#73,#4,a0
option_boucle:
	cmp.w    #1,a3
	bne  	non1_1
		move.w  #0,a0
		move.w  #4,a5
		move.w  #4,a2
non1_1:
	cmp.w   	#2,a3
	bne  	non2_1
		move.w	#4,a0
		move.w	#0,a5
		move.w	#4,a2
non2_1:
	cmp.w    #3,a3
	bne  	non3_1
		move.w	#4,a0
		move.w	#4,a5
		move.w	#0,a2
non3_1:
	WriteTxt	option2,#0,#46,a0
	WriteTxt	option3,#0,#56,a5
	WriteTxt	option4,#0,#72,a2

	cmp.w		#1,apou
	bne		non_aleatoire_0
	WriteTxt 	optxt1,#88,#46,#4
non_aleatoire_0:

	cmp.w		#0,apou
	bne		non_aleatoire
	WriteTxt 	optxt0,#88,#46,#4
non_aleatoire:

	cmp.w		#0,aptaille
	bne		non_aptaille0
	WriteTxt 	optxt0,#88,#56,#4
non_aptaille0:

	cmp.w		#1,aptaille
	bne		non_aptaille1
		WriteTxt	taille8,#88,#56,#4
non_aptaille1:
	cmp.w		#2,aptaille
	bne		non_aptaille2
		WriteTxt	taille16,#88,#56,#4
non_aptaille2:
	cmp.w		#3,aptaille
	bne		non_aptaille3
		WriteTxt	taille32,#88,#56,#4
non_aptaille3:
no_refresh:
	jsr		userlib::idle_loop
	cmp.w	#KEY_DOWN,d0		             ;test de la touche bas
	bne     	non_bas_1
	add.w	#1,a3
non_bas_1:
	cmp     #KEY_UP,d0                      ;test de la touche haut
	bne     non_haut_1
		sub.w   #1,a3
non_haut_1:
	cmp     #0,a3                        ;test si le curseur du menu depasse en haut
	bne     test1_ok_1
		move.w   #3,a3
test1_ok_1:
	cmp     #4,a3                        ;test si le curseur du menu depasse en bas
	bne     test2_ok_1
		move.w   #1,a3
test2_ok_1:

	cmp.w	#KEY_RIGHT,d0				;test droite
	bne	test3_ok
	cmp.w		#3,a3
	bne		non_vit_1
	cmp.w		#10501,vitesseop
	beq		test3_ok
	add.w		#10,vitesseop
	WriteTxt	blanc,#100,#73,#4
	lea	 	tmpstr+5(PC),a0
	move.w 	vitesseop,d0
	bsr 		ConvStr
	WriteStrA1 	#100,#73,#4,a0
non_vit_1:
	cmp.w		#2,a3
	bne		non_tai_1
	cmp.w		#3,aptaille
	beq		non_tai_1
		add.w		#1,aptaille
		bra		test3_ok
non_tai_1:
	cmp.w		#1,a3
	bne		non_app_1
	cmp.w		#1,apou
	beq		non_app_1	
		add.w		#1,apou
		bra		test3_ok
non_app_1:

	bra		no_refresh
test3_ok:

	cmp.w	#KEY_LEFT,d0				;teste gauche
	bne	test4_ok
	cmp.w		#3,a3
	bne		non_vit_2
	cmp.w		#501,vitesseop
	beq		test4_ok
	sub.w		#10,vitesseop
	WriteTxt	blanc,#100,#73,#4
	lea	 	tmpstr+5(PC),a0
	move.w 	vitesseop,d0
	bsr 		ConvStr
	WriteStrA1 	#9,#73,#4,a0
non_vit_2:
	cmp.w		#2,a3
	bne		non_tai_2
	cmp.w		#0,aptaille
	beq		non_tai_2
		sub.w		#1,aptaille
		bra		test4_ok
non_tai_2:
	cmp.w		#1,a3
	bne		non_app_2
	cmp.w		#0,apou
	beq		non_app_2
		sub.w		#1,apou
		bra		test4_ok
non_app_2:
	bra		no_refresh
test4_ok:



	cmp.w		#264,d0
	bne		option_boucle

	move.w 	hnum,-(a7)			;On supprime le BUFFER
 	jsr     	doorsos::HeapFree
	add.l		#2,a7

	bra     	_main

;****************Affiche l'aide*************
game_help:                                 ;gere le menu aide

	jsr		graphlib::clr_scr2
	WriteTxt	aide0,#52,#2,#4
	Police	#1

	WriteTxt	aide1,#0,#15,#4
;	WriteTxt	aide2,#0,#24,#4

	WriteTxt	aide3,#0,#63,#4
	WriteTxt	aide4,#0,#72,#4
	jsr		userlib::idle_loop

	move.w 	hnum,-(a7)			;On supprime le BUFFER
 	jsr     	doorsos::HeapFree
	add.l		#2,a7
	bra     _main

;********************DEBUT DU PROGRAMME***************
game_start:

;****************Initialisation des variables*********
	move.w	#$700,d0				      ;coupe l'interruption clavier
	TRAP    	#1
	move.w 	#%1111111111111110,$600018		;active la 1er ligne
	nop
	nop
	nop
	nop
	nop
	nop

	move.w	#100,apparition
	move.w	#400,apparition2
	move.w	vitesseop,d0
	move.w	d0,vitesse		;Change cette valeur pour changer la vitesse(min=501 max=10501)
	move.w	#0,perdu		;Conseil 501 pour une Ti92 et 5501 pour une Ti92+
	move.w	#0,levelplus

	move.w	#0,compteurjoueur
	move.w	#0,droitejoueur
	move.w	#1,incrnumero
	move.w	#0,tiron
	move.w	#0,tiron2
	move.w	#0,atontirer

	move.w	#0,score
	move.w	#10,nbcasse
	move.w	#1,level

	move.w	#104,xpang
	move.w	#84,ypang

	jsr	graphlib::clr_scr2

	Police	#0
	WriteTxt  BarreJeu,#0,#95,#4

	lea	 	tmpstr+5(PC),a0
	move.w 	score,d0
	bsr 		ConvStr
	WriteStrA1 	#25,#95,#4,a0

	lea	 	tmpstr+5(PC),a0
	move.w 	level,d0
	bsr 		ConvStr
	WriteStrA1 	#77,#95,#4,a0

	lea	 	tmpstr+5(PC),a0
	move.w 	hiscore,d0
	bsr 		ConvStr
	WriteStrA1 	#130,#95,#4,a0

;************Efface la matrice qui gere les balles********
	lea		matrice(PC),a0
	move.w	#207,d0
clearniv:
	move.w	#0,(a0)+
	dbra.w	d0,clearniv



boucle_jeu:

;*****************On patiente un peu************

	move.w	vitesse,d0
wait:
	dbra.w	d0,wait

;*****************Creation d'une boule******************
	sub.w		#1,apparition
	cmp.w		#0,apparition
	bne		pas_apparaitre

	move.w	apparition2,d0
	move.w	d0,apparition

;recherche d'un emplacement vide
		move.w	#0,lignemat2
apparaitre:
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat2,d0
	lsl.w		#5,d0
	adda.l	d0,a0

	move.w	(a0),d0
	add.w		#1,lignemat2
	cmp.w		#13,lignemat2
	beq		pas_apparaitre
	tst.w		d0
	bne		apparaitre

	sub.w		#1,lignemat2
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat2,d0
	lsl.w		#5,d0
	adda.l	d0,a0

	move.w	aptaille,d1
	cmp.w		#0,d1
	bne		non_alea_taille
		move.w	#3,d0
		jsr		userlib::random
		move.w	d0,d1
		add.w		#1,d1		
non_alea_taille:
	move.w	#2,d0
	jsr		userlib::random
	move.w	d0,d2

	cmp.w		#1,d1
	beq		apparaitre1
	cmp.w		#2,d1
	beq		apparaitre2
apparaitre3:
	move.w	#104,d3
	cmp.w		#0,apou
	bne		non_apou_3
		move.w	#118,d0
		jsr		userlib::random
		move.w	d0,d3
		add.w		#5,d3
non_apou_3:
		move.w	#3,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#0,(a0)+
		move.w	#37,(a0)+
		move.w	d2,(a0)+
		move.w	d3,(a0)+
		move.w	#119,(a0)+
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		bra		pas_apparaitre
apparaitre2:
	move.w	#112,d3
	cmp.w		#0,apou
	bne		non_apou_2
		move.w	#134,d0
		jsr		userlib::random
		move.w	d0,d3
		add.w		#5,d3
non_apou_2:
		move.w	#2,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#0,(a0)+
		move.w	#32,(a0)+
		move.w	d2,(a0)+
		move.w	d3,(a0)+
		move.w	#119,(a0)+
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		bra		pas_apparaitre
apparaitre1:
	move.w	#116,d3
	cmp.w		#0,apou
	bne		non_apou_1
		move.w	#142,d0
		jsr		userlib::random
		move.w	d0,d3
		add.w		#5,d3
non_apou_1:
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#0,(a0)+
		move.w	#26,(a0)+
		move.w	d2,(a0)+
		move.w	d3,(a0)+
		move.w	#119,(a0)+
		move.w	#1,(a0)+
		move.w	#0,(a0)+
pas_apparaitre:
;******************Gestion des touches******************
	move.w  #%1111111111111110,$600018		;active la 1er ligne
	nop
	nop
	nop
	nop
	nop
	nop

	btst  #3,$60001B
	bne   droite_non					;teste la touche droite
		cmp.w	#138,xpang
			bhi	droite_non
			add.w		#1,xpang
			move.w	#1,droitejoueur
			cmp.w		#0,tiron
			bne		gauche_non
			add.w		#2,compteurjoueur			
			cmp.w		#13,compteurjoueur
			bne		non_7d
				move.w	#3,incrnumero
		non_7d:
			bra	gauche_non
droite_non:

	btst  #1,$60001B
	bne   gauche_non					;teste la touche gauche
		cmp.w		#0,xpang
		bls		gauche_non
			sub.w		#1,xpang
			move.w	#0,droitejoueur
			cmp.w		#0,tiron
			bne		gauche_non
			add.w		#2,compteurjoueur
			cmp.w		#13,compteurjoueur			
			bne		non_7g
				move.w	#3,incrnumero
		non_7g:
gauche_non:


	cmp.w		#0,tiron2
	beq		tirnon0
	btst		#4,$60001B
	beq		tir_non				;teste la touche hand
		move.w	#0,tiron2
tirnon0:

	cmp.w		#1,atontirer
	beq		tir_non

	btst		#4,$60001B
	bne		tir_non
		move.w	#20,tiron		;dure ou pang reste en position de tir
		move.w	#1,tiron2
		move.w	#1,atontirer
		move.w	#78,ytir
		move.w	xpang,d0
		add.w		#11,d0
		move.w	d0,xtir
		sub.w		#500,vitesse
tir_non:

	sub.w		#1,tiron
	cmp.w		#0,tiron
	bgt		tir_off
		move.w	#0,tiron
tir_off:


	tst.w		tiron
	beq		tir_on1
		move.w	#4,d0
		bra		tir_on2
tir_on1:

	move.w	compteurjoueur,d0
	sub.w		incrnumero,d0
	move.w	d0,compteurjoueur

	cmp.w		#0,compteurjoueur
	bgt		label0
		move.w	#0,compteurjoueur
		move.w	#1,incrnumero
label0:

;**************Affichage du joueur**************
	move.w	compteurjoueur,d0
	add.w		#3,d0
	lsr.w		#2,d0

tir_on2:
	cmp.w		#0,droitejoueur
	beq		non_joueur_a_gauche

	cmp.w		#0,d0
	bne		label
		lea		pangsr(PC),a1
label:
	cmp.w		#1,d0
	bne		label1
		lea		pangr1(PC),a1
label1:
	cmp.w		#2,d0
	bne		label2
		lea		pangr2(PC),a1
label2:
	cmp.w		#3,d0
	bne		label3
		lea		pangr3(PC),a1
label3:
	cmp.w		#4,d0
	bne		label4
		lea		pangtr(PC),a1
label4:

	bra		findirection	

non_joueur_a_gauche:
	cmp.w		#0,d0
	bne		labell
		lea		pangsl(PC),a1
labell:
	cmp.w		#1,d0
	bne		label01
		lea		pangl1(PC),a1
label01:
	cmp.w		#2,d0
	bne		label02
		lea		pangl2(PC),a1
label02:
	cmp.w		#3,d0
	bne		label03
		lea		pangl3(PC),a1
label03:
	cmp.w		#4,d0
	bne		label04
		lea		pangtl(PC),a1
label04:

findirection:
	move.w	xpang,d0
	move.w	ypang,d1
	bsr		DrawSprite32
;*****************Affichage du tir***************
	cmp.w		#0,atontirer
	beq		on_a_pas_tirer

	move.w	xtir,d0
	move.w	ytir,d1
	lea		harpon(PC),a1
	bsr		DrawSprite16

	move.w	ytir,d0
	add.w		#11,d0
	move.w	d0,d7
	move.w	#121,d1
	sub.w		d7,d1
	move.w	d1,d2
	lsr.w		#4,d1
	move.w	d1,d4
	lsl.w		#4,d1
	move.w	d1,d3
	sub.w		d3,d2
	move.w	d2,ligne
	move.w	d4,ligne2

fortir:
	move.w	xtir,d0
	move.w	d7,d1
	lea		lasset(PC),a1
	bsr		DrawSprite16
	add.w		#16,d7
	sub.w		#1,ligne2
	cmp.w		#0,ligne2
	bne		fortir

	cmp.w		#0,ligne
	bgt		non_ligne_neg
		bra	non_ligne_neg2
non_ligne_neg:
	move.w	xtir,d0
	move.w	d7,d1
	lea		lasset(PC),a1
	bsr		DrawPartieSprite16

non_ligne_neg2:

	sub.w		#2,ytir

	cmp.w		#0,ytir
	bgt		on_a_pas_tirer
		move.w	#0,atontirer
		add.w		#500,vitesse
on_a_pas_tirer:
;***************Gestion de la matrice************
	move.w	#0,lignemat
matricenumero:
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat,d0
	lsl.w		#5,d0
	adda.l	d0,a0

	move.w	(a0)+,styleballe

	tst.w		styleballe
	beq		no_balle

	move.w	(a0)+,t
	move.w	(a0)+,vy0neg
	move.w	(a0)+,x
	move.w	(a0)+,y
	move.w	(a0)+,vx0
	move.w	(a0)+,vx1
	move.w	(a0)+,vy0
	move.w	(a0)+,vy1
	move.w	(a0)+,dirballe
	move.w	(a0)+,x0
	move.w	(a0)+,y0
	move.w	(a0)+,m
	move.w	(a0)+,y2

	cmp.w		#1,styleballe
	bne		non_style1
		move.w	#8,r
non_style1:
	cmp.w		#2,styleballe
	bne		non_style2
		move.w	#16,r
non_style2:
	cmp.w		#3,styleballe
	bne		non_style3
		move.w	#32,r
non_style3:

;**************Equation de la balle**************
	move.w	vx0,d0
	mulu		t,d0
	lsr.w		#3,d0				;d0=vx0*t/8		(non signe)
	tst.w		dirballe
	bne		balledroite			;si vx0<0 alors d0 aussi
		neg.w	d0				;d0=vx0*t/8		(signe)

balledroite:
	add.w		x0,d0
	move.w	d0,x				;x=(vx0*t)/8+x0	(signe)
	move.w	t,d0
	mulu		t,d0
	lsr.w		#4,d0
	move.w	d0,tt0			;tt0=(t*t)/16
	move.w	vy0,d0
	mulu		t,d0
	lsr.w		#3,d0				;d0=vy0*t/8		(non signe)
	tst.w		vy0neg
	bne		nonpos1			;si vy0<0 alors d0 aussi
		neg.w	d0				;d0= (vy0*t)/8	(signe)
nonpos1:
	add.w		y0,d0
	sub.w		tt0,d0
	move.w	d0,y				;y=y0+d0-tt0	(d0=tt1)
	move.w	#119,d0
	sub.w		y,d0
	move.w	d0,y2				;y2=119-y (on inverse l'ordonnee de la balle)

	move.w	t,d0
	add.w		m,d0
	move.w	d0,t				;t=t+m

;On verifie si la balle touche le sol
	move.w	y2,d0
	add.w		r,d0
	cmp.w		#119,d0			;si y2+r>119 alors la balle touche le sol
	bls		nony0
		move.w	x,x0			;x0=x
		move.w	r,y0			
		add.w		#1,y0			;y0=r+1
		move.w	#121,d0
		sub.w		r,d0
		move.w	d0,y2			;y2=121-y
		move.w	#0,t			;t=0
		move.w	vy1,vy0		;vy0=vy1
		move.w	#1,vy0neg		;vy0 n'est pas negatif puisque la balle rebondit
nony0:

;On verifie que la balle ne depasse le bord droit
	move.w	x,d0
	add.w		r,d0
	cmp.w		#159,d0			;si x+r>239 alors on touche le bord droit
	bls		nonxg
		move.w	m,d0
		mulu		t,d0
		move.w	vy0,d1
		sub.w		d0,d1
		move.w	d1,vy0		;vy0=vy0-m*t  (signe)
		move.w	#159,d0
		sub.w		r,d0
		move.w	d0,x0			;x0=239-r
		move.w	y,y0			;y0=y
		move.w	#0,t			;t=0
		move.w	#0,dirballe		;la balle va a gauche donc dirballe=0
		move.w	#1,vy0neg
		cmp.w		#0,vy0
		bgt		nonvy0p1		;vy0 est-il negatif?
			move.w	#0,vy0neg
			neg.w		vy0		;vy0=vy0-m*t  (non signe)
		nonvy0p1:
nonxg:

;On verifie que la balle ne depasse le bord gauche
	cmp.w	#0,x
	bgt	nonxp					;si x<0 alors la balle touche le bord gauche
		move.w	m,d0
		mulu		t,d0
		move.w	vy0,d1
		sub.w		d0,d1
		move.w	d1,vy0		;vy0=vy0-m*t  (signe)
		move.w	#1,x0			;x0=1
		move.w	y,y0			;y0=y
		move.w	#0,t			;t=0
		move.w	#1,dirballe		;la balle va a droite donc dirballe=1
		move.w	#1,vy0neg
		cmp.w		#0,vy0
		bgt		nonvy0p2		;vy0 est-il negatif?
			move.w	#0,vy0neg	
			neg.w		vy0		;vy0=vy0-m*t  (non signe)
		nonvy0p2:
nonxp:		
;On verifie que la balle ne monte pas trop haut
	cmp.w		#0,y2
	bgt		nonyg
		move.w	#0,y2			;y2=0
		move.w	#118,y0		;y=118
		move.w	#0,t			;t=0
		move.w	#0,vy0		;vy0=0
		move.w	#1,vy0neg		;pas negatif
		move.w	x,x0			;x0=x
nonyg:

	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat,d0
	lsl.w		#5,d0
	adda.l	d0,a0


	tst.w		atontirer
	beq		non_collision

;*****************Test des collisions avec le harpon************

	move.w	x,d0				;d0=xballe
	move.w	r,d1
	add.w		x,d1				;d1=r+xballe
	sub.w		#7,d0				;d0=xballe+7
	move.w	y2,d2
	add.w		r,d2				;d2=yballe+r

	cmp.w		xtir,d1
	blt		non_collision		;si xballe+r>=xtir  alors il y a peut etre une colision
	cmp.w		xtir,d0			
	bgt		non_collision		;si xballe-7<=xtir  alors il y a peut etre une colision
	cmp.w		ytir,d2
	blt		non_collision		;si yballe+r>=ytir  alors il y a peut etre une colision
;si les 3 conditions sont justes alors il y a collision

	cmp.w		#3,styleballe
	bne		non_style_3
		move.w	x,d0			;d0=x de la 1ere balle
		move.w	y2,d1			
		add.w		#3,d1			;d1=y de la 1ere et de la 2eme balle
		move.w	#120,d2
		sub.w		d1,d2			;d2=y2 de la 1ere et de la 2eme balle

		move.w	a0,a3
		move.w	#2,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	d0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#28,(a0)+
		move.w	#32,(a0)+
		move.w	#0,(a0)+
		move.w	x,(a0)+
		move.w	d2,(a0)+
		move.w	#1,(a0)+
		move.w	d1,(a0)+

;recherche d'un emplacement vide
		move.w	#0,lignemat2
matricenumero2:
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat2,d0
	lsl.w		#5,d0
	adda.l	d0,a0
	move.w	(a0),d0
	add.w		#1,lignemat2
	cmp.w		#13,lignemat2
	beq		non_collision
	cmp.w		#0,d0
	bne		matricenumero2
	sub.w		#1,lignemat2


;creation de la balle 2
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat2,d0
	lsl.w		#5,d0
	adda.l	d0,a0

		move.w	x,d0			;d0=x de la 1ere balle
		add.w		#16,d0
		move.w	#2,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	d0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#28,(a0)+
		move.w	#32,(a0)+
		move.w	#1,(a0)+
		move.w	d0,(a0)+
		move.w	d2,(a0)+
		move.w	#1,(a0)+
		move.w	d1,(a0)+

		add.w		#500,vitesse
		move.w	#0,atontirer

		move.w	level,d0
		lsl.w		#2,d0
		add.w		d0,score

		lea	 	tmpstr+5(PC),a0
		move.w 	score,d0
		bsr 		ConvStr
		WriteStrA1 	#25,#95,#4,a0

	sub.w		#1,nbcasse
	tst.w		nbcasse
	bne		non_pas_plus_vite_1
		add.w		#1,level
		lea	 	tmpstr+5(PC),a0
		move.w 	level,d0
		bsr 		ConvStr
		WriteStrA1 	#77,#95,#4,a0
		move.w	#25,levelplus
		move.w	#10,nbcasse
		sub.w		#10,apparition2
		cmp.w		#21,apparition2
		bgt		non_pas_plus_vite_1
		move.w	#30,apparition2
non_pas_plus_vite_1:

		bra		no_balle
non_style_3:	

	cmp.w		#2,styleballe
	bne		non_style_2
		move.w	x,d0			;d0=x de la 1ere balle
		move.w	y2,d1			
		add.w		#3,d1			;d1=y de la 1ere et de la 2eme balle
		move.w	#120,d2
		sub.w		d1,d2			;d2=y2 de la 1ere et de la 2eme balle

		move.w	#1,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	d0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#28,(a0)+
		move.w	#26,(a0)+
		move.w	#0,(a0)+
		move.w	x,(a0)+
		move.w	d2,(a0)+
		move.w	#1,(a0)+
		move.w	d1,(a0)+

;recherche d'un emplacement vide
		move.w	#0,lignemat2
matricenumero2_1:
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat2,d0
	lsl.w		#5,d0
	adda.l	d0,a0
	move.w	(a0),d0
	add.w		#1,lignemat2
	cmp.w		#13,lignemat2
	beq		non_collision
	cmp.w		#0,d0
	bne		matricenumero2_1
	sub.w		#1,lignemat2


;creation de la balle 2
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat2,d0
	lsl.w		#5,d0
	adda.l	d0,a0
		move.w	x,d0			;d0=x de la 1ere balle
		add.w		#8,d0
		move.w	#1,(a0)+
		move.w	#0,(a0)+
		move.w	#1,(a0)+
		move.w	d0,(a0)+
		move.w	#0,(a0)+
		move.w	#8,(a0)+
		move.w	#8,(a0)+
		move.w	#28,(a0)+
		move.w	#26,(a0)+
		move.w	#1,(a0)+
		move.w	d0,(a0)+
		move.w	d2,(a0)+
		move.w	#1,(a0)+
		move.w	d1,(a0)+
		move.w	#0,atontirer
		add.w		#500,vitesse

		move.w	level,d0
		lsl.w		#1,d0
		add.w		d0,score

		lea	 	tmpstr+5(PC),a0
		move.w 	score,d0
		bsr 		ConvStr
		WriteStrA1 	#25,#95,#4,a0

	sub.w		#1,nbcasse
	tst.w		nbcasse
	bne		non_pas_plus_vite_2
		add.w		#1,level
		lea	 	tmpstr+5(PC),a0
		move.w 	level,d0
		bsr 		ConvStr
		WriteStrA1 	#77,#95,#4,a0
		move.w	#25,levelplus
		move.w	#10,nbcasse
		sub.w		#10,apparition2
		cmp.w		#21,apparition2
		bgt		non_pas_plus_vite_2
		move.w	#30,apparition2
non_pas_plus_vite_2:

		bra		no_balle
non_style_2:	

	cmp.w		#1,styleballe
	bne		non_style_1
		move.w	#0,(a0)
		add.w		#500,vitesse	
		move.w	#0,atontirer

		move.w	level,d0
		add.w		d0,score

		lea	 	tmpstr+5(PC),a0
		move.w 	score,d0
		bsr 		ConvStr
		WriteStrA1 	#25,#95,#4,a0

	sub.w		#1,nbcasse
	tst.w		nbcasse
	bne		non_pas_plus_vite_3
		add.w		#1,level
		lea	 	tmpstr+5(PC),a0
		move.w 	level,d0
		bsr 		ConvStr
		WriteStrA1 	#77,#95,#4,a0
		move.w	#25,levelplus
		move.w	#10,nbcasse
		sub.w		#10,apparition2
		cmp.w		#21,apparition2
		bgt		non_pas_plus_vite_3
		move.w	#30,apparition2
non_pas_plus_vite_3:

		bra		no_balle
non_style_1:	


non_collision:
;*****************Test des collisions avec le joueur************

	move.w	x,d0				;d0=xballe
	move.w	r,d1
	add.w		x,d1				;d1=r+xballe
	sub.w		#7,d1
	sub.w		#15,d0			;d0=xballe-15
	move.w	y2,d2
	add.w		r,d2				;d2=yballe+r
	sub.w		#17,d2	      	;d2=yballe+r-14

	cmp.w		ypang,d2
	blt		non_collision2		;si xballe+r>=xtir  alors il y a peut etre une colision
	cmp.w		xpang,d1			
	blt		non_collision2		;si xballe-7<=xtir  alors il y a peut etre une colision
	cmp.w		xpang,d0
	bgt		non_collision2		;si yballe+r>=ytir  alors il y a peut etre une colision
		move.w	#1,perdu
;si les 3 conditions sont justes aolrs il y a collision

non_collision2:
;************************************************************

	move.w	styleballe,(a0)+
	move.w	t,(a0)+
	move.w	vy0neg,(a0)+
	move.w	x,(a0)+
	move.w	y,(a0)+
	move.w	vx0,(a0)+
	move.w	vx1,(a0)+
	move.w	vy0,(a0)+
	move.w	vy1,(a0)+
	move.w	dirballe,(a0)+
	move.w	x0,(a0)+
	move.w	y0,(a0)+
	move.w	m,(a0)+
	move.w	y2,(a0)

no_balle:
		add.w		#1,lignemat
		cmp.w		#13,lignemat
		bne		matricenumero	
;*************Affichage des balles*************

	move.w	#0,lignemat
afficheballe:
	lea	matrice(PC),a0
	clr.l		d0
	move.w	lignemat,d0
	lsl.w		#5,d0
	adda.l	d0,a0	

	move.w	(a0)+,styleballe
	tst.w		styleballe
	beq		no_balle2

	lea		4(a0),a0
	move.w	(a0),d0
	lea		20(a0),a0
	move.w	(a0),d1

;Quelle balle faut-il afficher
	cmp.w		#1,styleballe
	bne		non_styleballe1
		lea		balle1(PC),a1
		bsr		DrawSprite16
non_styleballe1:
	cmp.w		#2,styleballe
	bne		non_styleballe2
		lea		balle2(PC),a1
		bsr		DrawSprite16
non_styleballe2:
	cmp.w		#3,styleballe
	bne		non_styleballe3
		lea		balle3(PC),a1
		bsr		DrawSprite32
non_styleballe3:

no_balle2:

	add.w		#1,lignemat
	cmp.w		#13,lignemat
	bne		afficheballe

	tst.w		levelplus
	beq		no_level_plus
;Affiche LEVEL UP
		move.l	hptr,a0
		move.w	#11,d0
		adda.l	#1746,a0
		lea		levelup(PC),a1
	bouclelevelup:
		move.l	(a1)+,(a0)+
		move.l	(a1)+,(a0)
		lea		26(a0),a0
		dbra.w	d0,bouclelevelup
;****************
		sub.w		#1,levelplus
no_level_plus:

	move.w	#92,d0
	move.l	hptr,a0
	adda.l	#840,a0		;pour la ti89 seulement
	move.l	#LCD_MEM,a1
CopyBuf:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)+
	dbra.w	d0,CopyBuf

	move.l	hptr,a1
	move.w	#120,d0
ClearBuf:
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.l		(a1)+
	clr.w		(a1)+
	dbra.w	d0,ClearBuf
	
	cmp.w		#1,perdu
	beq		fin

;************************************************
	move.w	#%1111111110111111,$600018
	nop
	nop
	nop
	nop
	nop
	nop
;	btst		#5,$60001B
;	bne		nonveille
;		TRAP #4
;nonveille:

	btst		#0,$60001B
	bne		boucle_jeu

fin:                                       ;fin du programme
	move.w  	#0,d0
	TRAP    	#1   		             ;restore l'interruption clavier 

	Police	#2				 ;On retablit la grande police
	WriteTxt	GameOver,#36,#32,#0

	move.w	hiscore,d0
	cmp.w		score,d0
	bge		no_record
		WriteTxt	RecordBattue,#32,#50,#0
		move.w	score,d1
		move.w	d1,hiscore
no_record:
boucle_x:
	jsr userlib::idle_loop 	                 ;attend l'appuy d'une touche
	cmp.w		#13,d0
	bne		boucle_x

	move.w 	hnum,-(a7)			;On supprime le BUFFER
 	jsr     	doorsos::HeapFree
	add.l		#2,a7

	bra		_main
fin2:
	move.w 	hnum,-(a7)			;On supprime le BUFFER
 	jsr     	doorsos::HeapFree
	add.l		#2,a7
	rts
;*****************************************************
;****************Les Procedures***********************
;*****************************************************

;DrawSprite32: d0=x	d1=y
;d0 d1 d2 d3 d4 d5 d6 a0 a1 sont change
DrawSprite32:
	move.w	d1,d2				;multiplie d1 par 30
	lsl.w		#4,d1				;d1*16
	sub.w		d2,d1				;d1*16-d1=d1*15
	lsl.w		#1,d1				;d1*2=d1*30
	ext.l		d1				;transforme d1 en longword
	move.l	d1,a0				;a0 pointe sur la bonne ligne
	move.w 	d0,d2
	and.w 	#$F,d2
	move.w	d2,d3
	and.w 	#$FFF0,d0
	asr.w 	#3,d0
	ext.l 	d0
	adda.l 	d0,a0
	adda.l 	hptr,a0
	move.w	(a1)+,d2			;d2=nb de lignes
	tst.w	 	d3
	beq	 	AfficheRapide32
	cmp.w	 	#8,d3
	bhi	 	DecalDroite32

	move.w	#8,d6
	sub.w		d3,d6
DecalGauche32:
	move.l	(a1)+,d4
	move.w	d4,d5
	lsl.w		#8,d5
	lsl.w		d6,d5
	lsr.l		d3,d4
	or.l		(a0),d4
	move.l	d4,(a0)+
	or.w		(a0),d5
	move.w	d5,(a0)
	lea		26(a0),a0
	dbra.w	d2,DecalGauche32
	rts

DecalDroite32:
	move.l	(a1)+,d4
	clr.l		d5
	move.w	d4,d5
	lsl.l		#8,d5
	lsl.l		#8,d5
	lsr.l		d3,d5
	lsr.l		d3,d4
	or.l		(a0),d4
	move.l	d4,(a0)+
	or.w		(a0),d5
	move.w	d5,(a0)
	lea		26(a0),a0
	dbra.w	d2,DecalDroite32
	rts	

AfficheRapide32:
	move.l	(a1)+,d0
	or.l		(a0),d0
	move.l	d0,(a0)
	lea		30(a0),a0
	dbra.w	d2,AfficheRapide32
	rts
;***************************************************
; Puts a sprite onto the screen
; In 	A0 	Pointer to the sprite
;	D0.W 	X coordinate (0 - 239)
;	D1.W	Y coordinate
; Out 	Nothing
; We used SPRITES.ASM from David Ellsworth and modified it for a little bit

DrawSprite16:
	move.w d1,d2
	lsl.w #4,d1
	sub.w d2,d1
	lsl.w #1,d1
	ext.l d1
	move.l d1,a0		
	move.w d0,d2
	and.w #$F,d2
	and.w #$FFF0,d0
	asr.w #3,d0
	ext.l d0
	adda.l d0,a0		
	adda.l hptr,a0	
	tst.w d2
	beq QPut
	cmp.w #8,d2
	blt RShift
LShift:
	sub.w #16,d2
	neg.w d2
	move.w (a1)+,d3
LLoop:
	clr.l d1
	move.w (a1)+,d1
	lsl.l d2,d1
	or.l d1,(a0)
	lea 30(a0),a0
	dbra.w d3,LLoop
	rts
RShift:
	move.w (a1)+,d3
RLoop:
	clr.l d1
	move.w (a1)+,d1
	swap d1
	lsr.l d2,d1
	or.l d1,(a0)
	lea 30(a0),a0
	dbra.w d3,RLoop
	rts
QPut:
	move.w (a1)+,d3
QLoop:
	move.w (a1)+,d2	
	or.w d2,(a0)
	lea 30(a0),a0
	dbra.w d3,QLoop
	rts
;*****************************************************
DrawPartieSprite16:
	move.w d1,d2
	lsl.w #4,d1
	sub.w d2,d1
	lsl.w #1,d1
	ext.l d1
	move.l d1,a0		
	move.w d0,d2
	and.w #$F,d2
	and.w #$FFF0,d0
	asr.w #3,d0
	ext.l d0
	adda.l d0,a0		
	adda.l hptr,a0	
	tst.w d2
	beq QPutPartie
	cmp.w #8,d2
	blt RShiftPartie
LShiftPartie:
	sub.w #16,d2
	neg.w d2
	move.w ligne,d3
	lea	2(a1),a1
LLoopPartie:
	clr.l d1
	move.w (a1)+,d1
	lsl.l d2,d1
	or.l d1,(a0)
	lea 30(a0),a0
	dbra.w d3,LLoopPartie
	rts
RShiftPartie:
	move.w ligne,d3
	lea	2(a1),a1
RLoopPartie:
	clr.l d1
	move.w (a1)+,d1
	swap d1
	lsr.l d2,d1
	or.l d1,(a0)
	lea 30(a0),a0
	dbra.w d3,RLoopPartie
	rts
QPutPartie:
	move.w ligne,d3
	lea	2(a1),a1
QLoopPartie:
	move.w (a1)+,d2	
	or.w d2,(a0)
	lea 30(a0),a0
	dbra.w d3,QLoopPartie
	rts
;***************************************************
AfficheTitre:
	move.w	d1,d2			;multiplie d1 par 30
	lsl.w	#4,d1				;d1*16
	sub.w	d2,d1				;d1*16-d1=d1*15
	lsl.w	#1,d1				;d1*2=d1*30
	ext.l	d1				;transforme d1 en longword
	move.l	d1,a0			;a0 pointe sur la bonne ligne
	adda.l	#LCD_MEM,a0
	move.w	#54,d0
BoucleAfficheTitre:
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	adda.w	#10,a0
	dbra.w	d0,BoucleAfficheTitre
	rts

;*****************************************************
ConvStr:
	 movem.l	d0/d2,-(a7)
	 clr.b	(a0)
RepConv:
	 divu		#10,d0
	 move.l  	d0,d2
	 swap	 	d2
	 add.b	#48,d2
	 move.b  	d2,-(a0)
	 subq	 	#1,d1
	 and.l	#$FFFF,d0
	 bne 		RepConv
CS_Done:
	 movem.l	(a7)+,d0/d2
	 rts
;*****************************************************
;*******************Les Sprites***********************
;*****************************************************

;Matrice qui gere les 14 boules possibles du jeu
;		    balle?	t   vy0neg  x	y    vx0   vx1   vy0   vy1  balledroite  x0  y0 m
matrice	dc.w	1,0,1,0,0,8,8,26,26,1,220,20,1,0,0,0
		dc.w	2,0,1,0,0,8,8,32,32,1,150,60,1,0,0,0
		dc.w	3,0,1,0,0,9,9,37,37,1,20,40,1,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

pangl1	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000111000000000000000000
	dc.l	%00000000111111110000000000000000
	dc.l	%00010001111000111000000000000000
	dc.l	%00011011110010111100000000000000
	dc.l	%00010111011101001100000000000000
	dc.l	%00001101110101011110000000000000
	dc.l	%00011111111111011110000000000000
	dc.l	%00001111011101111111000000000000
	dc.l	%00000110110110110011110000000000
	dc.l	%00000010111000101011111000000000
	dc.l	%00000000011000001011100000000000
	dc.l	%00000011000000010110000000000000
	dc.l	%00000011001000011100000000000000
	dc.l	%00000001111100011100000000000000
	dc.l	%00111000110011111110000000000000
	dc.l	%00111010111111110011000000000000
	dc.l	%00000101000010110011000000000000
	dc.l	%01111111111111101011000000000000
	dc.l	%00111011110011000011000000000000
	dc.l	%00000110111001000110000000000000
	dc.l	%00001111111011111110000000000000
	dc.l	%00000111111111111110000000000000
	dc.l	%00000001101110000100000000000000
	dc.l	%00000000101111111000000000000000
	dc.l	%00000000111110011000000000000000
	dc.l	%00000000111111101100000000000000
	dc.l	%00000001111111011110000000000000
	dc.l	%00000001101110011110000000000000
	dc.l	%00000000111111111100000000000000

pangl2	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000111110000000000000000
	dc.l	%00000001011111111100000000000000
	dc.l	%00000011111110001110000000000000
	dc.l	%00000010111100101110000000000000
	dc.l	%00000011011101010111000000000000
	dc.l	%00000011010111100111000000000000
	dc.l	%00000111111110110111000000000000
	dc.l	%00000001110111011111100000000000
	dc.l	%00000001101101100101110000000000
	dc.l	%00000001100110001110111000000000
	dc.l	%00000001000110000100111000000000
	dc.l	%00000000110000000101100000000000
	dc.l	%00000000110010000110000000000000
	dc.l	%00001100111110001111000000000000
	dc.l	%00011111111001111110100000000000
	dc.l	%00110101101111111101110000000000
	dc.l	%00111000010000001111010000000000
	dc.l	%00010111111110011000110000000000
	dc.l	%00000111101101001000100000000000
	dc.l	%00000011011111011111000000000000
	dc.l	%00001111111111111110000000000000
	dc.l	%00011111110001001111100000000000
	dc.l	%00001001110101011011110000000000
	dc.l	%00000100010111111110110000000000
	dc.l	%00000010111011111111110000000000
	dc.l	%00000001111000011101100000000000
	dc.l	%00000000110000001111000000000000

pangl3	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000011100000000000000000
	dc.l	%00000100011111111000000000000000
	dc.l	%00000100111000011100000000000000
	dc.l	%00000011110011011110000000000000
	dc.l	%00000111110100100110000000000000
	dc.l	%00001100111110101111000000000000
	dc.l	%00001111111101111111000000000000
	dc.l	%00000011101111011111100000000000
	dc.l	%00000111011011001001110000000000
	dc.l	%00000011001100011100111100000000
	dc.l	%00000010001100000101111100000000
	dc.l	%00000001100000001011000000000000
	dc.l	%00000001101100001110000000000000
	dc.l	%00000001110000011100000000000000
	dc.l	%01100000111011111100000000000000
	dc.l	%01110101111110001110000000000000
	dc.l	%00101000101010010110000000000000
	dc.l	%11111111111100010110000000000000
	dc.l	%00011100101000011110000000000000
	dc.l	%00010110100000111100000000000000
	dc.l	%00111110111111111010110000000000
	dc.l	%01111111111110000111111000000000
	dc.l	%01011110011011111111111000000000
	dc.l	%00111101111111100110101000000000
	dc.l	%00010111000001100111001000000000
	dc.l	%00001111000000110111010000000000
	dc.l	%00000110000000011111110000000000
	dc.l	%00000000000000000011100000000000

pangr1	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000001110000000000000000000
	dc.l	%00000000111111110000000000000000
	dc.l	%00000001110001111000100000000000
	dc.l	%00000011110100111101100000000000
	dc.l	%00000011001011101110100000000000
	dc.l	%00000111101010111011000000000000
	dc.l	%00000111101111111111100000000000
	dc.l	%00001111111011101111000000000000
	dc.l	%00111100110110110110000000000000
	dc.l	%01111101010001110100000000000000
	dc.l	%00011101000001100000000000000000
	dc.l	%00000110100000001100000000000000
	dc.l	%00000011100001001100000000000000
	dc.l	%00000011100011111000000000000000
	dc.l	%00000111111100110001110000000000
	dc.l	%00001100111111110101110000000000
	dc.l	%00001100110100001010000000000000
	dc.l	%00001101011111111111111000000000
	dc.l	%00001100001100111101110000000000
	dc.l	%00000110001001110110000000000000
	dc.l	%00000111111101111111000000000000
	dc.l	%00000111111111111110000000000000
	dc.l	%00000010000111011000000000000000
	dc.l	%00000001111111010000000000000000
	dc.l	%00000001100111110000000000000000
	dc.l	%00000011011111110000000000000000
	dc.l	%00000111101111111000000000000000
	dc.l	%00000111100111011000000000000000
	dc.l	%00000011111111110000000000000000

pangr2	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000111110000000000000000000
	dc.l	%00000011111111101000000000000000
	dc.l	%00000111000111111100000000000000
	dc.l	%00000111010011110100000000000000
	dc.l	%00001110101011101100000000000000
	dc.l	%00001110011110101100000000000000
	dc.l	%00001110110111111110000000000000
	dc.l	%00011111101110111000000000000000
	dc.l	%00111010011011011000000000000000
	dc.l	%01110111000110011000000000000000
	dc.l	%01110010000110001000000000000000
	dc.l	%00011010000000110000000000000000
	dc.l	%00000110000100110000000000000000
	dc.l	%00001111000111110011000000000000
	dc.l	%00010111111001111111100000000000
	dc.l	%00111011111111011010110000000000
	dc.l	%00101111000000100001110000000000
	dc.l	%00110001100111111110100000000000
	dc.l	%00010001001011011110000000000000
	dc.l	%00001111101111101100000000000000
	dc.l	%00000111111111111111000000000000
	dc.l	%00011111001000111111100000000000
	dc.l	%00111101101010111001000000000000
	dc.l	%00110111111110100010000000000000
	dc.l	%00111111111101110100000000000000
	dc.l	%00011011100001111000000000000000
	dc.l	%00001111000000110000000000000000

pangr3	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000001110000000000000000000
	dc.l	%00000000111111110001000000000000
	dc.l	%00000001110000111001000000000000
	dc.l	%00000011110110011110000000000000
	dc.l	%00000011001001011111000000000000
	dc.l	%00000111101011111001100000000000
	dc.l	%00000111111101111111100000000000
	dc.l	%00001111110111101110000000000000
	dc.l	%00011100100110110111000000000000
	dc.l	%01111001110001100110000000000000
	dc.l	%01111101000001100010000000000000
	dc.l	%00000110100000001100000000000000
	dc.l	%00000011100001101100000000000000
	dc.l	%00000001110000011100000000000000
	dc.l	%00000001111110111000001100000000
	dc.l	%00000011100011111101011100000000
	dc.l	%00000011010010101000101000000000
	dc.l	%00000011010001111111111110000000
	dc.l	%00000011110000101001110000000000
	dc.l	%00000001111000001011010000000000
	dc.l	%00011010111111111011111000000000
	dc.l	%00111111000011111111111100000000
	dc.l	%00111111111110110011110100000000
	dc.l	%00101011001111111101111000000000
	dc.l	%00100111001100000111010000000000
	dc.l	%00010111011000000111100000000000
	dc.l	%00011111110000000011000000000000
	dc.l	%00001110000000000000000000000000

pangsl	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000110100000000000000000
	dc.l	%00000001000100100000000000000000
	dc.l	%00000011000110100000000000000000
	dc.l	%00000010100111110000000000000000
	dc.l	%00000111111110111100000000000000
	dc.l	%00000111110111101110000000000000
	dc.l	%00000011111110010110000000000000
	dc.l	%00000001110100110111000000000000
	dc.l	%00000001111010100101000000000000
	dc.l	%00000001111010001011100000000000
	dc.l	%00000001110100101011100000000000
	dc.l	%00000011111001010011100000000000
	dc.l	%00000111111110010111000000000000
	dc.l	%00000101111111111111000000000000
	dc.l	%00001011110111111111100000000000
	dc.l	%00001000111000010111100000000000
	dc.l	%00001001111111011110100000000000
	dc.l	%00001111111111111111000000000000
	dc.l	%00000101111111111110000000000000
	dc.l	%00000001111010111100000000000000
	dc.l	%00000011111111111100000000000000
	dc.l	%00000110101101111110000000000000
	dc.l	%00000111100001101010000000000000
	dc.l	%00000110011111111110000000000000
	dc.l	%00000100111110111010000000000000
	dc.l	%00001111110000011111000000000000
	dc.l	%00011000110000011111100000000000
	dc.l	%00110111110000111000110000000000
	dc.l	%00111111100000111111110000000000

pangsr	dc.w	36
	dc.l	%00000000000000000000000000000000
	dc.l  %00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000010110000000000000000000
	dc.l	%00000000010010001000000000000000
	dc.l	%00000000010110001100000000000000
	dc.l	%00000000111110010100000000000000
	dc.l	%00000011110111111110000000000000
	dc.l	%00000111011110111110000000000000
	dc.l	%00000110100111111100000000000000
	dc.l	%00001110110010111000000000000000
	dc.l	%00001010010101111000000000000000
	dc.l	%00011101000101111000000000000000
	dc.l	%00011101010010111000000000000000
	dc.l	%00011100101001111100000000000000
	dc.l	%00001110100111111110000000000000
	dc.l	%00001111111111111010000000000000
	dc.l	%00011111111110111101000000000000
	dc.l	%00011110100001110001000000000000
	dc.l	%00010111101111111001000000000000
	dc.l	%00001111111111111111000000000000
	dc.l	%00000111111111111010000000000000
	dc.l	%00000011110101111000000000000000
	dc.l	%00000011111111111100000000000000
	dc.l	%00000111111011010110000000000000
	dc.l	%00000101011000011110000000000000
	dc.l	%00000111111111100110000000000000
	dc.l	%00000101110111110010000000000000
	dc.l	%00001111100000111111000000000000
	dc.l	%00011111100000110001100000000000
	dc.l	%00110001110000111110110000000000
	dc.l	%00111111110000011111110000000000

pangtl	dc.w	36
	dc.l	%00000000000010000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000000101000000000000000000
	dc.l	%00000000000101000000000000000000
	dc.l	%00000000100000001000000000000000
	dc.l	%00000000101001010000000000000000
	dc.l	%00000000010000010000000000000000
	dc.l	%00000000101000101000000000000000
	dc.l	%00000110000000000101000000000000
	dc.l	%00000000110000011000000000000000
	dc.l	%00000000011110110000000000000000
	dc.l	%00000000010100110000000000000000
	dc.l	%00000000010110110000000000000000
	dc.l	%00000000000100100000000000000000
	dc.l	%00000010000111111000000000000000
	dc.l	%00000011111111111110000000000000
	dc.l	%00000001111101010111000000000000
	dc.l	%00000001110110101111000000000000
	dc.l	%00000000111101010011100000000000
	dc.l	%00000001111001010101100000000000
	dc.l	%00000001110100100101100000000000
	dc.l	%00000010111010010101100000000000
	dc.l	%00000011111101010011100000000000
	dc.l	%00000011111110101111000000000000
	dc.l	%00000010111111110111000000000000
	dc.l	%00000111111111111111000000000000
	dc.l	%00000100111100101111000000000000
	dc.l	%00000100011111011111000000000000
	dc.l	%00000011111011111110000000000000
	dc.l	%00000011101111111110000000000000
	dc.l	%00000011001111111110000000000000
	dc.l	%00000010110000101010000000000000
	dc.l	%00000101111101111110000000000000
	dc.l	%00001110010111101111000000000000
	dc.l	%00001011110001111101100000000000
	dc.l	%00010111100001110101100000000000
	dc.l	%00111111100001111111100000000000

pangtr	dc.w	36
	dc.l	%00000000000100000000000000000000
	dc.l	%00000000000000000000000000000000
	dc.l	%00000000001010000000000000000000
	dc.l	%00000000001010000000000000000000
	dc.l	%00000001000000010000000000000000
	dc.l	%00000000101001010000000000000000
	dc.l	%00000000100000100000000000000000
	dc.l	%00000001010001010000000000000000
	dc.l	%00001010000000000110000000000000
	dc.l	%00000001100000110000000000000000
	dc.l	%00000000110111100000000000000000
	dc.l	%00000000110010100000000000000000
	dc.l	%00000000110110100000000000000000
	dc.l	%00000000010010000000000000000000
	dc.l	%00000001111110000100000000000000
	dc.l	%00000111111111111100000000000000
	dc.l	%00001110101011111000000000000000
	dc.l	%00001111010110111000000000000000
	dc.l	%00011100101011110000000000000000
	dc.l	%00011010101001111000000000000000
	dc.l	%00011010010010111000000000000000
	dc.l	%00011010100101110100000000000000
	dc.l	%00011100101011111100000000000000
	dc.l	%00001111010111111100000000000000
	dc.l	%00001110111111110100000000000000
	dc.l	%00001111111111111110000000000000
	dc.l	%00001111010011110010000000000000
	dc.l	%00001111101111100010000000000000
	dc.l	%00000111111101111100000000000000
	dc.l	%00000111111111011100000000000000
	dc.l	%00000111111111001100000000000000
	dc.l	%00000101010000110100000000000000
	dc.l	%00000111111011111010000000000000
	dc.l	%00001111011110100111000000000000
	dc.l	%00011011111000111101000000000000
	dc.l	%00011010111000011110100000000000
	dc.l	%00011111111000011111110000000000

balle1	dc.w	7
	dc.w	%0011110000000000
	dc.w	%0111111000000000
	dc.w	%1100111100000000
	dc.w	%1101111100000000
	dc.w	%1111111100000000
	dc.w	%1101111100000000
	dc.w	%0111111000000000
	dc.w	%0011110000000000

balle2	dc.w	14
	dc.w	%0000011110000000
	dc.w	%0000111111100000
	dc.w	%0011011110110000
	dc.w	%0011000111011000
	dc.w	%0110000111011000
	dc.w	%0100001111111100
	dc.w	%1110011111111100
	dc.w	%1100011111111100
	dc.w	%1101011111111100
	dc.w	%1110111111101100
	dc.w	%0101111100111000
	dc.w	%0111111000001000
	dc.w	%0011111100010000
	dc.w	%0001111111100000
	dc.w	%0000011110000000

balle3	dc.w	31
	dc.l	%00000000000011111111000000000000
	dc.l	%00000000001101111011110000000000
	dc.l	%00000000110111101110101100000000
	dc.l	%00000001011111111111111110000000
	dc.l	%00000011110000111111111101000000
	dc.l	%00000101000000011111111111100000
	dc.l	%00001110100000011111111111110000
	dc.l	%00010101000000111111111111101000
	dc.l	%00011110000000111111111111111000
	dc.l	%00010100000001111111111111111000
	dc.l	%00101000000011111111111111110100
	dc.l	%00111100000111111111111111111100
	dc.l	%01010000000111111111111111111100
	dc.l	%01111000000111111111111111111110
	dc.l	%01010100000111111111111111111010
	dc.l	%01111000000111111111111111111110
	dc.l	%01010100000111111111111111111110
	dc.l	%01111101001111111111111111101010
	dc.l	%01010110110111111111111111111110
	dc.l	%00111111011111111111111111011100
	dc.l	%00101110111111111111111101110100
	dc.l	%00111111111111111111110111011100
	dc.l	%00011111111111111110111010111000
	dc.l	%00011011111111110101001011101000
	dc.l	%00001111111111101010010010110000
	dc.l	%00001011111111011000000010110000
	dc.l	%00000111111111100100000011100000
	dc.l	%00000010111111011000000101000000
	dc.l	%00000001111111110100101111000000
	dc.l	%00000000111111101010101100000000
	dc.l	%00000000001111111101110000000000
	dc.l	%00000000000011111111000000000000

harpon	dc.w	10
	dc.w	%0000100000000000
	dc.w	%0000100000000000
	dc.w	%0001010000000000
	dc.w	%0001110000000000
	dc.w	%0010001000000000
	dc.w	%0011011000000000
	dc.w	%0101010100000000
	dc.w	%0101010100000000
	dc.w	%0001110000000000
	dc.w	%0001110000000000
	dc.w	%0001110000000000

lasset	dc.w	15
	dc.w	%0001110000000000
	dc.w	%0001010000000000
	dc.w	%0001110000000000
	dc.w	%0011110000000000
	dc.w	%0011100000000000
	dc.w	%0111000000000000
	dc.w	%0110000000000000
	dc.w	%0110000000000000
	dc.w	%1110000000000000
	dc.w	%1110000000000000
	dc.w	%1010000000000000
	dc.w	%1010000000000000
	dc.w	%1010000000000000
	dc.w	%0101000000000000
	dc.w	%0011100000000000
	dc.w	%0010010000000000

levelup  	dc.l	%11111111111111111111111111111111
		dc.l	%11111111111111111111111111111111
		dc.l	%11110011110000000100111110000000
		dc.l	%00110011111111111001111001100001
		dc.l	%11110011110000001100111100100000
		dc.l	%01110011111111111001111001100001
		dc.l	%11100111100111111100111001001111
		dc.l	%11100111111111110011110011001001
		dc.l	%11100111100111111100110001001111
		dc.l	%11100111111111110011110011001001
		dc.l	%11100111100000001100110011000000
		dc.l	%01100111111111110011110011000011
		dc.l	%11001111000000011100100110000000
		dc.l	%11001111111111100111100110000111
		dc.l	%11001111001111111100000110011111
		dc.l	%11001111111111100111001110011111
		dc.l	%11001111001111111100001110011111
		dc.l	%11001111111111100111001110011111
		dc.l	%10000001000000111100011110000001
		dc.l	%10000001111111100000011100111111
		dc.l	%10000001000000111100111110000001
		dc.l	%10000001111111110000111100111111
		dc.l	%11111111111111111111111111111111
		dc.l	%11111111111111111111111111111111

titre		incbin		"titre89.bin"

;*****************************************************
;*******************Donnee du jeu*********************
;*****************************************************
	include	"pang89txt.asm"

;variable
apparition		dc.w	100
apparition2		dc.w	400
perdu		dc.w	0
nbcasse	dc.w	0
levelplus	dc.w	0
hptr     dc.l 0				;addresse du BUFFER
hnum     dc.w 0

;variable qui gere le score
level		 dc.w	   0
score        dc.w    0
strbuf       dc.l    0
tmpstr	 ds.b    6


;variable qui gere les hiscores
hiscore	dc.w	   0


;variable pour l'animation du perso
xpang  dc.w   0
ypang  dc.w   84
compteurjoueur  dc.w	0
droitejoueur    dc.w	0
numero	dc.w	0
incrnumero	dc.w	1
tiron	dc.w	0
tiron2	dc.w	0

;variable pour le tir
xtir  dc.w   0
ytir  dc.w   0
ligne	dc.w	 0
ligne2 dc.w	 0
ligne3 dc.w	 0
atontirer	dc.w	0
ylasset	dc.w	0
vitesse	dc.w	501

;variable qui gere le menu option
apou		dc.w	0
aptaille	dc.w	3		
vitesseop	dc.w	10501			;501 pour une Ti92 et 5501 pour une Ti92+

;Variable necessaire pour l'equation de la trajectoire
styleballe	dc.w	0
vx0	dc.w   0
vy0	dc.w   0
vy1	dc.w   0
vx1	dc.w   0
t	dc.w   0
x	dc.w   0
y	dc.w   0
y2	dc.w   0
x0	dc.w   0
y0	dc.w   0
tt0	dc.w   0
m	dc.w   0
r	dc.w   0
dirballe	dc.w   0
vy0neg	dc.w   0
lignemat	dc.w	 0
lignemat2	dc.w	 0

 _comment: dc.b "PANG V1.01 - COMBES Bertrand (TX Team)",0

	end