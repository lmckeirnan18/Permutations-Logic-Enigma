TITLE Add and Subtract,           (AddSub2.asm)
;Lily McKeirnan
;permutation logic for final project Enigma Assembler

INCLUDE Irvine32.inc
;-----------------------------------------------------
.data


prompt1 BYTE "Enter a plainText: ",0
;prompt2 BYTE "Enter in a key size: ",0
prompt3 BYTE "Enter in a key number value (using numbers 0-4 scrambled up): ",0
prompt4 BYTE "Values were outside the range of 0-4 inclusive. Try again: ",0
prompt5 BYTE "You repeated a value, try again: ",0
prompt6 BYTE "Your Key: ",0
prompt7 BYTE "Plaintext:  ",0
prompt8 BYTE "Cipher Text: ",0

;plainTextArray BYTE "h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d", " ", "f", "o", "u", "r",0
;plainTextArray BYTE "hello world four",0

plainTextArray BYTE 100 DUP(0)
byteCount DWORD ?

;keyArray BYTE 3, 2, 1, 0,4

keyArray BYTE 5 DUP('#')		;???????????????

cipherTextArray BYTE SIZEOF plainTextArray DUP(0)
x BYTE ?							;variable we use in L3 and InnerLoop PROC
cipherTextString BYTE ?				;new array




.code

;--------------MAIN PROC--------------------------------
main PROC

mov edx, OFFSET prompt1				;code for user inputing in plaintext 
call WriteString
mov edx, OFFSET plainTextArray
mov ecx, SIZEOF plainTextArray
call ReadString
mov byteCount, eax

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
		cmp al, keyArray[esi]
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
		mov keyArray[esi], al
		inc esi
loop L2
;----------------------------------------------------------------------
call Crlf
mov edx, OFFSET prompt6
call WriteString

mov ecx, 5
mov esi, 0
L6:
	mov edx, OFFSET keyArray			;displaying the final key
	movzx eax, keyArray[esi]
	call writeInt
	inc esi
loop L6
call Crlf
;--------------------------------------------




;-----------------------------------------;can only be 0-3 (size of key)
mov ecx, SIZEOF keyArray
mov esi, 0 
mov ebx, 0
mov eax, 0
L1:
	mov al, plainTextArray[ebx]			;putting first element in al
	movzx esi, keyArray[ebx]			;putting position to move the element into esi
	mov cipherTextArray[esi],al			;putting element into the new position
	inc ebx
loop L1
;---------------------------------------------------------------;need new loop for anything above size of key and need to do modulous
mov ecx, SIZEOF plainTextArray - SIZEOF keyArray				;do this loop for the rest of the elements in plainTextArray (12-4=8)????? do we need this???
mov ebx, 0														;counter for moving along along in the array??
mov eax, 0
mov ebp, 0
mov edx, 0

;L2:																;do this 8 times (plainTextArray size - keyArray size)

mov al, plainTextArray[SIZEOF keyArray + ebp]					;get the letter from the plaintext
movzx esi,keyArray[ebx]											;get the position from the keyArray

cmp esi, SIZEOF keyArray										;deciding if we need to mod to be able to apply the key array position elements 
jb lcipher						;????????????????

mov edi, SIZEOF keyArray
mov dx, 2
mul dx
add esi,edi				;????????????????????


lcipher:				;this is a jump
	push ecx
	mov ecx, (SIZEOF plainTextArray - SIZEOF keyArray)/(SIZEOF keyArray)

	mov x, 1
	L3:
	
	push ecx
	mov ecx, SIZEOF keyArray

		Call InnerLoop						;procedure defined below
	
	pop ecx
	inc x
	mov ebx, 0
	loop L3

	;pop esi
	pop ecx

cmp ebx, SIZEOF keyArray
jb lend									;need to check if it is larger than size of keyArray 

mov dx, 0											;so need to mod 4
mov ax, SIZEOF keyArray
div ax						;divide ebx by ax???
movzx ebx, dx										;need to have 8 and 3 at same time

lend:

;----------------------------------------------------------------------
	;display arrays
	mov edx, OFFSET prompt7
	call WriteString
	mov edx, OFFSET plainTextArray
	call Writestring
	call Crlf
	mov edx, OFFSET prompt8
	call WriteString
	mov edx, OffSET cipherTextArray
	call Writestring
	call Crlf
	cal Crlf


	exit
main ENDP

;----------------------------END MAIN---------------------------------------

InnerLoop PROC
L4:
		
		mov al, plainTextArray[SIZEOF keyArray + ebp]	
		movzx esi,keyArray[ebx]	
		push ebx
		push eax
		push esi
		mov eax, SIZEOF keyArray
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
InnerLoop ENDP

END main
