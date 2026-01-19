   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  73                     ; 17 void delay_ms (int ms) //milli second delay
  73                     ; 18 {
  75                     	switch	.text
  76  0000               _delay_ms:
  78  0000 89            	pushw	x
  79  0001 5204          	subw	sp,#4
  80       00000004      OFST:	set	4
  83                     ; 19   int a =0 ;
  85                     ; 20   int b=0;
  87                     ; 21   for (a=0; a<=ms; a++)
  89  0003 5f            	clrw	x
  90  0004 1f01          	ldw	(OFST-3,sp),x
  92  0006 201a          	jra	L34
  93  0008               L73:
  94                     ; 23     for (b=0; b<120; b++) 
  96  0008 5f            	clrw	x
  97  0009 1f03          	ldw	(OFST-1,sp),x
  98  000b               L74:
  99                     ; 24       _asm("nop"); //Perform no operation 
 102  000b 9d            nop
 104                     ; 23     for (b=0; b<120; b++) 
 106  000c 1e03          	ldw	x,(OFST-1,sp)
 107  000e 1c0001        	addw	x,#1
 108  0011 1f03          	ldw	(OFST-1,sp),x
 111  0013 9c            	rvf
 112  0014 1e03          	ldw	x,(OFST-1,sp)
 113  0016 a30078        	cpw	x,#120
 114  0019 2ff0          	jrslt	L74
 115                     ; 21   for (a=0; a<=ms; a++)
 117  001b 1e01          	ldw	x,(OFST-3,sp)
 118  001d 1c0001        	addw	x,#1
 119  0020 1f01          	ldw	(OFST-3,sp),x
 120  0022               L34:
 123  0022 9c            	rvf
 124  0023 1e01          	ldw	x,(OFST-3,sp)
 125  0025 1305          	cpw	x,(OFST+1,sp)
 126  0027 2ddf          	jrsle	L73
 127                     ; 26 }
 130  0029 5b06          	addw	sp,#6
 131  002b 81            	ret
 171                     ; 28 void PCF7584write8(u8 iData) // Write all 8 pins of PCF7584
 171                     ; 29 {
 172                     	switch	.text
 173  002c               _PCF7584write8:
 175  002c 88            	push	a
 176       00000000      OFST:	set	0
 179                     ; 30 	I2C_GenerateSTART(ENABLE);
 181  002d a601          	ld	a,#1
 182  002f cd0000        	call	_I2C_GenerateSTART
 185  0032               L57:
 186                     ; 31 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 188  0032 ae0301        	ldw	x,#769
 189  0035 cd0000        	call	_I2C_CheckEvent
 191  0038 4d            	tnz	a
 192  0039 27f7          	jreq	L57
 193                     ; 32 	I2C_Send7bitAddress(LCD_I2C_Address, I2C_DIRECTION_TX);
 195  003b ae4e00        	ldw	x,#19968
 196  003e cd0000        	call	_I2C_Send7bitAddress
 199  0041               L301:
 200                     ; 33 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
 202  0041 ae0782        	ldw	x,#1922
 203  0044 cd0000        	call	_I2C_CheckEvent
 205  0047 4d            	tnz	a
 206  0048 27f7          	jreq	L301
 207                     ; 34 	I2C_SendData(iData);
 209  004a 7b01          	ld	a,(OFST+1,sp)
 210  004c cd0000        	call	_I2C_SendData
 213  004f               L111:
 214                     ; 35 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 216  004f ae0784        	ldw	x,#1924
 217  0052 cd0000        	call	_I2C_CheckEvent
 219  0055 4d            	tnz	a
 220  0056 27f7          	jreq	L111
 221                     ; 36 	I2C_GenerateSTOP(ENABLE);
 223  0058 a601          	ld	a,#1
 224  005a cd0000        	call	_I2C_GenerateSTOP
 226                     ; 37   currentValue=iData;
 228  005d 7b01          	ld	a,(OFST+1,sp)
 229  005f b70c          	ld	_currentValue,a
 230                     ; 38 }
 233  0061 84            	pop	a
 234  0062 81            	ret
 279                     ; 40 void PCF7584write(uint8_t pin, uint8_t value) // Write selected pin of PCF7584
 279                     ; 41 {
 280                     	switch	.text
 281  0063               _PCF7584write:
 283  0063 89            	pushw	x
 284       00000000      OFST:	set	0
 287                     ; 42       if (value == 0)
 289  0064 9f            	ld	a,xl
 290  0065 4d            	tnz	a
 291  0066 2613          	jrne	L731
 292                     ; 44           currentValue &= ~(1 << pin); // Set the pin value 0 or 1
 294  0068 9e            	ld	a,xh
 295  0069 5f            	clrw	x
 296  006a 97            	ld	xl,a
 297  006b a601          	ld	a,#1
 298  006d 5d            	tnzw	x
 299  006e 2704          	jreq	L21
 300  0070               L41:
 301  0070 48            	sll	a
 302  0071 5a            	decw	x
 303  0072 26fc          	jrne	L41
 304  0074               L21:
 305  0074 43            	cpl	a
 306  0075 b40c          	and	a,_currentValue
 307  0077 b70c          	ld	_currentValue,a
 309  0079 2011          	jra	L141
 310  007b               L731:
 311                     ; 48           currentValue |= (1 << pin); // Set the pin value 0 or 1
 313  007b 7b01          	ld	a,(OFST+1,sp)
 314  007d 5f            	clrw	x
 315  007e 97            	ld	xl,a
 316  007f a601          	ld	a,#1
 317  0081 5d            	tnzw	x
 318  0082 2704          	jreq	L61
 319  0084               L02:
 320  0084 48            	sll	a
 321  0085 5a            	decw	x
 322  0086 26fc          	jrne	L02
 323  0088               L61:
 324  0088 ba0c          	or	a,_currentValue
 325  008a b70c          	ld	_currentValue,a
 326  008c               L141:
 327                     ; 50       PCF7584write8(currentValue);
 329  008c b60c          	ld	a,_currentValue
 330  008e ad9c          	call	_PCF7584write8
 332                     ; 51 }
 335  0090 85            	popw	x
 336  0091 81            	ret
 371                     ; 53 void LCD_SetBit(char data_bit) //Based on the Hex value Set the Bits of the Data Lines
 371                     ; 54 {
 372                     	switch	.text
 373  0092               _LCD_SetBit:
 375  0092 88            	push	a
 376       00000000      OFST:	set	0
 379                     ; 55     if(data_bit& 1) 
 381  0093 a501          	bcp	a,#1
 382  0095 2707          	jreq	L161
 383                     ; 56         PCF7584write(4,1); //D4 = 1
 385  0097 ae0401        	ldw	x,#1025
 386  009a adc7          	call	_PCF7584write
 389  009c 2005          	jra	L361
 390  009e               L161:
 391                     ; 58         PCF7584write(4,0); //D4 = 0
 393  009e ae0400        	ldw	x,#1024
 394  00a1 adc0          	call	_PCF7584write
 396  00a3               L361:
 397                     ; 60     if(data_bit& 2)
 399  00a3 7b01          	ld	a,(OFST+1,sp)
 400  00a5 a502          	bcp	a,#2
 401  00a7 2707          	jreq	L561
 402                     ; 61         PCF7584write(5,1); //D5 = 1
 404  00a9 ae0501        	ldw	x,#1281
 405  00ac adb5          	call	_PCF7584write
 408  00ae 2005          	jra	L761
 409  00b0               L561:
 410                     ; 63         PCF7584write(5,0); //D5 = 0
 412  00b0 ae0500        	ldw	x,#1280
 413  00b3 adae          	call	_PCF7584write
 415  00b5               L761:
 416                     ; 65     if(data_bit& 4)
 418  00b5 7b01          	ld	a,(OFST+1,sp)
 419  00b7 a504          	bcp	a,#4
 420  00b9 2707          	jreq	L171
 421                     ; 66         PCF7584write(6,1); //D6 = 1
 423  00bb ae0601        	ldw	x,#1537
 424  00be ada3          	call	_PCF7584write
 427  00c0 2005          	jra	L371
 428  00c2               L171:
 429                     ; 68         PCF7584write(6,0); //D6 = 0
 431  00c2 ae0600        	ldw	x,#1536
 432  00c5 ad9c          	call	_PCF7584write
 434  00c7               L371:
 435                     ; 70     if(data_bit& 8) 
 437  00c7 7b01          	ld	a,(OFST+1,sp)
 438  00c9 a508          	bcp	a,#8
 439  00cb 2707          	jreq	L571
 440                     ; 71         PCF7584write(7,1); //D7 = 1
 442  00cd ae0701        	ldw	x,#1793
 443  00d0 ad91          	call	_PCF7584write
 446  00d2 2005          	jra	L771
 447  00d4               L571:
 448                     ; 73         PCF7584write(7,0); //D7 = 0
 450  00d4 ae0700        	ldw	x,#1792
 451  00d7 ad8a          	call	_PCF7584write
 453  00d9               L771:
 454                     ; 74 }
 457  00d9 84            	pop	a
 458  00da 81            	ret
 495                     ; 76 void LCD_Cmd(char a)
 495                     ; 77 {
 496                     	switch	.text
 497  00db               _LCD_Cmd:
 499  00db 88            	push	a
 500       00000000      OFST:	set	0
 503                     ; 78     PCF7584write(0,0); //RS = 0          
 505  00dc 5f            	clrw	x
 506  00dd ad84          	call	_PCF7584write
 508                     ; 79     LCD_SetBit(a); //Incoming Hex value
 510  00df 7b01          	ld	a,(OFST+1,sp)
 511  00e1 adaf          	call	_LCD_SetBit
 513                     ; 80     PCF7584write(2,1); //EN  = 1         
 515  00e3 ae0201        	ldw	x,#513
 516  00e6 cd0063        	call	_PCF7584write
 518                     ; 81 		delay_ms(2);
 520  00e9 ae0002        	ldw	x,#2
 521  00ec cd0000        	call	_delay_ms
 523                     ; 82 		PCF7584write(2,0); //EN  = 0      
 525  00ef ae0200        	ldw	x,#512
 526  00f2 cd0063        	call	_PCF7584write
 528                     ; 83 }
 531  00f5 84            	pop	a
 532  00f6 81            	ret
 562                     .const:	section	.text
 563  0000               L03:
 564  0000 000f4240      	dc.l	1000000
 565                     ; 85  void LCD_Begin(void)
 565                     ; 86  {
 566                     	switch	.text
 567  00f7               _LCD_Begin:
 571                     ; 87 	  delay_ms(10);
 573  00f7 ae000a        	ldw	x,#10
 574  00fa cd0000        	call	_delay_ms
 576                     ; 88 	  Input_Clock = CLK_GetClockFreq()/1000000;  // Clock speed in MHz
 578  00fd cd0000        	call	_CLK_GetClockFreq
 580  0100 ae0000        	ldw	x,#L03
 581  0103 cd0000        	call	c_ludv
 583  0106 be02          	ldw	x,c_lreg+2
 584  0108 bf00          	ldw	_Input_Clock,x
 585                     ; 89     I2C_Init(100000, LCD_I2C_Address, I2C_DUTYCYCLE_2, I2C_ACK_CURR, I2C_ADDMODE_7BIT, Input_Clock);
 587  010a 3b0001        	push	_Input_Clock+1
 588  010d 4b00          	push	#0
 589  010f 4b01          	push	#1
 590  0111 4b00          	push	#0
 591  0113 ae004e        	ldw	x,#78
 592  0116 89            	pushw	x
 593  0117 ae86a0        	ldw	x,#34464
 594  011a 89            	pushw	x
 595  011b ae0001        	ldw	x,#1
 596  011e 89            	pushw	x
 597  011f cd0000        	call	_I2C_Init
 599  0122 5b0a          	addw	sp,#10
 600                     ; 90 	  PCF7584write8(0b00000000);
 602  0124 4f            	clr	a
 603  0125 cd002c        	call	_PCF7584write8
 605                     ; 91 	  LCD_SetBit(0x00);
 607  0128 4f            	clr	a
 608  0129 cd0092        	call	_LCD_SetBit
 610                     ; 92 	  delay_ms(1000); 
 612  012c ae03e8        	ldw	x,#1000
 613  012f cd0000        	call	_delay_ms
 615                     ; 93     LCD_Cmd(0x03);
 617  0132 a603          	ld	a,#3
 618  0134 ada5          	call	_LCD_Cmd
 620                     ; 94 	  delay_ms(5);
 622  0136 ae0005        	ldw	x,#5
 623  0139 cd0000        	call	_delay_ms
 625                     ; 95 		LCD_Cmd(0x03);
 627  013c a603          	ld	a,#3
 628  013e ad9b          	call	_LCD_Cmd
 630                     ; 96 	  delay_ms(11);
 632  0140 ae000b        	ldw	x,#11
 633  0143 cd0000        	call	_delay_ms
 635                     ; 97     LCD_Cmd(0x03); 
 637  0146 a603          	ld	a,#3
 638  0148 ad91          	call	_LCD_Cmd
 640                     ; 98     LCD_Cmd(0x02); //02H is used for Return home -> Clears the RAM and initializes the LCD
 642  014a a602          	ld	a,#2
 643  014c ad8d          	call	_LCD_Cmd
 645                     ; 99     LCD_Cmd(0x02); //02H is used for Return home -> Clears the RAM and initializes the LCD
 647  014e a602          	ld	a,#2
 648  0150 ad89          	call	_LCD_Cmd
 650                     ; 100     LCD_Cmd(0x08); //Select Row 1
 652  0152 a608          	ld	a,#8
 653  0154 ad85          	call	_LCD_Cmd
 655                     ; 101     LCD_Cmd(0x00); //Clear Row 1 Display
 657  0156 4f            	clr	a
 658  0157 ad82          	call	_LCD_Cmd
 660                     ; 102     LCD_Cmd(0x0C); //Select Row 2
 662  0159 a60c          	ld	a,#12
 663  015b cd00db        	call	_LCD_Cmd
 665                     ; 103     LCD_Cmd(0x00); //Clear Row 2 Display
 667  015e 4f            	clr	a
 668  015f cd00db        	call	_LCD_Cmd
 670                     ; 104     LCD_Cmd(0x06);
 672  0162 a606          	ld	a,#6
 673  0164 cd00db        	call	_LCD_Cmd
 675                     ; 105  }
 678  0167 81            	ret
 702                     ; 107 void LCD_Clear(void)
 702                     ; 108 {
 703                     	switch	.text
 704  0168               _LCD_Clear:
 708                     ; 109     LCD_Cmd(0); //Clear the LCD
 710  0168 4f            	clr	a
 711  0169 cd00db        	call	_LCD_Cmd
 713                     ; 110     LCD_Cmd(1); //Move the curser to first position
 715  016c a601          	ld	a,#1
 716  016e cd00db        	call	_LCD_Cmd
 718                     ; 111 }
 721  0171 81            	ret
 792                     ; 114 void LCD_Set_Cursor(char a, char b)
 792                     ; 115 {
 793                     	switch	.text
 794  0172               _LCD_Set_Cursor:
 796  0172 89            	pushw	x
 797  0173 89            	pushw	x
 798       00000002      OFST:	set	2
 801                     ; 117     if(a== 1)
 803  0174 9e            	ld	a,xh
 804  0175 a101          	cp	a,#1
 805  0177 261e          	jrne	L572
 806                     ; 119       temp = 0x80 + b - 1; //80H is used to move the curser
 808  0179 9f            	ld	a,xl
 809  017a ab7f          	add	a,#127
 810  017c 6b02          	ld	(OFST+0,sp),a
 811                     ; 120         z = temp>>4; //Lower 8-bits
 813  017e 7b02          	ld	a,(OFST+0,sp)
 814  0180 4e            	swap	a
 815  0181 a40f          	and	a,#15
 816  0183 6b01          	ld	(OFST-1,sp),a
 817                     ; 121         y = temp & 0x0F; //Upper 8-bits
 819  0185 7b02          	ld	a,(OFST+0,sp)
 820  0187 a40f          	and	a,#15
 821  0189 6b02          	ld	(OFST+0,sp),a
 822                     ; 122         LCD_Cmd(z); //Set Row
 824  018b 7b01          	ld	a,(OFST-1,sp)
 825  018d cd00db        	call	_LCD_Cmd
 827                     ; 123         LCD_Cmd(y); //Set Column
 829  0190 7b02          	ld	a,(OFST+0,sp)
 830  0192 cd00db        	call	_LCD_Cmd
 833  0195 2023          	jra	L772
 834  0197               L572:
 835                     ; 125     else if(a== 2)
 837  0197 7b03          	ld	a,(OFST+1,sp)
 838  0199 a102          	cp	a,#2
 839  019b 261d          	jrne	L772
 840                     ; 127         temp = 0xC0 + b - 1;
 842  019d 7b04          	ld	a,(OFST+2,sp)
 843  019f abbf          	add	a,#191
 844  01a1 6b02          	ld	(OFST+0,sp),a
 845                     ; 128         z = temp>>4; //Lower 8-bits
 847  01a3 7b02          	ld	a,(OFST+0,sp)
 848  01a5 4e            	swap	a
 849  01a6 a40f          	and	a,#15
 850  01a8 6b01          	ld	(OFST-1,sp),a
 851                     ; 129         y = temp & 0x0F; //Upper 8-bits
 853  01aa 7b02          	ld	a,(OFST+0,sp)
 854  01ac a40f          	and	a,#15
 855  01ae 6b02          	ld	(OFST+0,sp),a
 856                     ; 130         LCD_Cmd(z); //Set Row
 858  01b0 7b01          	ld	a,(OFST-1,sp)
 859  01b2 cd00db        	call	_LCD_Cmd
 861                     ; 131         LCD_Cmd(y); //Set Column
 863  01b5 7b02          	ld	a,(OFST+0,sp)
 864  01b7 cd00db        	call	_LCD_Cmd
 866  01ba               L772:
 867                     ; 133 }
 870  01ba 5b04          	addw	sp,#4
 871  01bc 81            	ret
 926                     ; 135 void LCD_Print_Char(char data)  //Send 8-bits through 4-bit mode
 926                     ; 136 {
 927                     	switch	.text
 928  01bd               _LCD_Print_Char:
 930  01bd 88            	push	a
 931  01be 89            	pushw	x
 932       00000002      OFST:	set	2
 935                     ; 138    Lower_Nibble = data&0x0F;
 937  01bf a40f          	and	a,#15
 938  01c1 6b01          	ld	(OFST-1,sp),a
 939                     ; 139    Upper_Nibble = data&0xF0;
 941  01c3 7b03          	ld	a,(OFST+1,sp)
 942  01c5 a4f0          	and	a,#240
 943  01c7 6b02          	ld	(OFST+0,sp),a
 944                     ; 140    PCF7584write(0,1);             // => RS = 1
 946  01c9 ae0001        	ldw	x,#1
 947  01cc cd0063        	call	_PCF7584write
 949                     ; 142    LCD_SetBit(Upper_Nibble>>4);  //Send upper half by shifting by 4
 951  01cf 7b02          	ld	a,(OFST+0,sp)
 952  01d1 4e            	swap	a
 953  01d2 a40f          	and	a,#15
 954  01d4 cd0092        	call	_LCD_SetBit
 956                     ; 143    PCF7584write(2,1); //EN = 1
 958  01d7 ae0201        	ldw	x,#513
 959  01da cd0063        	call	_PCF7584write
 961                     ; 144    delay_ms(5); 
 963  01dd ae0005        	ldw	x,#5
 964  01e0 cd0000        	call	_delay_ms
 966                     ; 145    PCF7584write(2,0); //EN = 0
 968  01e3 ae0200        	ldw	x,#512
 969  01e6 cd0063        	call	_PCF7584write
 971                     ; 147    LCD_SetBit(Lower_Nibble); //Send Lower half
 973  01e9 7b01          	ld	a,(OFST-1,sp)
 974  01eb cd0092        	call	_LCD_SetBit
 976                     ; 148    PCF7584write(2,1); //EN = 1
 978  01ee ae0201        	ldw	x,#513
 979  01f1 cd0063        	call	_PCF7584write
 981                     ; 149    delay_ms(5); 
 983  01f4 ae0005        	ldw	x,#5
 984  01f7 cd0000        	call	_delay_ms
 986                     ; 150    PCF7584write(2,0); //EN = 0
 988  01fa ae0200        	ldw	x,#512
 989  01fd cd0063        	call	_PCF7584write
 991                     ; 151 }
 994  0200 5b03          	addw	sp,#3
 995  0202 81            	ret
1040                     ; 153 void LCD_Print_String(char *a)
1040                     ; 154 {
1041                     	switch	.text
1042  0203               _LCD_Print_String:
1044  0203 89            	pushw	x
1045  0204 89            	pushw	x
1046       00000002      OFST:	set	2
1049                     ; 156     for(i=0;a[i]!='\0';i++)
1051  0205 5f            	clrw	x
1052  0206 1f01          	ldw	(OFST-1,sp),x
1054  0208 200f          	jra	L753
1055  020a               L353:
1056                     ; 157 		LCD_Print_Char(a[i]);  //Split the string using pointers and call the Char function 
1058  020a 1e01          	ldw	x,(OFST-1,sp)
1059  020c 72fb03        	addw	x,(OFST+1,sp)
1060  020f f6            	ld	a,(x)
1061  0210 adab          	call	_LCD_Print_Char
1063                     ; 156     for(i=0;a[i]!='\0';i++)
1065  0212 1e01          	ldw	x,(OFST-1,sp)
1066  0214 1c0001        	addw	x,#1
1067  0217 1f01          	ldw	(OFST-1,sp),x
1068  0219               L753:
1071  0219 1e01          	ldw	x,(OFST-1,sp)
1072  021b 72fb03        	addw	x,(OFST+1,sp)
1073  021e 7d            	tnz	(x)
1074  021f 26e9          	jrne	L353
1075                     ; 158 }
1078  0221 5b04          	addw	sp,#4
1079  0223 81            	ret
1133                     	switch	.const
1134  0004               L44:
1135  0004 0000000a      	dc.l	10
1136  0008               L64:
1137  0008 00000064      	dc.l	100
1138  000c               L05:
1139  000c 000003e8      	dc.l	1000
1140  0010               L25:
1141  0010 00002710      	dc.l	10000
1142  0014               L45:
1143  0014 000186a0      	dc.l	100000
1144  0018               L65:
1145  0018 00989680      	dc.l	10000000
1146  001c               L06:
1147  001c 05f5e100      	dc.l	100000000
1148  0020               L26:
1149  0020 3b9aca00      	dc.l	1000000000
1150                     ; 160 void LCD_Print_Integer(long a)
1150                     ; 161 {
1151                     	switch	.text
1152  0224               _LCD_Print_Integer:
1154  0224 88            	push	a
1155       00000001      OFST:	set	1
1158                     ; 162 	u8 check0 = 0; // to avoid printing 0 in the front
1160  0225 0f01          	clr	(OFST+0,sp)
1161                     ; 163 	d10 = a%10; // Last digit of the number
1163  0227 96            	ldw	x,sp
1164  0228 1c0004        	addw	x,#OFST+3
1165  022b cd0000        	call	c_ltor
1167  022e ae0004        	ldw	x,#L44
1168  0231 cd0000        	call	c_lmod
1170  0234 b603          	ld	a,c_lreg+3
1171  0236 b70b          	ld	_d10,a
1172                     ; 164   d9 = (a/10)%10; // Second last digit of the number
1174  0238 96            	ldw	x,sp
1175  0239 1c0004        	addw	x,#OFST+3
1176  023c cd0000        	call	c_ltor
1178  023f ae0004        	ldw	x,#L44
1179  0242 cd0000        	call	c_ldiv
1181  0245 ae0004        	ldw	x,#L44
1182  0248 cd0000        	call	c_lmod
1184  024b b603          	ld	a,c_lreg+3
1185  024d b70a          	ld	_d9,a
1186                     ; 165   d8 = (a/100)%10; // And so on..
1188  024f 96            	ldw	x,sp
1189  0250 1c0004        	addw	x,#OFST+3
1190  0253 cd0000        	call	c_ltor
1192  0256 ae0008        	ldw	x,#L64
1193  0259 cd0000        	call	c_ldiv
1195  025c ae0004        	ldw	x,#L44
1196  025f cd0000        	call	c_lmod
1198  0262 b603          	ld	a,c_lreg+3
1199  0264 b709          	ld	_d8,a
1200                     ; 166   d7 = (a/1000)%10;	
1202  0266 96            	ldw	x,sp
1203  0267 1c0004        	addw	x,#OFST+3
1204  026a cd0000        	call	c_ltor
1206  026d ae000c        	ldw	x,#L05
1207  0270 cd0000        	call	c_ldiv
1209  0273 ae0004        	ldw	x,#L44
1210  0276 cd0000        	call	c_lmod
1212  0279 b603          	ld	a,c_lreg+3
1213  027b b708          	ld	_d7,a
1214                     ; 167   d6 = (a/10000)%10;
1216  027d 96            	ldw	x,sp
1217  027e 1c0004        	addw	x,#OFST+3
1218  0281 cd0000        	call	c_ltor
1220  0284 ae0010        	ldw	x,#L25
1221  0287 cd0000        	call	c_ldiv
1223  028a ae0004        	ldw	x,#L44
1224  028d cd0000        	call	c_lmod
1226  0290 b603          	ld	a,c_lreg+3
1227  0292 b707          	ld	_d6,a
1228                     ; 168   d5 = (a/100000)%10;
1230  0294 96            	ldw	x,sp
1231  0295 1c0004        	addw	x,#OFST+3
1232  0298 cd0000        	call	c_ltor
1234  029b ae0014        	ldw	x,#L45
1235  029e cd0000        	call	c_ldiv
1237  02a1 ae0004        	ldw	x,#L44
1238  02a4 cd0000        	call	c_lmod
1240  02a7 b603          	ld	a,c_lreg+3
1241  02a9 b706          	ld	_d5,a
1242                     ; 169   d4 = (a/1000000)%10;
1244  02ab 96            	ldw	x,sp
1245  02ac 1c0004        	addw	x,#OFST+3
1246  02af cd0000        	call	c_ltor
1248  02b2 ae0000        	ldw	x,#L03
1249  02b5 cd0000        	call	c_ldiv
1251  02b8 ae0004        	ldw	x,#L44
1252  02bb cd0000        	call	c_lmod
1254  02be b603          	ld	a,c_lreg+3
1255  02c0 b705          	ld	_d4,a
1256                     ; 170   d3 = (a/10000000)%10;
1258  02c2 96            	ldw	x,sp
1259  02c3 1c0004        	addw	x,#OFST+3
1260  02c6 cd0000        	call	c_ltor
1262  02c9 ae0018        	ldw	x,#L65
1263  02cc cd0000        	call	c_ldiv
1265  02cf ae0004        	ldw	x,#L44
1266  02d2 cd0000        	call	c_lmod
1268  02d5 b603          	ld	a,c_lreg+3
1269  02d7 b704          	ld	_d3,a
1270                     ; 171 	d2 = (a/100000000)%10;
1272  02d9 96            	ldw	x,sp
1273  02da 1c0004        	addw	x,#OFST+3
1274  02dd cd0000        	call	c_ltor
1276  02e0 ae001c        	ldw	x,#L06
1277  02e3 cd0000        	call	c_ldiv
1279  02e6 ae0004        	ldw	x,#L44
1280  02e9 cd0000        	call	c_lmod
1282  02ec b603          	ld	a,c_lreg+3
1283  02ee b703          	ld	_d2,a
1284                     ; 172 	d1 = (a/1000000000); 
1286  02f0 96            	ldw	x,sp
1287  02f1 1c0004        	addw	x,#OFST+3
1288  02f4 cd0000        	call	c_ltor
1290  02f7 ae0020        	ldw	x,#L26
1291  02fa cd0000        	call	c_ldiv
1293  02fd b603          	ld	a,c_lreg+3
1294  02ff b702          	ld	_d1,a
1295                     ; 173 	if(d1!=0) 
1297  0301 3d02          	tnz	_d1
1298  0303 270b          	jreq	L504
1299                     ; 175 	  LCD_Print_Char(d1+48); // ascii value of zero is 48
1301  0305 b602          	ld	a,_d1
1302  0307 ab30          	add	a,#48
1303  0309 cd01bd        	call	_LCD_Print_Char
1305                     ; 176 		check0 = 1;
1307  030c a601          	ld	a,#1
1308  030e 6b01          	ld	(OFST+0,sp),a
1309  0310               L504:
1310                     ; 178   if(d2!=0 || check0) 
1312  0310 3d03          	tnz	_d2
1313  0312 2604          	jrne	L114
1315  0314 0d01          	tnz	(OFST+0,sp)
1316  0316 270b          	jreq	L704
1317  0318               L114:
1318                     ; 180 	  LCD_Print_Char(d2+48);
1320  0318 b603          	ld	a,_d2
1321  031a ab30          	add	a,#48
1322  031c cd01bd        	call	_LCD_Print_Char
1324                     ; 181 		check0 = 1;
1326  031f a601          	ld	a,#1
1327  0321 6b01          	ld	(OFST+0,sp),a
1328  0323               L704:
1329                     ; 183   if(d3!=0 || check0) 
1331  0323 3d04          	tnz	_d3
1332  0325 2604          	jrne	L514
1334  0327 0d01          	tnz	(OFST+0,sp)
1335  0329 270b          	jreq	L314
1336  032b               L514:
1337                     ; 185 	  LCD_Print_Char(d3+48);
1339  032b b604          	ld	a,_d3
1340  032d ab30          	add	a,#48
1341  032f cd01bd        	call	_LCD_Print_Char
1343                     ; 186 		check0 = 1;
1345  0332 a601          	ld	a,#1
1346  0334 6b01          	ld	(OFST+0,sp),a
1347  0336               L314:
1348                     ; 188   if(d4!=0 || check0) 
1350  0336 3d05          	tnz	_d4
1351  0338 2604          	jrne	L124
1353  033a 0d01          	tnz	(OFST+0,sp)
1354  033c 270b          	jreq	L714
1355  033e               L124:
1356                     ; 190 	  LCD_Print_Char(d4+48);
1358  033e b605          	ld	a,_d4
1359  0340 ab30          	add	a,#48
1360  0342 cd01bd        	call	_LCD_Print_Char
1362                     ; 191 		check0 = 1;
1364  0345 a601          	ld	a,#1
1365  0347 6b01          	ld	(OFST+0,sp),a
1366  0349               L714:
1367                     ; 193   if(d5!=0 || check0) 
1369  0349 3d06          	tnz	_d5
1370  034b 2604          	jrne	L524
1372  034d 0d01          	tnz	(OFST+0,sp)
1373  034f 270b          	jreq	L324
1374  0351               L524:
1375                     ; 195 	  LCD_Print_Char(d5+48);
1377  0351 b606          	ld	a,_d5
1378  0353 ab30          	add	a,#48
1379  0355 cd01bd        	call	_LCD_Print_Char
1381                     ; 196 		check0 = 1;
1383  0358 a601          	ld	a,#1
1384  035a 6b01          	ld	(OFST+0,sp),a
1385  035c               L324:
1386                     ; 198   if(d6!=0 || check0) 
1388  035c 3d07          	tnz	_d6
1389  035e 2604          	jrne	L134
1391  0360 0d01          	tnz	(OFST+0,sp)
1392  0362 270b          	jreq	L724
1393  0364               L134:
1394                     ; 200 	  LCD_Print_Char(d6+48);
1396  0364 b607          	ld	a,_d6
1397  0366 ab30          	add	a,#48
1398  0368 cd01bd        	call	_LCD_Print_Char
1400                     ; 201 		check0 = 1;
1402  036b a601          	ld	a,#1
1403  036d 6b01          	ld	(OFST+0,sp),a
1404  036f               L724:
1405                     ; 203   if(d7!=0 || check0) 
1407  036f 3d08          	tnz	_d7
1408  0371 2604          	jrne	L534
1410  0373 0d01          	tnz	(OFST+0,sp)
1411  0375 270b          	jreq	L334
1412  0377               L534:
1413                     ; 205 	  LCD_Print_Char(d7+48);
1415  0377 b608          	ld	a,_d7
1416  0379 ab30          	add	a,#48
1417  037b cd01bd        	call	_LCD_Print_Char
1419                     ; 206 		check0 = 1;
1421  037e a601          	ld	a,#1
1422  0380 6b01          	ld	(OFST+0,sp),a
1423  0382               L334:
1424                     ; 208 	if(d8!=0 || check0) 
1426  0382 3d09          	tnz	_d8
1427  0384 2604          	jrne	L144
1429  0386 0d01          	tnz	(OFST+0,sp)
1430  0388 270b          	jreq	L734
1431  038a               L144:
1432                     ; 210 	  LCD_Print_Char(d8+48);
1434  038a b609          	ld	a,_d8
1435  038c ab30          	add	a,#48
1436  038e cd01bd        	call	_LCD_Print_Char
1438                     ; 211 		check0 = 1;
1440  0391 a601          	ld	a,#1
1441  0393 6b01          	ld	(OFST+0,sp),a
1442  0395               L734:
1443                     ; 213 	if(d9!=0 || check0) 
1445  0395 3d0a          	tnz	_d9
1446  0397 2604          	jrne	L544
1448  0399 0d01          	tnz	(OFST+0,sp)
1449  039b 2707          	jreq	L344
1450  039d               L544:
1451                     ; 215 	  LCD_Print_Char(d9+48); // Second last digit 
1453  039d b60a          	ld	a,_d9
1454  039f ab30          	add	a,#48
1455  03a1 cd01bd        	call	_LCD_Print_Char
1457  03a4               L344:
1458                     ; 217   LCD_Print_Char(d10+48); // Print the last digit whether or not 0
1460  03a4 b60b          	ld	a,_d10
1461  03a6 ab30          	add	a,#48
1462  03a8 cd01bd        	call	_LCD_Print_Char
1464                     ; 218 }
1467  03ab 84            	pop	a
1468  03ac 81            	ret
1492                     ; 220 void LCD_BL_On(void) // Back light on
1492                     ; 221 {
1493                     	switch	.text
1494  03ad               _LCD_BL_On:
1498                     ; 222 	PCF7584write(3,1);
1500  03ad ae0301        	ldw	x,#769
1501  03b0 cd0063        	call	_PCF7584write
1503                     ; 223 }
1506  03b3 81            	ret
1530                     ; 225 void LCD_BL_Off(void) // Back light off
1530                     ; 226 {
1531                     	switch	.text
1532  03b4               _LCD_BL_Off:
1536                     ; 227 	PCF7584write(3,0);
1538  03b4 ae0300        	ldw	x,#768
1539  03b7 cd0063        	call	_PCF7584write
1541                     ; 228 }
1544  03ba 81            	ret
1667                     	xdef	_LCD_Cmd
1668                     	xdef	_LCD_SetBit
1669                     	xdef	_PCF7584write
1670                     	xdef	_PCF7584write8
1671                     	switch	.ubsct
1672  0000               _Input_Clock:
1673  0000 0000          	ds.b	2
1674                     	xdef	_Input_Clock
1675  0002               _d1:
1676  0002 00            	ds.b	1
1677                     	xdef	_d1
1678  0003               _d2:
1679  0003 00            	ds.b	1
1680                     	xdef	_d2
1681  0004               _d3:
1682  0004 00            	ds.b	1
1683                     	xdef	_d3
1684  0005               _d4:
1685  0005 00            	ds.b	1
1686                     	xdef	_d4
1687  0006               _d5:
1688  0006 00            	ds.b	1
1689                     	xdef	_d5
1690  0007               _d6:
1691  0007 00            	ds.b	1
1692                     	xdef	_d6
1693  0008               _d7:
1694  0008 00            	ds.b	1
1695                     	xdef	_d7
1696  0009               _d8:
1697  0009 00            	ds.b	1
1698                     	xdef	_d8
1699  000a               _d9:
1700  000a 00            	ds.b	1
1701                     	xdef	_d9
1702  000b               _d10:
1703  000b 00            	ds.b	1
1704                     	xdef	_d10
1705  000c               _currentValue:
1706  000c 00            	ds.b	1
1707                     	xdef	_currentValue
1708                     	xdef	_LCD_BL_Off
1709                     	xdef	_LCD_BL_On
1710                     	xdef	_LCD_Print_Integer
1711                     	xdef	_LCD_Print_String
1712                     	xdef	_LCD_Print_Char
1713                     	xdef	_LCD_Set_Cursor
1714                     	xdef	_LCD_Clear
1715                     	xdef	_LCD_Begin
1716                     	xdef	_delay_ms
1717                     	xref	_I2C_CheckEvent
1718                     	xref	_I2C_SendData
1719                     	xref	_I2C_Send7bitAddress
1720                     	xref	_I2C_GenerateSTOP
1721                     	xref	_I2C_GenerateSTART
1722                     	xref	_I2C_Init
1723                     	xref	_CLK_GetClockFreq
1724                     	xref.b	c_lreg
1725                     	xref.b	c_x
1745                     	xref	c_ldiv
1746                     	xref	c_lmod
1747                     	xref	c_ltor
1748                     	xref	c_ludv
1749                     	end
