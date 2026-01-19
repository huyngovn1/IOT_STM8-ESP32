   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  64                     ; 10 void delay_us(uint8_t us) {
  66                     	switch	.text
  67  0000               _delay_us:
  69  0000 88            	push	a
  70  0001 88            	push	a
  71       00000001      OFST:	set	1
  74                     ; 12     for (i = 0; i < us; i++) {
  76  0002 0f01          	clr	(OFST+0,sp)
  78  0004 200c          	jra	L73
  79  0006               L33:
  80                     ; 13         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
  83  0006 9d            nop
  88  0007 9d            nop
  93  0008 9d            nop
  98  0009 9d            nop
 100                     ; 14         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 103  000a 9d            nop
 108  000b 9d            nop
 113  000c 9d            nop
 118  000d 9d            nop
 120                     ; 15         _asm("nop"); _asm("nop");
 123  000e 9d            nop
 128  000f 9d            nop
 130                     ; 12     for (i = 0; i < us; i++) {
 132  0010 0c01          	inc	(OFST+0,sp)
 133  0012               L73:
 136  0012 7b01          	ld	a,(OFST+0,sp)
 137  0014 1102          	cp	a,(OFST+1,sp)
 138  0016 25ee          	jrult	L33
 139                     ; 17 }
 142  0018 85            	popw	x
 143  0019 81            	ret
 168                     ; 21 void i2c_init(void) {
 169                     	switch	.text
 170  001a               _i2c_init:
 174                     ; 22     GPIO_Init(I2C_PORT, I2C_SCL_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
 176  001a 4bb0          	push	#176
 177  001c 4b10          	push	#16
 178  001e ae5005        	ldw	x,#20485
 179  0021 cd0000        	call	_GPIO_Init
 181  0024 85            	popw	x
 182                     ; 23     GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
 184  0025 4bb0          	push	#176
 185  0027 4b20          	push	#32
 186  0029 ae5005        	ldw	x,#20485
 187  002c cd0000        	call	_GPIO_Init
 189  002f 85            	popw	x
 190                     ; 24     GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN | I2C_SDA_PIN);
 192  0030 4b30          	push	#48
 193  0032 ae5005        	ldw	x,#20485
 194  0035 cd0000        	call	_GPIO_WriteHigh
 196  0038 84            	pop	a
 197                     ; 25 }
 200  0039 81            	ret
 226                     ; 27 void i2c_start(void) {
 227                     	switch	.text
 228  003a               _i2c_start:
 232                     ; 28     GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
 234  003a 4b20          	push	#32
 235  003c ae5005        	ldw	x,#20485
 236  003f cd0000        	call	_GPIO_WriteHigh
 238  0042 84            	pop	a
 239                     ; 29     GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN);
 241  0043 4b10          	push	#16
 242  0045 ae5005        	ldw	x,#20485
 243  0048 cd0000        	call	_GPIO_WriteHigh
 245  004b 84            	pop	a
 246                     ; 30     delay_us(5);
 248  004c a605          	ld	a,#5
 249  004e adb0          	call	_delay_us
 251                     ; 31     GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
 253  0050 4b20          	push	#32
 254  0052 ae5005        	ldw	x,#20485
 255  0055 cd0000        	call	_GPIO_WriteLow
 257  0058 84            	pop	a
 258                     ; 32     delay_us(5);
 260  0059 a605          	ld	a,#5
 261  005b ada3          	call	_delay_us
 263                     ; 33     GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);
 265  005d 4b10          	push	#16
 266  005f ae5005        	ldw	x,#20485
 267  0062 cd0000        	call	_GPIO_WriteLow
 269  0065 84            	pop	a
 270                     ; 34     delay_us(5);
 272  0066 a605          	ld	a,#5
 273  0068 ad96          	call	_delay_us
 275                     ; 35 }
 278  006a 81            	ret
 304                     ; 37 void i2c_stop(void) {
 305                     	switch	.text
 306  006b               _i2c_stop:
 310                     ; 38     GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
 312  006b 4b20          	push	#32
 313  006d ae5005        	ldw	x,#20485
 314  0070 cd0000        	call	_GPIO_WriteLow
 316  0073 84            	pop	a
 317                     ; 39     GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);
 319  0074 4b10          	push	#16
 320  0076 ae5005        	ldw	x,#20485
 321  0079 cd0000        	call	_GPIO_WriteLow
 323  007c 84            	pop	a
 324                     ; 40     delay_us(5);
 326  007d a605          	ld	a,#5
 327  007f cd0000        	call	_delay_us
 329                     ; 41     GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN);
 331  0082 4b10          	push	#16
 332  0084 ae5005        	ldw	x,#20485
 333  0087 cd0000        	call	_GPIO_WriteHigh
 335  008a 84            	pop	a
 336                     ; 42     delay_us(5);
 338  008b a605          	ld	a,#5
 339  008d cd0000        	call	_delay_us
 341                     ; 43     GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
 343  0090 4b20          	push	#32
 344  0092 ae5005        	ldw	x,#20485
 345  0095 cd0000        	call	_GPIO_WriteHigh
 347  0098 84            	pop	a
 348                     ; 44     delay_us(5);
 350  0099 a605          	ld	a,#5
 351  009b cd0000        	call	_delay_us
 353                     ; 45 }
 356  009e 81            	ret
 413                     ; 47 uint8_t i2c_write_byte(uint8_t data) {
 414                     	switch	.text
 415  009f               _i2c_write_byte:
 417  009f 88            	push	a
 418  00a0 88            	push	a
 419       00000001      OFST:	set	1
 422                     ; 49     for (i = 0; i < 8; i++) {
 424  00a1 0f01          	clr	(OFST+0,sp)
 425  00a3               L121:
 426                     ; 50         if (data & 0x80) GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
 428  00a3 7b02          	ld	a,(OFST+1,sp)
 429  00a5 a580          	bcp	a,#128
 430  00a7 270b          	jreq	L721
 433  00a9 4b20          	push	#32
 434  00ab ae5005        	ldw	x,#20485
 435  00ae cd0000        	call	_GPIO_WriteHigh
 437  00b1 84            	pop	a
 439  00b2 2009          	jra	L131
 440  00b4               L721:
 441                     ; 51         else GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
 443  00b4 4b20          	push	#32
 444  00b6 ae5005        	ldw	x,#20485
 445  00b9 cd0000        	call	_GPIO_WriteLow
 447  00bc 84            	pop	a
 448  00bd               L131:
 449                     ; 52         data <<= 1;
 451  00bd 0802          	sll	(OFST+1,sp)
 452                     ; 53         GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
 454  00bf 4b10          	push	#16
 455  00c1 ae5005        	ldw	x,#20485
 456  00c4 cd0000        	call	_GPIO_WriteHigh
 458  00c7 84            	pop	a
 461  00c8 a605          	ld	a,#5
 462  00ca cd0000        	call	_delay_us
 464                     ; 54         GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);  delay_us(5);
 466  00cd 4b10          	push	#16
 467  00cf ae5005        	ldw	x,#20485
 468  00d2 cd0000        	call	_GPIO_WriteLow
 470  00d5 84            	pop	a
 473  00d6 a605          	ld	a,#5
 474  00d8 cd0000        	call	_delay_us
 476                     ; 49     for (i = 0; i < 8; i++) {
 478  00db 0c01          	inc	(OFST+0,sp)
 481  00dd 7b01          	ld	a,(OFST+0,sp)
 482  00df a108          	cp	a,#8
 483  00e1 25c0          	jrult	L121
 484                     ; 56     GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_IN_FL_NO_IT);
 486  00e3 4b00          	push	#0
 487  00e5 4b20          	push	#32
 488  00e7 ae5005        	ldw	x,#20485
 489  00ea cd0000        	call	_GPIO_Init
 491  00ed 85            	popw	x
 492                     ; 57     GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
 494  00ee 4b10          	push	#16
 495  00f0 ae5005        	ldw	x,#20485
 496  00f3 cd0000        	call	_GPIO_WriteHigh
 498  00f6 84            	pop	a
 501  00f7 a605          	ld	a,#5
 502  00f9 cd0000        	call	_delay_us
 504                     ; 58     nack = GPIO_ReadInputPin(I2C_PORT, I2C_SDA_PIN);
 506  00fc 4b20          	push	#32
 507  00fe ae5005        	ldw	x,#20485
 508  0101 cd0000        	call	_GPIO_ReadInputPin
 510  0104 5b01          	addw	sp,#1
 511  0106 6b01          	ld	(OFST+0,sp),a
 512                     ; 59     GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN); delay_us(5);
 514  0108 4b10          	push	#16
 515  010a ae5005        	ldw	x,#20485
 516  010d cd0000        	call	_GPIO_WriteLow
 518  0110 84            	pop	a
 521  0111 a605          	ld	a,#5
 522  0113 cd0000        	call	_delay_us
 524                     ; 60     GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
 526  0116 4bb0          	push	#176
 527  0118 4b20          	push	#32
 528  011a ae5005        	ldw	x,#20485
 529  011d cd0000        	call	_GPIO_Init
 531  0120 85            	popw	x
 532                     ; 61     return nack;
 534  0121 7b01          	ld	a,(OFST+0,sp)
 537  0123 85            	popw	x
 538  0124 81            	ret
 595                     ; 64 uint8_t i2c_read_byte(uint8_t send_ack) {
 596                     	switch	.text
 597  0125               _i2c_read_byte:
 599  0125 88            	push	a
 600  0126 89            	pushw	x
 601       00000002      OFST:	set	2
 604                     ; 65     uint8_t i, data = 0;
 606  0127 0f02          	clr	(OFST+0,sp)
 607                     ; 66     GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_IN_FL_NO_IT);
 609  0129 4b00          	push	#0
 610  012b 4b20          	push	#32
 611  012d ae5005        	ldw	x,#20485
 612  0130 cd0000        	call	_GPIO_Init
 614  0133 85            	popw	x
 615                     ; 67     for (i = 0; i < 8; i++) {
 617  0134 0f01          	clr	(OFST-1,sp)
 618  0136               L161:
 619                     ; 68         data <<= 1;
 621  0136 0802          	sll	(OFST+0,sp)
 622                     ; 69         GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
 624  0138 4b10          	push	#16
 625  013a ae5005        	ldw	x,#20485
 626  013d cd0000        	call	_GPIO_WriteHigh
 628  0140 84            	pop	a
 631  0141 a605          	ld	a,#5
 632  0143 cd0000        	call	_delay_us
 634                     ; 70         if (GPIO_ReadInputPin(I2C_PORT, I2C_SDA_PIN)) data |= 1;
 636  0146 4b20          	push	#32
 637  0148 ae5005        	ldw	x,#20485
 638  014b cd0000        	call	_GPIO_ReadInputPin
 640  014e 5b01          	addw	sp,#1
 641  0150 4d            	tnz	a
 642  0151 2706          	jreq	L761
 645  0153 7b02          	ld	a,(OFST+0,sp)
 646  0155 aa01          	or	a,#1
 647  0157 6b02          	ld	(OFST+0,sp),a
 648  0159               L761:
 649                     ; 71         GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN); delay_us(5);
 651  0159 4b10          	push	#16
 652  015b ae5005        	ldw	x,#20485
 653  015e cd0000        	call	_GPIO_WriteLow
 655  0161 84            	pop	a
 658  0162 a605          	ld	a,#5
 659  0164 cd0000        	call	_delay_us
 661                     ; 67     for (i = 0; i < 8; i++) {
 663  0167 0c01          	inc	(OFST-1,sp)
 666  0169 7b01          	ld	a,(OFST-1,sp)
 667  016b a108          	cp	a,#8
 668  016d 25c7          	jrult	L161
 669                     ; 73     GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
 671  016f 4bb0          	push	#176
 672  0171 4b20          	push	#32
 673  0173 ae5005        	ldw	x,#20485
 674  0176 cd0000        	call	_GPIO_Init
 676  0179 85            	popw	x
 677                     ; 74     if (send_ack) GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
 679  017a 0d03          	tnz	(OFST+1,sp)
 680  017c 270b          	jreq	L171
 683  017e 4b20          	push	#32
 684  0180 ae5005        	ldw	x,#20485
 685  0183 cd0000        	call	_GPIO_WriteLow
 687  0186 84            	pop	a
 689  0187 2009          	jra	L371
 690  0189               L171:
 691                     ; 75     else GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
 693  0189 4b20          	push	#32
 694  018b ae5005        	ldw	x,#20485
 695  018e cd0000        	call	_GPIO_WriteHigh
 697  0191 84            	pop	a
 698  0192               L371:
 699                     ; 76     GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
 701  0192 4b10          	push	#16
 702  0194 ae5005        	ldw	x,#20485
 703  0197 cd0000        	call	_GPIO_WriteHigh
 705  019a 84            	pop	a
 708  019b a605          	ld	a,#5
 709  019d cd0000        	call	_delay_us
 711                     ; 77     GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);  delay_us(5);
 713  01a0 4b10          	push	#16
 714  01a2 ae5005        	ldw	x,#20485
 715  01a5 cd0000        	call	_GPIO_WriteLow
 717  01a8 84            	pop	a
 720  01a9 a605          	ld	a,#5
 721  01ab cd0000        	call	_delay_us
 723                     ; 78     GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);  
 725  01ae 4b20          	push	#32
 726  01b0 ae5005        	ldw	x,#20485
 727  01b3 cd0000        	call	_GPIO_WriteHigh
 729  01b6 84            	pop	a
 730                     ; 79     return data;
 732  01b7 7b02          	ld	a,(OFST+0,sp)
 735  01b9 5b03          	addw	sp,#3
 736  01bb 81            	ret
 749                     	xdef	_delay_us
 750                     	xdef	_i2c_read_byte
 751                     	xdef	_i2c_write_byte
 752                     	xdef	_i2c_stop
 753                     	xdef	_i2c_start
 754                     	xdef	_i2c_init
 755                     	xref	_GPIO_ReadInputPin
 756                     	xref	_GPIO_WriteLow
 757                     	xref	_GPIO_WriteHigh
 758                     	xref	_GPIO_Init
 777                     	end
