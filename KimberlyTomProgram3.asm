TITLE Negative Number Accumulator     (KimberlyTomProgram3.asm)

; Author: Kimberly Tom
; Last Modified: 10/25/18
; OSU email address: tomki@oregonstate.edu
; Course number/section: 271/400
; Project Number: 3                Due Date: 10/28/18
; Description: This program asks user for negative numbers and calculates the sum and average of those numbers

INCLUDE Irvine32.inc

CONST_MIN = -100
CONST_MAX = -1

.data

title_1		BYTE	"Negative Number Accumulator		by Kimberly Tom", 0
EC1			BYTE	"**EC1: Numbered lines during user input", 0
EC2			BYTE	"**EC2: Program will display average as floating point number to the nearest .001.", 0
EC3			BYTE	"**EC3: Program shows alert message if user inputs invalid data.", 0
caption 	db 		"Alert", 0
AlertMsg 	BYTE 	"You entered an invalid integer. I will now provide calculations.", 0dh,0ah
			BYTE 	"Click OK to continue...", 0
prompt_1	BYTE	"What's your name? ", 0
intro_1		BYTE	"Nice to meet you, ",0
userName	BYTE	33 DUP(0)																;string to be entered by user
intro_2		BYTE	"Enter negative integers in the range of [-100..-1] and I will give you the sum and average.", 0
intro_3		BYTE	"If the integer you entered is not in range, I will calculate the sum and average exclusing your last integer.", 0
invalid_1	BYTE	"You did not enter any non negative integers so I have no calculation for you.", 0
prompt_2	BYTE	"  Enter a number: ", 0
intCount	DWORD	0																		;holds the number of integers the user is about to enter
accumulator	DWORD	0																		;holds the sum of the non negative numbers the user has entered
countForAvg	DWORD	?																		;holds actual count
validNum_1	BYTE	"You entered ", 0
validNum_2	BYTE	" valid numbers.", 0
totalSum	BYTE	"The sum of your valid numbers are: ", 0
avgRounded	BYTE	"The rounded average of your valid numbers are: ", 0
avgFP		BYTE	"The floating point average of your valid numbers are: ", 0
thousand	DWORD	1000																	;used to multiply by 1000	
neg1		DWORD	-1																		;used to multiple by -1
FPx1000		DWORD	0																		;to store number multiplied by 1000	
negSign		BYTE	"-", 0																	;negative sign
decimal1	BYTE	".", 0																	;decimal point
leftDec		DWORD	?																		;number to left of decimal point
rightDec	DWORD	?																		;number to right of decimal point
temporary	DWORD	?																		;holds a temporary value
goodBye		BYTE	"I hope you enjoyed this program. Good Bye, ", 0

.code
main PROC

	mov		edx, OFFSET title_1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET EC1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET EC2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET EC3
	call	WriteString
	call	Crlf
	call	Crlf

;Get user name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	call	Crlf
	
;greet user
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

;userInstructions
	mov		edx, OFFSET intro_2
	call	WriteString
	call	Crlf

;getUserData
;obtain numbers from user
GetTerms: 
	mov		eax, intCount								
	add		eax, 1										;to display line number during user input
	call	WriteDec
	mov		intCount, eax
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt

;input validation as integer must be [-100..-1]. Loop to get more terms if user entered a valid integer
	cmp		eax, CONST_MIN
	jl		Calculate									;if user term less than -100, it is invalid, jump to Invalid
	cmp		eax, CONST_MAX
	jg		Calculate									;if user term greater than -1, it is invalid, jump to Invalid
	add		accumulator, eax					
	loop	GetTerms									;loop if integers are valid

;Verify that user has entered atleast one valid integer then display the sum of valid integers. If no valid integer, inform user
Calculate:
	mov		ebx, OFFSET caption
	mov		edx, OFFSET AlertMsg
	call	MsgBox
	mov		eax, intCount
	sub		eax, 1
	jz		Invalid										;if intCount is zero, then user provided no valid integers
	mov		countForAvg, eax

;display the sum
	mov		edx, OFFSET validNum_1
	call	WriteString
	call	WriteDec
	mov		edx, OFFSET	validNum_2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET totalSum
	call	WriteString
	mov		eax, accumulator
	call	WriteInt
	call	Crlf

;calculate and display the rounded average
	mov		eax, accumulator
	cdq
	mov		ebx, countForAvg
	idiv	ebx
	mov		edx, OFFSET avgRounded
	call	WriteString
	call	WriteInt
	call	Crlf

;floating point division
	mov		eax, accumulator
	mul		neg1
	mov		accumulator, eax
	fld		accumulator		
	fdiv	countforAvg		
	fimul	thousand		
	frndint
	fist	FPx1000										;floating point answer multipled by 1000
	
;print floating point division results
	mov		edx, OFFSET AvgFP
	call	WriteString

	mov		edx, 0
	mov		eax, FPx1000
	cdq
	mov		ebx, 1000
	cdq
	div		ebx
	mov		leftDec, eax			
	mov		eax, leftDec
	mov		edx, OFFSET negSign
	call	WriteString
	call	WriteDec									;display numbers left a decimal point
	mov		edx, OFFSET decimal1	
	call	WriteString									;display decimal point
	mov		eax, leftDec			
	mul		thousand
	mov		temporary, eax
	mov		eax, FPx1000
	sub		eax, temporary								;subtract to be only left with the right hand portion (gets rid of left hand portion)
	mov		rightDec, eax	
	call	WriteDec									;display numbers right of decimal point
	call	CrLf
	call	CrLf

	jmp		TheEnd

;informs user that no valid integers were entered
Invalid:
	mov		edx, OFFSET invalid_1
	call	WriteString
	call	Crlf
	
;farewell
TheEnd:
	call	Crlf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP


END main
