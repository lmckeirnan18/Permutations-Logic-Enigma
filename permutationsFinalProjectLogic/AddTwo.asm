TITLE Enigma,           (AddSub2.asm)
;Lily McKeirnan
;Aleisha Smith
;Ahmed 
;final project Enigma Assembler
;DESCRIPTION: User inputs a plaintext message and picks a key size and then enters a key. The program will encrypt the input plaintext message using permutation logic. Then it will output the plaintext and ciphertext. 

INCLUDE Irvine32.inc
;-----------------------------------------------------
.data


prompt1 BYTE "Enter a plainText: ",0
prompt2 BYTE "Enter in a key size of 5 or 6: ",0
prompt3 BYTE "Enter in a key number value (using numbers 0-4 scrambled up): ",0
prompt4 BYTE "Values were outside the range of 0-4 inclusive. Try again: ",0
prompt5 BYTE "You repeated a value, try again: ",0
prompt6 BYTE "Key: ",0
prompt7 BYTE "Plaintext:  ",0
prompt8 BYTE "CipherText: ",0
prompt9 BYTE "Enter in a key number value (using numbers 0-5 scrambled up): ",0
prompt10 BYTE "Values were outside the range of 0-5 inclusive. Try again: ",0
prompt11 BYTE "Pos: ",0
prompt12 BYTE "Letters and blanks spaces count as 0.",0
prompt13 BYTE "Would you like to encrypt another message? 0 = 'no' and 1 = 'yes': ",0
prompt14 BYTE "Goodbye. ",0


plainTextArray BYTE 300 DUP(" "),0
byteCount DWORD ?

space BYTE " ",0
lbracket BYTE "[",0
rbracket BYTE "]",0
lbrace BYTE "{",0
rbrace BYTE "}",0
ksize BYTE ?				;for the different sizes of keyarrays
holder BYTE ?				;used for displaying with "{}" when determining length and position

keyarray5 BYTE 5 DUP('#')		
keyarray6 BYTE 6 DUP('#')
posarray5 BYTE 0, 1, 2, 3, 4
posarray6 BYTE 0, 1, 2, 3, 4, 5

cipherTextArray BYTE SIZEOF plainTextArray DUP(0)
x BYTE ?							;variable we use in L3 and innerloop5 PROC
cipherTextString BYTE ?				;new array




.code

;********************MAIN PROC*************************
main PROC

Encrypt:
	;---------clear/reset everything---------
	mov eax, white
	call SetTextColor

	mov esi, 0
	mov ecx, 5
	clear5:
		mov keyArray5[esi], '#'				;clearing keyArray5
		inc esi

	loop clear5

	mov esi, 0
	mov ecx, 6
	clear6:
		mov keyArray6[esi], '#'				;clearing keyArray6
		inc esi

	loop clear6


	mov esi, 0
	mov ecx, 300
	cleartextarrays:
		mov plaintextArray[esi], ' '		;clearing the plaintextArray
		mov ciphertextArray[esi], ' '		;clearing the ciphertextArray
		inc esi
	loop cleartextarrays

	;----------Start encryption process---------------

	mov edx, OFFSET prompt1					;prompting the user	;code for user inputing in plaintext 
	call WriteString
	mov edx, OFFSET plainTextArray
	mov ecx, SIZEOF plainTextArray
	call ReadString							;user input is stored in plainTextArray
	mov byteCount, eax						;number of characters entered by user

	mov esi, eax							;note: eax = number of characters entered
	mov ecx, 2								;there are two dots after the last character entered which interupts the itteration 
	mov bl, space							;we need them to be spaces

	L10:
		mov plainTextArray[esi], bl			;taking care of the two dots in the plaintext array when reading in user input by putting in spaces
		inc esi

	loop L10
	
	call Crlf						
	;--------------key size options---------------------
	Redo:
		mov edx, OFFSET prompt2				;output prompt asking for key size of 5 or 6
		call WriteString
		call ReadInt						;reading in a size
		mov ksize, al
		cmp al, 5
		jb Redo								;is it less than 5? 
		cmp al, 6
		ja Redo								;is it greater than 6?

		call Crlf
		mov edx, OFFSET prompt12			;output warning about blanks and letters when entering in the key
		call WriteString
		call crlf
		call crlf

		cmp ksize, 5
		je k5								;if it is size = 5 go to k5 jump destination
		jmp k6								;if size = 6 go to the k6 jump destination

	k5:
		call KeySize5						;PROCEDURE: gets user input for a key of size five and checks it for validity
		call DisplayKey5					;PROCEDURE: displays the key that the user entered					
		jmp Lend								
	k6:
		call KeySize6						;PROCEDURE: gets user input for a key of size five and checks it for validity
		call DisplayKey6					;PROCEDURE: displays the key that the user entered

	Lend:
		cmp ksize, 5
		je m5
		jmp m6
		m5:
			call First5									;PROCEDURE: mixing up the first 5 elements (keyarray5 size = 5)
			call Rest5									;PROCEDURE: mix up the remaining elements for keysize = 5
			mov eax, bytecount							;dividen
			mov bl, SIZEOF keyarray5					;divisor
			div bl										;dividing number of characters entered by size of key array (quotient in AL, remainder in AH)
			mov bl, SIZEOF keyarray5					;multiplies whats in al with whats in bl, AX contains product
			mul bl
			add ax, SIZEOF keyarray5
			mov esi, eax
			mov bl, rbrace
			mov plainTextArray[esi], bl					;moving "}" into the plaintext array (need to subtract the 2 spaces added)						
			mov cipherTextArray[esi], bl				;moving "}" into the ciphertext array (need to add 1 )
			jmp mend															
			
		m6:
			call First6									;PROCEDURE: mixing up the first 5 elements (keyarray5 size = 6)
			call Rest6									;PROCEDURE: mix up the remaining elements for keysize = 6
			mov eax, bytecount							;dividen
			mov bl, SIZEOF keyarray6					;divisor
			div bl										;dividing number of characters entered by size of key array (quotient in AL, remainder in AH)
			mov bl, SIZEOF keyarray6					;multiplies whats in al with whats in bl, AX contains product
			mul bl
			add ax, SIZEOF keyarray6
			mov esi, eax
			mov bl, rbrace
			mov plainTextArray[esi], bl					;moving "}" into the plaintext array (need to subtract the 2 spaces added)						
			mov cipherTextArray[esi], bl				;moving "}" into the ciphertext array (need to add 1 )

		mend: 
			call Display								;PROCEDURE: use the display procedure to display the arrays

			mov eax, white
			call SetTextColor

			Again:
				mov edx, OFFSET prompt13
				call WriteString
				call Readint
				call crlf
				cmp eax, 1							;1 means "yes"
				ja OutOfRange2						;is the value to big
				je Encrypt							;to start over at the begining 
				cmp eax, 0							;0 means "no"
				jb OutOfRange2						;is the value to small
	
				mov edx, OFFSET prompt14			;Goodbye to user
				call WriteString
				call Crlf
				jmp pend

				OutOfRange2:
					mov edx, OFFSET prompt4			;values outside range, try again
					call WriteString
					jmp Again

				pend: 
					Call Crlf

	exit
main ENDP

;********************************END MAIN*************************************************

;-----------------------------KEYSIZE 5 checking procedure------------------
KeySize5 PROC
	mov ecx, 5							;code for user entering in key of size 5 (range 0-4)
	mov esi, 0
	L2:
		push esi
		push ecx 
		mov edx, OFFSET prompt3			;enter in key values 0-4
		call WriteString
		Next:
			call ReadInt			
			cmp eax, 4
			ja OutOfRange				;is the value to big
			cmp eax, 0
			jb OutOfRange				;is the value to small

		mov ecx, 5
		mov esi, 0
		L5:								;loop comparing values entered with ones in the array
			cmp al, keyarray5[esi]
			je Repeats
			inc esi
		loop L5

		jmp Done
		
		OutOfRange:
			mov edx, OFFSET prompt4		;values out of range, try again
			call WriteString
			jmp Next

		Repeats:
			mov edx, OFFSET prompt5		;value was repeated, try again
			call WriteString
			jmp Next

		Done:
			pop ecx
			pop esi
			mov keyarray5[esi], al		;putting user input value into keyArray
			inc esi
	loop L2

ret
KeySize5 ENDP
;------------------------END KeySize5-----------------------------

;--------------DISPLAY KEY PROCEDURE key size = 5------------------------
DisplayKey5 PROC
	call Crlf
	mov eax, yellow
	call SetTextColor
	mov edx, OFFSET prompt11				;"Pos: "
	call WriteString
	mov edx, OFFSET Lbracket				;"["
	call WriteString

	movzx ecx, ksize
	mov esi, 0
	L17:
		mov edx, OFFSET posarray5			;displaying the positions -> [0 1 2 3 4]
		movzx eax, posarray5[esi]
		call writeInt
		inc esi
	loop L17

	mov edx, OFFSET Rbracket				;"]"
	call WriteString
	call Crlf

	mov edx, OFFSET prompt6					;"Key: "
	call WriteString
	mov edx, OFFSET Lbracket				;"["
	call WriteString

	movzx ecx, ksize
	mov esi, 0
	L6:
		mov edx, OFFSET keyarray5			;displaying the final key right underneath the posarray5
		movzx eax, keyarray5[esi]
		call writeInt
		inc esi
	loop L6

	mov edx, OFFSET Rbracket				;"]"
	call WriteString
	call Crlf

	ret
DisplayKey5 ENDP
;--------------END of DisplayKey5----------------------------

;--------------KEY6 checking procedure-----------------------
KeySize6 PROC
	mov ecx, 6							;code for user entering in key of size 6 (range 0-5)
	mov esi, 0
	L11:
		push esi
		push ecx 
		mov edx, OFFSET prompt9			;enter in key values 0-5
		call WriteString
		Next:
			call ReadInt
			cmp eax, 5
			ja OutOfRange				;greater than 5 (to big)
			cmp eax, 0
			jb OutOfRange				;less than 0 (to small)
	
		mov ecx, 6
		mov esi, 0
		L12:							;loop comparing values entered with ones in the array
			cmp al, keyarray6[esi]
			je Repeats					;is it a repeated value?
			inc esi
		loop L12

		jmp Done

		OutOfRange:
			mov edx, OFFSET prompt10	;values out of range, try again
			call WriteString
			jmp Next

		Repeats:
			mov edx, OFFSET prompt5		;value was repeated, try again
			call WriteString
			jmp Next

		Done:
			pop ecx
			pop esi
			mov keyarray6[esi], al		;putting user input value into keyArray
			inc esi
	loop L11

ret
KeySize6 ENDP
;---------------------END KeySize6---------------------

;--------------DISPLAY KEY PROCEDURE key size = 6------------------------
DisplayKey6 PROC
	call Crlf
	mov eax, yellow
	call SetTextColor
	mov edx, OFFSET prompt11				;"Pos: "
	call WriteString
	mov edx, OFFSET Lbracket				;"["
	call WriteString

	movzx ecx, ksize
	mov esi, 0
	L18:
		mov edx, OFFSET posarray6			;displaying the positions -> [0 1 2 3 4 5]
		movzx eax, posarray6[esi]
		call writeInt
		inc esi
	loop L18

	mov edx, OFFSET Rbracket
	call WriteString						;"]"
	call Crlf

	mov edx, OFFSET prompt6					;"Key: "
	call WriteString
	mov edx, OFFSET Lbracket				;"["
	call WriteString

	movzx ecx, ksize
	mov esi, 0
	L16:
		mov edx, OFFSET keyarray6			;displaying the final key right underneath the posarray6
		movzx eax, keyarray6[esi]
		call writeInt
		inc esi
	loop L16

	mov edx, OFFSET Rbracket				;"]"
	call WriteString	
	call Crlf

	ret
DisplayKey6 ENDP
;--------------END of DisplayKey6----------------------------

;-------------Initial mix up of the plaintext for key of size 5 -------
First5 PROC
	mov ecx, SIZEOF keyarray5
	mov esi, 0 
	mov ebx, 0
	mov eax, 0
	L1:
		mov al, plainTextArray[ebx]			;putting first element in al
		movzx esi, keyarray5[ebx]			;putting position to move the element into esi
		mov cipherTextArray[esi],al			;putting element into the new position
		inc ebx
	loop L1

ret
First5 ENDP
;---------------END of first size 5 mix up------------------

;-------------------Rest of the elements keysize = 5--------------
Rest5 PROC
	mov ebx, 0														;counter for moving along along in the keyArray
	mov eax, 0
	mov ebp, 0														;used for moving along plainTextArray
	mov edx, 0														;used for multiplication

	mov al, plainTextArray[SIZEOF keyarray5 + ebp]					;get the letter from the plaintext
	movzx esi,keyarray5[ebx]										;get the position from the keyarray5

	cmp esi, SIZEOF keyarray5										;deciding if we need to mod to be able to apply the key array position elements 
	jb lcipher						

	mov edi, SIZEOF keyarray5
	mov dx, 2
	mul dx
	add esi,edi				


	lcipher:																			;this is a jump
		mov ecx, (SIZEOF plainTextArray - SIZEOF keyarray5)/(SIZEOF keyarray5)			;loop counter 

		mov x, 1
		L3:
			push ecx
			mov ecx, SIZEOF keyarray5

			Call innerloop5						;PROCEDURE: computing destination and filling ciphertext array 
	
			pop ecx
			inc x
			mov ebx, 0
		loop L3

ret
Rest5 ENDP
;------------------------END of Rest5------------------------------------

;-----------------------Destination and filling Size = 5-----------------------------
innerloop5 PROC
	L4:
		mov al, plainTextArray[SIZEOF keyarray5 + ebp]			;accessing the elements at position 5+ (the 6th element)
		movzx esi,keyarray5[ebx]								;getting the data at keyarray5[ebx] and putting into esi (the new destination of the plaintext letter)
		push ebx
		push eax
		push esi
		mov eax, SIZEOF keyarray5								;eax = 5
		movzx ebx, x
		mul ebx													;multiplying (eax)*(ebx) = 5 * (ebx)
		pop esi													;product is in eax?
		add eax, esi											; eax = 5x + esi      (note: esi is a value from keyarray5)
		mov edx, eax											;moves the value into edx 
		mov eax, 0					 
		pop eax
		mov cipherTextArray[edx],al								;put the plaintext letter into its new destination within cipherTextArray
		pop ebx						
		inc ebx		
		inc ebp	
	loop L4

ret
innerloop5 ENDP
;---------------END innerloop5----------------------------

;-------------Initial mix up of the plaintext for key of size 6 -------
First6 PROC
	mov ecx, SIZEOF keyarray6
	mov esi, 0 
	mov ebx, 0
	mov eax, 0
	L13:
		mov al, plainTextArray[ebx]			;putting first element in al
		movzx esi, keyarray6[ebx]			;putting position to move the element into esi
		mov cipherTextArray[esi],al			;putting element into the new position
		inc ebx
	loop L13

ret
First6 ENDP


;---------------END of first size 6 mix up---------------------

;-------------------Rest of the elements keysize = 6--------------
Rest6 PROC
	mov ebx, 0														;counter for moving along along in the array??
	mov eax, 0
	mov ebp, 0
	mov edx, 0

	mov al, plainTextArray[SIZEOF keyarray6 + ebp]					;get the letter from the plaintext
	movzx esi,keyarray6[ebx]											;get the position from the keyarray5

	cmp esi, SIZEOF keyarray6										;deciding if we need to mod to be able to apply the key array position elements 
	jb lcipherl						

	mov edi, SIZEOF keyarray6
	mov dx, 2
	mul dx
	add esi,edi						


	lcipherl:									;this is a jump
		mov ecx, (SIZEOF plainTextArray - SIZEOF keyarray6)/(SIZEOF keyarray6)

		mov x, 1
		L14:
			push ecx
			mov ecx, SIZEOF keyarray6

			Call innerloop6						;PROCEDURE: computing destination and filling ciphertext array 	
			pop ecx
			inc x
			mov ebx, 0
		loop L14

ret
Rest6 ENDP
;------------------------------END of Rest6--------------------------------------

;-------------------Destination and filling Size = 6-----------------------
innerloop6 PROC
	L15:
		mov al, plainTextArray[SIZEOF keyarray6 + ebp]		;accessing the elements at position 6+ (the 7th element)
		movzx esi,keyarray6[ebx]							;getting the data at keyarray6[ebx] and putting into esi (the new destination of the plaintext letter)
		push ebx
		push eax
		push esi
		mov eax, SIZEOF keyarray6							;eax = 6
		movzx ebx, x
		mul ebx												;multiplying (eax)*(ebx) = 6 * (ebx)
		pop esi												;product is in eax
		add eax, esi										; eax = 6x + esi      (note: esi is a value from keyarray6)
		mov edx, eax
		mov eax, 0					 
		pop eax
		mov cipherTextArray[edx],al							;put the plaintext letter into its new destination within cipherTextArray
		pop ebx						
		inc ebx		
		inc ebp
	loop L15

ret
innerloop6 ENDP
;-----------------END innerloop6------------------------------

;---------------Display text arrays procedure-------------------------
Display PROC						
	call crlf
	mov eax, (lightcyan)
	call SetTextColor
	mov edx, OFFSET prompt7
	call WriteString
	mov edx, OFFSET lbrace								;"{"
	call WriteString
	mov edx, OFFSET plainTextArray
	call Writestring
	call Crlf
	mov eax, (lightmagenta)
	call SetTextColor
	mov edx, OFFSET prompt8
	call WriteString
	mov edx, OFFSET lbrace								;"{"
	call WriteString
	mov edx, OffSET cipherTextArray
	call Writestring
	call Crlf
	call Crlf
ret
Display ENDP
;-------------------------END DISPLAY PROCEDURE----------




;#########################################################################
END main
