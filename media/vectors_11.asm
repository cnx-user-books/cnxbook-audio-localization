*Vectors_11.asm Vector file for interrupt-driven program

    		.ref 		_c_int12    ;ISR used in C program
    		.ref     	_c_int00	;entry address
		.sect   	"vectors"	;section for vectors
RESET_RST:	mvkl	.S2	_c_int00,B0	;lower 16 bits --> B0
    		mvkh  .S2   _c_int00,B0 ;upper 16 bits --> B0
    		B	.S2	B0 		;branch to entry address
		NOP      			;NOPs for remainder of FP
		NOP				;to fill 0x20 Bytes
		NOP
		NOP
		NOP	
NMI_RST: 	.loop 8
		NOP    			;fill with 8 NOPs
		.endloop 
RESV1:	.loop 8
		NOP 				
		.endloop
RESV2:	.loop 8
		NOP				
		.endloop
INT4: 	.loop 8
		NOP  				
		.endloop
INT5: 	.loop 8
		NOP
		.endloop
INT6:  	.loop 8
		NOP
		.endloop
INT7:		.loop 8
		NOP
		.endloop
INT8: 	.loop 8
		NOP
		.endloop
INT9:		.loop 8
		NOP
		.endloop
INT10:	.loop 8
		NOP
		.endloop

INT11: 	.loop 8	
		NOP
		.endloop

INT12: 	b 	_c_int12		;branch to ISR
		.loop 7	
		NOP
		.endloop
		
INT13:	.loop 8
		NOP
		.endloop
INT14: 	.loop 8
		NOP
		.endloop
INT15: 	.loop 8
		NOP
		.endloop

