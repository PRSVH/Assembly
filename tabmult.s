N_MAX= 10
STOP_VAL=N_MAX-1
SIZE=4

   .data
barre :  .byte '|'
         .byte 0
espace : .byte ' '
         .byte 0
tirets : .asciz "---"
numline: .word 0
numcol : .word 0
n_ligne: .word 1
n_column: .word 1

debutTab:    .skip N_MAX*N_MAX*4   @ adresse du debut du tableau
 
   .text
   .global main
main: push {lr}

    @remplissage du tableau
        ldr r0, adr_num                                       @r0 <- adr_num
        ldr r0,[r0]                                           @ r0 <- [r0]     (n_ligne)
        ldr r3, adr_col                                       @r3 <- adr_col
        ldr r3, [r3]                                          @r3 <- [r3]
        mov r2, #N_MAX                                        @ r2 <- N_MAX
        ldr r4, ptr_debutTab                                  @ r4 <- address of start of array
    

OUTERLOOP : 
cmp r0,r2                                                     @ r0-r2 (compare the value of the content of r0 and r2 : compare line number with max line number)
ble INNERLOOP                                                 @ if r0 <= r2, go to INNERLOOP
bgt affichage                                                 @ if r0 > r2, go to affichage

INNERLOOP:
CMP r3,r2                                                     @ r3-r2 (compare the value of the content of r3 with r2 : compare column number(j) with max column number)
BGT fininnerloop                                              @ if r3 > r2, go to fininnerloop (if j > 10)
mul r5,r0,r3                                                  @ r5 <- r0 * r3 (store the multiplication of line and column number and store the result in register r5)
str r5, [r4]                                                  @ [r4] <- r5. Store r5 in the content of the register r4
add r4, r4, #4                                                @ r4 <- r4 + 4 (calculating the offset value for the next index of the table)
add r3,r3,#1                                                  @ r3 <- r3 + 1 (increment the value of j(the column number))
b INNERLOOP                                                   @ loop again 
            
fininnerloop: 
mov r3,#1                                                     @ r3 <- 1 (reinitialise the column number ( j =1 ))
add r0, r0, #1                                                @ r0 <- r0 + 1 ( increment i(the line number))
b OUTERLOOP                                                   @ loop again (outerloop)

affichage:
   ldr r0, adr_numline                                 @r0 <- adr_numline
   ldr r0, [r0]                                        @ r0 <- [r0]     (numline)
   ldr r3, adr_numcol                                  @r3 <- adr_numcol
   ldr r3, [r3]                                        @r3 <- [r3]
   mov r2, #N_MAX-1                                    @ r2 <- N_MAX -1
   
   OUT: 
   CMP r0,r2                                           @ r0-r2 (Comparing r0 and r2)
   bgt fin                                             @ if r0 > r2, go to fin
   mov r3,#0                                           @ r3<-0
   blt IN                                              @ if r0<=r2, go to IN

   IN: 
    CMP r3,r2                                          @ r3-r2
    BHI finin                                          @ if r3>r2, go to finin
    LDR r1,adr_barre                                   @ r1 <- adr_barre
    BL EcrChn                                          @ print the |
    LDR r4, ptr_debutTab                               @ r4 <- ptr_debutTab
    mov r8,r0,lsl#3                                    @ r8 <- numline * 8
    add r8,r8,r0,lsl#1                                 @ r8 <- r8 + 2*numline
    add r8,r8,r3                                       @ r8 <- r8 + numcol
    add r4, r4,r8, lsl #2                              @ r4 <- r4 + r8*4
    ldr r4,[r4]                                        @ r4 <- [r4]
    cmp r4,#100                                        @ r4-100
    blt gotospaces                                     @ if r4 <= 100, go to gotospaces
    bge printmult


   gotospaces: 
   ldr r1,adr_espace                                   @ r1<-adr_espace
   bl EcrChn                                           @ print a space character
   cmp r4,#10                                          @ r4-10
   blt gotospaces1                                     @ if r4 < 10 go to gotospaces1
   bge printmult                                       @ if r4 >= 10 go to printmult

   gotospaces1: 
   ldr r1,adr_espace                                             @ r1<-adr_espace
   bl EcrChn                                                     @ print a space character

                                           

  printmult: mov r1,r4                                           @ r1 <- r4
             bl EcrNdecim32                                      @ print r1 (tab[numline][numcol])
             add r3,r3,#1                                        @ r3 <- r3 + 1
             b IN                                                @ loop again 

   finin: 
   ldr r1,adr_barre                                              @ r1 <- adr_barre
   bl EcrChn                                                     @ print a |
   bl AlaLigne                                                   @ nextline 
   mov r6, #0                                                    @ r6 <- 0 (k = 0)
   
   repeter:
   cmp r6,#N_MAX                                                 @ r6 - N_MAX ( compare value in r6 with 10)
   bge newfin                                                    @ if r6 >= N_MAX go to newfin
   ldr r1, adr_barre                                             @ r1 <- adr_barre
   bl EcrChn                                                     @ print |
   ldr r1, adr_tirets                                            @ r1 <- adr_tirets
   bl EcrChn                                                     @ print ---
   add r6,r6,#1                                                  @ r6 <- r6 + 1 (k = k + 1)
   b repeter                                                     @ loop repeter again

   newfin: 
   ldr r1,adr_barre                                              @ r1 <- adr_barre
   bl EcrChn                                                     @ print |
   bl AlaLigne                                                   @ nextline
   add r0,r0,#1                                                  @ r0 <- r0 + 1 (increment i (line number))
   b OUT                                                         @ loop again






fin: pop {lr}
     bx lr

buffer : .word 
ptr_debutTab : .word debutTab
adr_barre :    .word barre
adr_espace :   .word espace
adr_tirets :   .word tirets
adr_numcol:    .word numcol
adr_numline :   .word numline
adr_num :   .word n_ligne
adr_col:    .word n_column
