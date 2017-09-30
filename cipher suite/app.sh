#!/bin/bash

GREEN='\033[0;32m'	# Defining of Text Colours for User Understanding
BLUE='\033[0;34m'
RESET='\033[0m'
RED='\033[0;31m'

log="log.txt"	# assigning file for keep log information

algorithm()	# Select the suitable algorithm type for encryption and decryption
{
	echo
	echo " PRESS 1 -> aes-256-cbc "		# Advanced Encryption Standard using 256 bit key
	echo " PRESS 2 -> aes-256-ecb "		
	echo " PRESS 3 -> des "			# Data Encryption Standard using 56 bit key
	echo " PRESS 4 -> des3 "		# Triple DES using 168 bit key
	echo " PRESS 5 -> rc4 "			# Rivest Cipher 4 
	echo 
	read -p " Select an Algorithm : " user_option	

	algorithm="" #defining a variable to store the algorithms

	if [ $user_option == 1 ]; then 
		algorithm="-aes-256-cbc"
	elif [ $user_option == 2 ]; then
	       algorithm="-aes-256-ecb"
       	elif [ $user_option == 3 ]; then
		algorithm="-des"
	elif [ $user_option == 4 ]; then
		algorithm="-des3"
	elif [ $user_option == 5 ]; then
		algorithm="-rc4"
	else
		echo -e "${RED} Please select a valid number${RESET}"
		exit 1 
	fi

}


choose_file()		# Function for getting the input file name and extension with the path 
{
	echo
	echo -e "${GREEN} Enter the FILE name with the path and file extension${RESET}"
	echo
	read -p " FILE.Extension : " path # recive file path from user

	# Check for the existence of the file
	if [ ! -f $path ]; then
		echo " Invalid File Name and/or Extension"
		exit 1
	fi
}


s_encryption()	# Encryption Function for Symmetric Technique
{
	
	echo " Please select a suitable Encryption Algorithm"

	algorithm	# Calling function for selecting an algorithm
	choose_file		# Calling function for getting the user input file
	echo

	extension=".enc" # store output file extension 
	
	# Adding an extension .enc to differentiate the encrypted file from original file
	output_path=$path$extension	

	# Encryption Process using the selected algorithm type
	openssl enc $algorithm -e -in $path -out $output_path	

	echo
	echo -e " ${GREEN}The FILE $path is encrypted to $output_path with $algorithm algorithm ${RESET}"
	echo
	echo -e " \n Symmetric Technique " >> $log	
	echo " The FILE $path is encrypted to $output_path with $algorithm algorithm" >> $log

}


s_decryption()	# Decryption Function for Symmetric Technique
{

	echo " Please select a suitable Decryption Algorithm"

	algorithm	# Calling function for selecting an algorithm
	choose_file		# Calling function for getting the user input file
	echo

	# Removing the extension .enc which was added during the encryption process
	output_path=${path%.*}

	# Decryption Process using the selected algorithm type
	openssl enc $algorithm -d -in $path -out $output_path
	
	echo
	echo -e " ${BLUE}The FILE $path is decrypted to $output_path with $algorithm algorithm ${RESET}"
	echo
	echo -e " \n Symmetric Technique " >> $log	
	echo " The FILE $path is decrypted to $output_path with $algorithm algorithm" >> $log

}


a_encryption()	# Encryption Function for Asymmetric Technique
{


	choose_file		# Calling function for getting the user input file
	echo

	extension=".enc"

	# Adding an extension .enc to differentiate the encrypted file from original file
	output_path=$path$extension
	echo
	echo " choose the key option "
	echo 
	echo " PRESS 1 for public key"
	echo " PRESS 2 for private key"
	echo 
	read -p " Enter Your option : " option
	if [ "$option" == 1 ];
	then
		# Encryption Process using the PUBLIC KEY [public_key.pem]
		openssl rsautl -encrypt -pubin -inkey public_key.pem -in $path -out $output_path
		echo -e " ${GREEN}The FILE $path is encrypted to $output_path with $algorithm algorithm ${RESET}"
		echo
		echo -e " \n Asymmetric Technique " >> $log
		echo " The FILE $path is encrypted to $output_path with RSA algorithm" >> $log
	elif [ "$option" == 2 ];
	then
		openssl rsautl -encrypt -inkey private_key.pem -in $path -out $output_path
		echo -e " ${GREEN}The FILE $path is encrypted to $output_path with $algorithm algorithm ${RESET}"
		echo
		echo -e " \n Asymmetric Technique " >> $log
		echo " The FILE $path is encrypted to $output_path with $algorithm algorithm" >> $log
	else
		echo -e "${RED} Invalid input${RESET}" 
	fi
	echo


}


a_decryption()	# Decryption Function for Asymmetric Technique
{

	choose_file		# Calling function for getting the user input file
	echo

	# Removing the extension .enc which was added during the encryption process
	output_path=${path%.*}

	# Decryption Process using the PRIVATE KEY [private_key.pem]
	openssl rsautl -decrypt -inkey private_key.pem -in $path -out $output_path
	
	echo
	echo -e " ${BLUE}The FILE $path is decrypted to $output_path with $algorithm algorithm ${RESET}" 
	echo
	echo -e " \n Asymmetric Technique " >> $log	
	echo " The FILE $path is decrypted to $output_path with RSA algorithm" >> $log

}


echo
echo -e " ${GREEN} Welcome to cipher suite ${RESET}"
echo



while true   #systems is running until user is exit
do

echo -e "${RED} Please Choose Your Function${RESET}"
echo
echo " PRESS S For Symmetric Technique"
echo " PRESS A For Asymmetric Technique"
echo " PRESS Q For QUIT"
echo
read -p " Enter Your option : " option
echo


if [ "$option" = "s" ] || [ "$option" = "S" ]; then

	echo -e " ${GREEN}Welcome to SYMMETRIC Encryption and Decryption part${RESET}"
	
	echo " PRESS E For Encryption"
	echo " PRESS D For Decryption"
	echo
	read -p " Select : " user_option

	if [ "$user_option" = "e" ] || [ "$user_option" = "E" ]; then 
		s_encryption		# Calling the Symmetric Encryption Function
	

	elif [ "$user_option" = "d" ] || [ "$user_option" = "D" ]; then
		s_decryption		# Calling the Symmetric Decryption Function

	else
		echo -e "${RED} Invalid option, Please choose a correct option${RESET}" 
		echo
	fi

elif [ "$option" = "a" ] || [ "$option" = "A" ]; then

	echo -e " ${GREEN}Welcome to Asymmetric Encryption and Decryption part${RESET}"
	
	echo " PRESS E For Encryption"
	echo " PRESS D For Decryption"
	echo
	read -p " Select : " user_option

	if [ "$user_option" = "e" ] || [ "$user_option" = "E" ]; then
		a_encryption		# Calling the Asymmetric Encryption Function
	

	elif [ "$user_option" = "d" ] || [ "$user_option" = "D" ]; then
		a_decryption		# Calling the Asymmetric Decryption Function

	else
		echo -e "${RED} Invalid option, Please choose a correct option${RESET}" 
		echo
	fi

elif [ "$option" = "q" ] || [ "$option" = "Q" ]; then

	exit -1 #terminate the program

else 
	echo -e "${RED} Invalid option, Please choose a correct option${RESET}"  
	echo

fi

done

