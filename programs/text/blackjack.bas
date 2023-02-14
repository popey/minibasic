10  REM   BLACKJACK
11  REM  Originally written circa 1985
12  REM  Updated for MiniBASIC in 2003
20  DIM CU(13,4),CL$(4),CD$(13)
100  HOME : PRINT 
110  PRINT  TAB(16)"BLACKJACK": PRINT : PRINT  TAB(14)"By Joe Strout"
120  PRINT : PRINT : PRINT 
140 CL$(1) = "H":CL$(2) = "S":CL$(3) = "D":CL$(4) = "C"
150  FOR I = 2 TO 10:CD$(I) =  STR$ (I): NEXT :CD$(11) = "J":CD$(12) = "Q":CD$(13) = "K":CD$(1) = "A"
190 MN = 40: REM  MONEY LEFT
200  PRINT : PRINT : PRINT "   You have $"MN".": PRINT
210  IF MN < 1 THEN PRINT "You are out of money.  Better luck next time!": END
250  PRINT "Press [P] to play,": PRINT "   or [Q] to quit: ";
260  GET A$: IF A$ = "p" OR A$ = "P" THEN 300
270  IF A$ <  > "q" AND A$ <  > "Q" THEN 260
280  PRINT : END
300  REM   PLAY
310  HOME : PRINT : PRINT "You have $"MN".": PRINT 
320  INPUT "How much will you bet? ", BT
325  IF BT = 0 THEN 200
330  IF BT > MN OR BT < 1 THEN 300
340  IF BT = 0 THEN 200
350 MN = MN - BT
360  PRINT "Shuffling...": FOR A = 1 TO 13: FOR B = 1 TO 4:CU(A,B) = 0: NEXT : NEXT 
400  REM  DEAL
410  GOSUB 2000:DV(1) = V:DC(1) = C
420  GOSUB 2000:DV(2) = V:DC(2) = C
430  GOSUB 2000:PV(1) = V:PC(1) = C
440  GOSUB 2000:PV(2) = V:PC(2) = C
450 NP = 2:ND = 2
480  GOSUB 1500
500  REM Player choice: Hit or Stand?
510 HD = 1: GOSUB 2100: GOSUB 2200: IF A > 21 THEN 600
520  PRINT : PRINT "[H]it, or [S]tand? ";
530  GET A$: IF A$ = "S" OR A$ = "s" THEN  PRINT "Stand": GOTO 1000
540  IF A$ <  > "H" AND A$ <  > "h" THEN 530
550  PRINT "Hit me": GOSUB 2000:NP = NP + 1:PV(NP) = V:PC(NP) = C
570  GOTO 500
600  REM  Player Busts
610  PRINT : PRINT "You're busted.": PRINT : PRINT 
620  GOTO 200
1000  REM   Dealer's Turn
1010  PRINT : PRINT "Now it's my turn...": WAIT 1.5
1020  REM Dealer draws
1030 HD = 0: GOSUB 2100: GOSUB 2300
1040  IF A < 17 THEN  GOSUB 2000:ND = ND + 1:DV(ND) = V:DC(ND) = C: GOTO 1020
1050  IF A > 21 THEN 1200
1100  GOSUB 2300:D = A: GOSUB 2200:P = A: PRINT : PRINT "I have "D", you have "P"."
1110  IF D = P THEN  PRINT "  It's a tie.":MN = MN + BT
1120  IF D > P THEN  PRINT "  I win."
1130  IF D < P THEN  PRINT "  You win.":MN = MN + BT * 2
1140  GOTO 200
1200  REM  Dealer Busts
1210  PRINT : PRINT "Dealer busts.":MN = MN + BT * 2
1220  GOTO 200
1500  REM  NATURAL 21'S
1510  GOSUB 2300: IF A < 21 THEN 1600
1520 HD = 0: GOSUB 2100: PRINT : PRINT "I have a natural 21.": PRINT 
1530  GOSUB 2200: IF A < 21 THEN  PRINT "I win.": GOTO 200
1540  PRINT "  But so do you - it's a standoff."
1550 MN = MN + BT: GOTO 200
1600  GOSUB 2200: IF A < 21 THEN  RETURN 
1610 HD = 1: GOSUB 2100
1620  PRINT : PRINT "You have a natural 21;": PRINT "   You win a 3:2 payoff."
1630 MN =  INT (MN + BT + BT * 3 / 2): GOTO 200
1999  END 
2000  REM  GET UNUSED CARD
2010 V =  INT (13 *  RND (1) + 1):C =  INT (4 *  RND (1) + 1): IF CU(V,C) THEN 2010
2020 CU(V,C) = 1: RETURN 
2100  REM  SHOW CARDS
2105  HOME : PRINT "Your bet: $"BT: PRINT 
2110  PRINT "Dealer: ";:I = 1: IF HD THEN  PRINT "### ";:I = 2
2120  PRINT CD$(DV(I));CL$(DC(I))" ";:I = I + 1: IF I <  = ND THEN 2120
2130  PRINT : PRINT : PRINT "Player: ";:I = 1
2140  PRINT CD$(PV(I));CL$(PC(I))" ";:I = I + 1: IF I <  = NP THEN 2140
2150  PRINT : RETURN 
2200  REM  COMPUTE PLAYER'S VALUE   
2210 A = 0:Z = 0: FOR I = 1 TO NP
2220 B = PV(I): IF B > 10 THEN B = 10: REM  FACE CARDS  
2230  IF B = 1 THEN Z = Z + 1:A = A + 10: REM  ACES HIGH
2240 A = A + B
2250  NEXT I
2260  IF A > 21 AND Z > 0 THEN A = A - 10:Z = Z - 1: GOTO 2260: REM  ACES LOW
2270  RETURN 
2300  REM  COMPUTE DEALER'S VALUE
2310 A = 0:Z = 0: FOR I = 1 TO ND
2320 B = DV(I): IF B > 10 THEN B = 10
2330  IF B = 1 THEN Z = Z + 1:A = A + 10
2340 A = A + B
2350  NEXT I
2360  IF A > 21 AND Z > 0 THEN A = A - 10:Z = Z - 1: GOTO 2260
2370  RETURN 
