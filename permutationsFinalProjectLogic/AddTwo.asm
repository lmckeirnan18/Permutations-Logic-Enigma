TITLE Add and Subtract,           (AddSub2.asm)
;Lily McKeirnan
;permutation logic for final project Enigma Assembler

INCLUDE Irvine32.inc
;-----------------------------------------------------
.data


prompt1 BYTE "Enter a plainText: ",0
;prompt2 BYTE "Enter in a key size: ",0
prompt3 BYTE "Enter in a key number value (using numbers 0-4 scrambled up): ",0

;plainTextArray BYTE "h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d", " ", "f", "o", "u", "r",0
;plainTextArray BYTE "hello world four",0

plainTextArray BYTE 100 DUP(0)
byteCount DWORD ?

;keyArray BYTE 3, 2, 1, 0,4

keyArray BYTE 5 DUP(0)		;???????????????

cipherTextArray BYTE SIZEOF plainTextArray DUP(0)
x BYTE ?							;variable we use in L3 and InnerLoop PROC
cipherTextString BYTE ?				;new array




;----------------------------------------------
.code

main PROC

mov edx, OFFSET prompt1
call WriteString
mov edx, OFFSET plainTextArray
mov ecx, SIZEOF plainTextArray
call ReadString
mov byteCount, eax

mov ecx, 5
mov esi, 0
L2:
	mov edx, OFFSET prompt3
	call WriteString
	call ReadInt
	mov keyArray[esi], al
	inc esi
loop L2







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

;loop L2
;----------------------------------------------------------------------
	;display arrays
	mov edx, OFFSET plainTextArray
	call Writestring
	call Crlf
	mov edx, OffSET cipherTextArray
	call Writestring
	call Crlf


	exit
main ENDP

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
