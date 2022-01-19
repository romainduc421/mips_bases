.data
enter: .asciiz "\n"
.text
main :
#initialize $s7 w/ $sp 
    move $s7,$sp

#reserve 4 memory places for 4 variables
    addi $sp,$sp,-16
#0 for z, -4 for k, -8 for j, -12 for i


#k=10
    li $v0, 10
    sw $v0, -4($s7)
    
#j=8
    li $v0, 8
    sw $v0, -8($s7)
        
# Ecrire k    
    lw $v0, -8($s7)
    move $a0 , $v0    # $a0 <- k (valeur à afficher)
    li $v0 , 1         # $v0 <- 1 (code du print entier)
    syscall         # afficher
    
#i=j+2
    lw $v0, -8($s7)	#$v0 <- j
    addi $v0, $v0, 2
    sw $v0, -12($s7)    
#ecrire i+1
    la $a0, enter
    li $v0, 4
    syscall 		#afficher '\n'
    lw $v0, -12($s7)
    addi $v0, $v0, 1
    move $a0, $v0
    li $v0,1		# $v0 <- 1 (code du print entier)
    syscall		#afficher i+1
    
#j = j-i
    lw $v0, -8($s7)	#ranger j dans $v0
    lw $v1, -12($s7)
    sub $v0, $v0, $v1
    sw $v0, -8($s7)




#z = (k-3) - (j*k)
    #code cible évaluant l'opérande de gauche et le le rangeant dans $v0
    li $t8, 3		#ranger 3 dans $t8
    lw $v0, -4($s7)	# $v0 <- k (déplacement de 4)
    sub $v0, $v0, $t8
    
    #empiler $v0
    sw $v0, ($sp)
    addi $sp, $sp, -4	
   
    #code cible évaluant l'opérande de droite et le rangeant dans $v0 
    lw $v0, -8($s7)	# $v0 <- j (deplacement de 8)
    lw $v1, -4($s7)
    mult $v0, $v1
    mflo $v0
    
    #dépiler dans $t8
    addi $sp, $sp, 4
    lw $t8, ($sp)	# $t8 contient l'opérande de gauche
    
    sub $v0, $t8, $v0
    
    sw $v0, 0($s7) #ranger $v0 ds z 

#saut de ligne
    la $a0, enter
    li $v0, 4
    syscall 	

#ecrire z
    lw $v0, 0($s7)
    move $a0, $v0
    li $v0, 1
    syscall
#saut de ligne
    la $a0, enter
    li $v0, 4
    syscall 	
  
# si i<z alors print(i) sinon print( z )
    lw $v0, -12($s7)	# $v0 <- i
    lw $v1, 0($s7)	# $v1 <- z
    slt $t8, $v0, $v1	# test i < z
    beq $t8, $zero, Else		#if false goto Else;
    bne $t8, $zero, Then
Then:  
    #afficher i
    move $a0, $v0
    li $v0 , 1
    syscall
    j Endif	# goto Endif     
Else:
    move $a0, $v1
    li $v0, 1
    syscall 
    j Endif
Endif:

#repeter j = j+1; k = k-j; jusqu'a k < 0 finrepeter
repeat :
    lw $v0, -8($s7)	#$v0 <- j
    addi $v0, $v0, 1	#$v0 + 1
    sw $v0, -8($s7)	#stocker le resultat
    
    lw $v0, -4($s7)	#$v0 <- k
    lw $v1, -8($s7)	#$v1 <- j
    sub $v0, $v0, $v1	#k - j
    sw $v0, -4($s7)	#stocker le resultat
    
    bgez $v0, repeat
end_repeat:

#ecrire 1
     #li $v0, 1 #ici on affiche une constante donc pas compliqué, ça sera plus tricky pour une variable
     #move $a0, $v0 
     #li $v0, 1 #Préparation du print
     #syscall
end :
     li $v0, 10 	#retour au systeme
     syscall	
	
