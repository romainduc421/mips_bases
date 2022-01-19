.text
main :
    # initialiser s7 avec sp (initialisation de la base des variables)
    move $s7,$sp
    
    # réservation de l'espace pour 2 variables
    addi $sp, $sp, -8
    
	...
end :
    # fin du programme
    li $v0, 10      # retour au système
    syscall         
    