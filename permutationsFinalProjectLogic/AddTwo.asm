TITLE Add and Subtract,           (AddSub2.asm)
;Lily McKeirnan
;permutation logic for final project Enigma Assembler

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


;plainTextArray BYTE "h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d", " ", "f", "o", "u", "r",0
;plainTextArray BYTE "hello world four",0

plainTextArray BYTE 100 DUP(" "),0
byteCount DWORD ?

space BYTE " ",0
lbracket BYTE "[",0
rbracket BYTE "]",0
lbrace BYTE "{",0
rbrace BYTE "}",0
ksize BYTE ?    ;for the different sizes of keyarrays
holder BYTE ?			;used for displaying with "{}" when determining length and position

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

mov edx, OFFSET prompt1				;code for user inputing in plaintext 
call WriteString
mov edx, OFFSET plainTextArray
mov ecx, SIZEOF plainTextArray
call ReadString
mov byteCount, eax

mov esi, eax
mov ecx, 2
mov bl, space

L10:
	mov plainTextArray[esi], bl				;taking care of the two dots in the plaintext array when reading in user input
	inc esi

loop L10
									
;--------------key size options---------------------
Redo:
	mov edx, OFFSET prompt2
	call WriteString
	call ReadInt
	mov ksize, al
	cmp al, 5
	jb Redo
	cmp al, 6
	ja Redo

	cmp ksize, 5
	je k5
	jmp k6
k5:
	call KeySize5				;gets user input for a key of size five and checks it for validity
	call DisplayKey5			;displays the key that the user entered					
	jmp Lend								
k6:
	call KeySize6				;gets user input for a key of size five and checks it for validity
	call DisplayKey6			;displays the key that the user entered
Lend:
;----------------------------------------------------------------------

cmp ksize, 5
je m5
jmp m6
m5:
call First5									;mixing up the first 5 elements (keyarray5 size = 5)
call Rest5									;mix up the remaining elements for keysize = 5
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


;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!add jump when remander = 0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

jmp mend

m6:
call First6									;mixing up the first 5 elements (keyarray5 size = 6)
call Rest6									;mix up the remaining elements for keysize = 6
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
;----------------------------------------------------------------------
	
	call Display									;use the display procedure to display the arrays

	exit
main ENDP

;********************************END MAIN*************************************************

;-------------------Rest of the elements keysize = 6--------------
Rest6 PROC
	mov ecx, SIZEOF plainTextArray - SIZEOF keyarray6				;do this loop for the rest of the elements in plainTextArray (12-4=8)????? do we need this???
	mov ebx, 0														;counter for moving along along in the array??
	mov eax, 0
	mov ebp, 0
	mov edx, 0

	mov al, plainTextArray[SIZEOF keyarray6 + ebp]					;get the letter from the plaintext
	movzx esi,keyarray6[ebx]											;get the position from the keyarray5

	cmp esi, SIZEOF keyarray6										;deciding if we need to mod to be able to apply the key array position elements 
	jb lcipherl						;

	mov edi, SIZEOF keyarray6
	mov dx, 2
	mul dx
	add esi,edi				;????????????????????


	lcipherl:				;this is a jump
		push ecx
		mov ecx, (SIZEOF plainTextArray - SIZEOF keyarray6)/(SIZEOF keyarray6)

		mov x, 1
		L14:
	
		push ecx
		mov ecx, SIZEOF keyarray6

		Call innerloop6						;procedure defined below
	
		pop ecx
		inc x
		mov ebx, 0
		loop L14

		;pop esi
		pop ecx
ret
Rest6 ENDP
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


;---------------END of first size 6 mix up--------

;-------------------Rest of the elements keysize = 5--------------
Rest5 PROC
	mov ecx, SIZEOF plainTextArray - SIZEOF keyarray5				;do this loop for the rest of the elements in plainTextArray (12-4=8)????? do we need this???
	mov ebx, 0														;counter for moving along along in the array??
	mov eax, 0
	mov ebp, 0
	mov edx, 0

	mov al, plainTextArray[SIZEOF keyarray5 + ebp]					;get the letter from the plaintext
	movzx esi,keyarray5[ebx]											;get the position from the keyarray5

	cmp esi, SIZEOF keyarray5										;deciding if we need to mod to be able to apply the key array position elements 
	jb lcipher						;????????????????

	mov edi, SIZEOF keyarray5
	mov dx, 2
	mul dx
	add esi,edi				;????????????????????


	lcipher:				;this is a jump
		push ecx
		mov ecx, (SIZEOF plainTextArray - SIZEOF keyarray5)/(SIZEOF keyarray5)			;loop counter 

		mov x, 1
		L3:
	
		push ecx
		mov ecx, SIZEOF keyarray5

			Call innerloop5						;procedure defined below
	
		pop ecx
		inc x
		mov ebx, 0
		loop L3

		;pop esi
		pop ecx
ret
Rest5 ENDP


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


;---------------END of first size 5 mix up--------

;--------------DISPLAY KEY PROCEDURE key size = 5------------------------
DisplayKey5 PROC
	call Crlf
	mov eax, yellow
	call SetTextColor
	mov edx, OFFSET prompt11
	call WriteString
	mov edx, OFFSET Lbracket
	call WriteString
	movzx ecx, ksize
	mov esi, 0
	L17:
		mov edx, OFFSET posarray5			;displaying the positions
		movzx eax, posarray5[esi]
		call writeInt
		inc esi
	loop L17
	mov edx, OFFSET Rbracket
	call WriteString
	call Crlf

	mov edx, OFFSET prompt6
	call WriteString
	mov edx, OFFSET Lbracket
	call WriteString
	movzx ecx, ksize
	mov esi, 0
	L6:
		mov edx, OFFSET keyarray5			;displaying the final key
		movzx eax, keyarray5[esi]
		call writeInt
		inc esi
	loop L6
	mov edx, OFFSET Rbracket
	call WriteString
	call Crlf

	ret
DisplayKey5 ENDP

;--------------DISPLAY KEY PROCEDURE key size = 6------------------------
DisplayKey6 PROC
	call Crlf
	mov eax, yellow
	call SetTextColor
	mov edx, OFFSET prompt11
	call WriteString
	mov edx, OFFSET Lbracket
	call WriteString
	movzx ecx, ksize
	mov esi, 0
	L18:
		mov edx, OFFSET posarray6			;displaying the positions
		movzx eax, posarray6[esi]
		call writeInt
		inc esi
	loop L18
	mov edx, OFFSET Rbracket
	call WriteString
	call Crlf

	mov edx, OFFSET prompt6
	call WriteString
	mov edx, OFFSET Lbracket
	call WriteString
	movzx ecx, ksize
	mov esi, 0
	L16:
		mov edx, OFFSET keyarray6			;displaying the final key
		movzx eax, keyarray6[esi]
		call writeInt
		inc esi
	loop L16
	mov edx, OFFSET Rbracket
	call WriteString
	call Crlf

	ret
DisplayKey6 ENDP

;-----------------------------KEYSIZE 5 checking procedure------------------
KeySize5 PROC
	mov ecx, 5							;code for user entering in key of size 5 (range 0-4)
	mov esi, 0
	L2:
	
		push esi
		push ecx 
		mov edx, OFFSET prompt3
		call WriteString
		Next:
			call ReadInt
			cmp eax, 4
			ja OutOfRange
			cmp eax, 0
			jb OutOfRange
		;-------------------loop comparing values entered with ones in the array----------------------
		mov ecx, 5
		mov esi, 0
		L5:
			cmp al, keyarray5[esi]
			je Repeats
			inc esi
		loop L5
		jmp Done
		;-------------------------------------------------

		OutOfRange:
			mov edx, OFFSET prompt4
			call WriteString
			jmp Next

		Repeats:
			mov edx, OFFSET prompt5
			call WriteString
			jmp Next
		Done:
			pop ecx
			pop esi
			mov keyarray5[esi], al
			inc esi
	loop L2

ret
KeySize5 ENDP


;--------------KEY6 checking procedure-----------------------
KeySize6 PROC
	mov ecx, 6							;code for user entering in key of size 5 (range 0-4)
	mov esi, 0
	L11:
	
		push esi
		push ecx 
		mov edx, OFFSET prompt9
		call WriteString
		Next:
			call ReadInt
			cmp eax, 5
			ja OutOfRange
			cmp eax, 0
			jb OutOfRange
		;-------------------loop comparing values entered with ones in the array----------------------
		mov ecx, 6
		mov esi, 0
		L12:
			cmp al, keyarray6[esi]
			je Repeats
			inc esi
		loop L12
		jmp Done
		;-------------------------------------------------

		OutOfRange:
			mov edx, OFFSET prompt10
			call WriteString
			jmp Next

		Repeats:
			mov edx, OFFSET prompt5
			call WriteString
			jmp Next
		Done:
			pop ecx
			pop esi
			mov keyarray6[esi], al
			inc esi
	loop L11

ret
KeySize6 ENDP

;---------------Display procedure-------------------------
Display PROC
;display arrays
	mov eax, (cyan)
	call SetTextColor
	mov edx, OFFSET prompt7
	call WriteString
	mov edx, OFFSET lbrace								;"{"
	call WriteString
	mov edx, OFFSET plainTextArray
	call Writestring
	call Crlf
	mov eax, (red)
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

;-------------------------END DISPLAy PROCEDURE KeyArray Size = 5----------
innerloop5 PROC

L4:
		
		mov al, plainTextArray[SIZEOF keyarray5 + ebp]	
		movzx esi,keyarray5[ebx]	
		push ebx
		push eax
		push esi
		mov eax, SIZEOF keyarray5
		movzx ebx, x
		mul ebx	
		pop esi					;product is in edx
		add eax, esi 
		mov edx, eax
		mov eax, 0					 
		pop eax
		mov cipherTextArray[edx],al
		pop ebx						;?????????
		inc ebx		
		inc ebp
		
		
		loop L4

ret
innerloop5 ENDP


;---------------END DISPLAY PROCEDURE KeyArray Size = 6----------------------------
innerloop6 PROC

L15:
		
		mov al, plainTextArray[SIZEOF keyarray6 + ebp]	
		movzx esi,keyarray6[ebx]	
		push ebx
		push eax
		push esi
		mov eax, SIZEOF keyarray6
		movzx ebx, x
		mul ebx	
		pop esi					;product is in edx
		add eax, esi 
		mov edx, eax
		mov eax, 0					 
		pop eax
		mov cipherTextArray[edx],al
		pop ebx						;?????????
		inc ebx		
		inc ebp
		
		
		loop L15

ret
innerloop6 ENDP
;-----------------------------------------------







END main
