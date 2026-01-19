   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  15                     	bsct
  16  0000               _current_millis:
  17  0000 00000000      	dc.l	0
  18  0004               _lastReadTime:
  19  0004 00000000      	dc.l	0
  20  0008               _lastBeatTime:
  21  0008 00000000      	dc.l	0
  22  000c               _ir_avg:
  23  000c 00000000      	dc.l	0
  24  0010               _ir_smooth:
  25  0010 00000000      	dc.l	0
  26  0014               _beatDetected:
  27  0014 00            	dc.b	0
  28  0015               _rateSpot:
  29  0015 00            	dc.b	0
  30  0016               _bpm_to_display:
  31  0016 0000          	dc.w	0
  32  0018               _last_valid_bpm:
  33  0018 0000          	dc.w	0
  34  001a               _fall_timer:
  35  001a 00000000      	dc.l	0
  36  001e               _alarm_state:
  37  001e 00            	dc.b	0
  38  001f               _accel_mag_sq:
  39  001f 00000000      	dc.l	0
  40  0023               _lastUartSendTime:
  41  0023 00000000      	dc.l	0
  99                     ; 39 void delay_ms(uint16_t ms) { uint16_t i, j; for (i = 0; i < ms; i++) for (j = 0; j < 1275; j++); }
 101                     	switch	.text
 102  0000               _delay_ms:
 104  0000 89            	pushw	x
 105  0001 5204          	subw	sp,#4
 106       00000004      OFST:	set	4
 111  0003 5f            	clrw	x
 112  0004 1f01          	ldw	(OFST-3,sp),x
 114  0006 2018          	jra	L34
 115  0008               L73:
 118  0008 5f            	clrw	x
 119  0009 1f03          	ldw	(OFST-1,sp),x
 120  000b               L74:
 124  000b 1e03          	ldw	x,(OFST-1,sp)
 125  000d 1c0001        	addw	x,#1
 126  0010 1f03          	ldw	(OFST-1,sp),x
 129  0012 1e03          	ldw	x,(OFST-1,sp)
 130  0014 a304fb        	cpw	x,#1275
 131  0017 25f2          	jrult	L74
 134  0019 1e01          	ldw	x,(OFST-3,sp)
 135  001b 1c0001        	addw	x,#1
 136  001e 1f01          	ldw	(OFST-3,sp),x
 137  0020               L34:
 140  0020 1e01          	ldw	x,(OFST-3,sp)
 141  0022 1305          	cpw	x,(OFST+1,sp)
 142  0024 25e2          	jrult	L73
 146  0026 5b06          	addw	sp,#6
 147  0028 81            	ret
 173                     ; 41 void CLK_Config(void) { 
 174                     	switch	.text
 175  0029               _CLK_Config:
 179                     ; 42     CLK_DeInit(); 
 181  0029 cd0000        	call	_CLK_DeInit
 183                     ; 43     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); 
 185  002c 4f            	clr	a
 186  002d cd0000        	call	_CLK_HSIPrescalerConfig
 188                     ; 44     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE); 
 190  0030 ae0401        	ldw	x,#1025
 191  0033 cd0000        	call	_CLK_PeripheralClockConfig
 193                     ; 45     CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE); 
 195  0036 ae0301        	ldw	x,#769
 196  0039 cd0000        	call	_CLK_PeripheralClockConfig
 198                     ; 46 }
 201  003c 81            	ret
 228                     ; 48 void TIM4_Config(void) { 
 229                     	switch	.text
 230  003d               _TIM4_Config:
 234                     ; 49     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125); 
 236  003d ae077d        	ldw	x,#1917
 237  0040 cd0000        	call	_TIM4_TimeBaseInit
 239                     ; 50     TIM4_ClearFlag(TIM4_FLAG_UPDATE); 
 241  0043 a601          	ld	a,#1
 242  0045 cd0000        	call	_TIM4_ClearFlag
 244                     ; 51     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE); 
 246  0048 ae0101        	ldw	x,#257
 247  004b cd0000        	call	_TIM4_ITConfig
 249                     ; 52     TIM4_Cmd(ENABLE); 
 251  004e a601          	ld	a,#1
 252  0050 cd0000        	call	_TIM4_Cmd
 254                     ; 53 }
 257  0053 81            	ret
 283                     ; 55 @far @interrupt void TIM4_UPD_OVF_IRQHandler(void) { 
 285                     	switch	.text
 286  0054               f_TIM4_UPD_OVF_IRQHandler:
 288  0054 8a            	push	cc
 289  0055 84            	pop	a
 290  0056 a4bf          	and	a,#191
 291  0058 88            	push	a
 292  0059 86            	pop	cc
 293  005a 3b0002        	push	c_x+2
 294  005d be00          	ldw	x,c_x
 295  005f 89            	pushw	x
 296  0060 3b0002        	push	c_y+2
 297  0063 be00          	ldw	x,c_y
 298  0065 89            	pushw	x
 301                     ; 56     current_millis++; 
 303  0066 ae0000        	ldw	x,#_current_millis
 304  0069 a601          	ld	a,#1
 305  006b cd0000        	call	c_lgadc
 307                     ; 57     TIM4_ClearITPendingBit(TIM4_IT_UPDATE); 
 309  006e a601          	ld	a,#1
 310  0070 cd0000        	call	_TIM4_ClearITPendingBit
 312                     ; 58 }
 315  0073 85            	popw	x
 316  0074 bf00          	ldw	c_y,x
 317  0076 320002        	pop	c_y+2
 318  0079 85            	popw	x
 319  007a bf00          	ldw	c_x,x
 320  007c 320002        	pop	c_x+2
 321  007f 80            	iret
 346                     ; 60 void UART1_Config(void) { 
 348                     	switch	.text
 349  0080               _UART1_Config:
 353                     ; 61     UART1_DeInit(); 
 355  0080 cd0000        	call	_UART1_DeInit
 357                     ; 62     UART1_Init((uint32_t)9600, UART1_WORDLENGTH_8D, UART1_STOPBITS_1, UART1_PARITY_NO, UART1_SYNCMODE_CLOCK_DISABLE, UART1_MODE_TX_ENABLE); 
 359  0083 4b04          	push	#4
 360  0085 4b80          	push	#128
 361  0087 4b00          	push	#0
 362  0089 4b00          	push	#0
 363  008b 4b00          	push	#0
 364  008d ae2580        	ldw	x,#9600
 365  0090 89            	pushw	x
 366  0091 ae0000        	ldw	x,#0
 367  0094 89            	pushw	x
 368  0095 cd0000        	call	_UART1_Init
 370  0098 5b09          	addw	sp,#9
 371                     ; 63     UART1_Cmd(ENABLE); 
 373  009a a601          	ld	a,#1
 374  009c cd0000        	call	_UART1_Cmd
 376                     ; 64 }
 379  009f 81            	ret
 415                     ; 66 void UART1_SendChar(uint8_t c) { UART1_SendData8(c); while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); }
 416                     	switch	.text
 417  00a0               _UART1_SendChar:
 423  00a0 cd0000        	call	_UART1_SendData8
 426  00a3               L531:
 429  00a3 ae0080        	ldw	x,#128
 430  00a6 cd0000        	call	_UART1_GetFlagStatus
 432  00a9 4d            	tnz	a
 433  00aa 27f7          	jreq	L531
 437  00ac 81            	ret
 483                     ; 67 void UART1_SendString(char* str) { char *c = str; while (*c) { UART1_SendChar(*c); c++; } }
 484                     	switch	.text
 485  00ad               _UART1_SendString:
 487  00ad 89            	pushw	x
 488       00000002      OFST:	set	2
 493  00ae 1f01          	ldw	(OFST-1,sp),x
 495  00b0 200c          	jra	L761
 496  00b2               L361:
 499  00b2 1e01          	ldw	x,(OFST-1,sp)
 500  00b4 f6            	ld	a,(x)
 501  00b5 ade9          	call	_UART1_SendChar
 505  00b7 1e01          	ldw	x,(OFST-1,sp)
 506  00b9 1c0001        	addw	x,#1
 507  00bc 1f01          	ldw	(OFST-1,sp),x
 508  00be               L761:
 511  00be 1e01          	ldw	x,(OFST-1,sp)
 512  00c0 7d            	tnz	(x)
 513  00c1 26ef          	jrne	L361
 517  00c3 85            	popw	x
 518  00c4 81            	ret
 572                     ; 69 void UART_SendBPM(uint8_t bpm) {
 573                     	switch	.text
 574  00c5               _UART_SendBPM:
 576  00c5 88            	push	a
 577  00c6 89            	pushw	x
 578       00000002      OFST:	set	2
 581                     ; 71     if (bpm > 200) return; 
 583  00c7 a1c9          	cp	a,#201
 584  00c9 243a          	jruge	L42
 587                     ; 72     tens = bpm / 10; units = bpm % 10;
 589  00cb 7b03          	ld	a,(OFST+1,sp)
 590  00cd 5f            	clrw	x
 591  00ce 97            	ld	xl,a
 592  00cf a60a          	ld	a,#10
 593  00d1 cd0000        	call	c_sdivx
 595  00d4 01            	rrwa	x,a
 596  00d5 6b01          	ld	(OFST-1,sp),a
 597  00d7 02            	rlwa	x,a
 600  00d8 7b03          	ld	a,(OFST+1,sp)
 601  00da 5f            	clrw	x
 602  00db 97            	ld	xl,a
 603  00dc a60a          	ld	a,#10
 604  00de cd0000        	call	c_smodx
 606  00e1 01            	rrwa	x,a
 607  00e2 6b02          	ld	(OFST+0,sp),a
 608  00e4 02            	rlwa	x,a
 609                     ; 74     UART1_SendString("NhipTim:"); 
 611  00e5 ae00b4        	ldw	x,#L322
 612  00e8 adc3          	call	_UART1_SendString
 614                     ; 75     if (bpm >= 100) UART1_SendChar('1');
 616  00ea 7b03          	ld	a,(OFST+1,sp)
 617  00ec a164          	cp	a,#100
 618  00ee 2504          	jrult	L522
 621  00f0 a631          	ld	a,#49
 622  00f2 adac          	call	_UART1_SendChar
 624  00f4               L522:
 625                     ; 76     UART1_SendChar(tens + '0'); UART1_SendChar(units + '0');
 627  00f4 7b01          	ld	a,(OFST-1,sp)
 628  00f6 ab30          	add	a,#48
 629  00f8 ada6          	call	_UART1_SendChar
 633  00fa 7b02          	ld	a,(OFST+0,sp)
 634  00fc ab30          	add	a,#48
 635  00fe ada0          	call	_UART1_SendChar
 637                     ; 77     UART1_SendString("\n");
 639  0100 ae00b2        	ldw	x,#L722
 640  0103 ada8          	call	_UART1_SendString
 642                     ; 78 }
 643  0105               L42:
 646  0105 5b03          	addw	sp,#3
 647  0107 81            	ret
 693                     ; 80 uint8_t MAX30102_Write(uint8_t reg, uint8_t data) { i2c_start(); i2c_write_byte(MAX30102_ADDR); i2c_write_byte(reg); i2c_write_byte(data); i2c_stop(); return 0; }
 694                     	switch	.text
 695  0108               _MAX30102_Write:
 697  0108 89            	pushw	x
 698       00000000      OFST:	set	0
 703  0109 cd0000        	call	_i2c_start
 707  010c a6ae          	ld	a,#174
 708  010e cd0000        	call	_i2c_write_byte
 712  0111 7b01          	ld	a,(OFST+1,sp)
 713  0113 cd0000        	call	_i2c_write_byte
 717  0116 7b02          	ld	a,(OFST+2,sp)
 718  0118 cd0000        	call	_i2c_write_byte
 722  011b cd0000        	call	_i2c_stop
 726  011e 4f            	clr	a
 729  011f 85            	popw	x
 730  0120 81            	ret
 769                     ; 81 uint32_t MAX30102_Read_IR(void) {
 770                     	switch	.text
 771  0121               _MAX30102_Read_IR:
 773  0121 520b          	subw	sp,#11
 774       0000000b      OFST:	set	11
 777                     ; 82     uint8_t b[3]; i2c_start(); i2c_write_byte(MAX30102_ADDR); i2c_write_byte(0x07); i2c_stop();
 779  0123 cd0000        	call	_i2c_start
 783  0126 a6ae          	ld	a,#174
 784  0128 cd0000        	call	_i2c_write_byte
 788  012b a607          	ld	a,#7
 789  012d cd0000        	call	_i2c_write_byte
 793  0130 cd0000        	call	_i2c_stop
 795                     ; 83     i2c_start(); i2c_write_byte(MAX30102_ADDR|1); i2c_read_byte(1); i2c_read_byte(1); i2c_read_byte(1); 
 797  0133 cd0000        	call	_i2c_start
 801  0136 a6af          	ld	a,#175
 802  0138 cd0000        	call	_i2c_write_byte
 806  013b a601          	ld	a,#1
 807  013d cd0000        	call	_i2c_read_byte
 811  0140 a601          	ld	a,#1
 812  0142 cd0000        	call	_i2c_read_byte
 816  0145 a601          	ld	a,#1
 817  0147 cd0000        	call	_i2c_read_byte
 819                     ; 84     b[0]=i2c_read_byte(1); b[1]=i2c_read_byte(1); b[2]=i2c_read_byte(0); i2c_stop();
 821  014a a601          	ld	a,#1
 822  014c cd0000        	call	_i2c_read_byte
 824  014f 6b09          	ld	(OFST-2,sp),a
 827  0151 a601          	ld	a,#1
 828  0153 cd0000        	call	_i2c_read_byte
 830  0156 6b0a          	ld	(OFST-1,sp),a
 833  0158 4f            	clr	a
 834  0159 cd0000        	call	_i2c_read_byte
 836  015c 6b0b          	ld	(OFST+0,sp),a
 839  015e cd0000        	call	_i2c_stop
 841                     ; 85     return (((uint32_t)b[0]&0x03)<<16)|((uint32_t)b[1]<<8)|b[2];
 843  0161 7b0b          	ld	a,(OFST+0,sp)
 844  0163 b703          	ld	c_lreg+3,a
 845  0165 3f02          	clr	c_lreg+2
 846  0167 3f01          	clr	c_lreg+1
 847  0169 3f00          	clr	c_lreg
 848  016b 96            	ldw	x,sp
 849  016c 1c0005        	addw	x,#OFST-6
 850  016f cd0000        	call	c_rtol
 852  0172 7b0a          	ld	a,(OFST-1,sp)
 853  0174 5f            	clrw	x
 854  0175 97            	ld	xl,a
 855  0176 90ae0100      	ldw	y,#256
 856  017a cd0000        	call	c_umul
 858  017d 96            	ldw	x,sp
 859  017e 1c0001        	addw	x,#OFST-10
 860  0181 cd0000        	call	c_rtol
 862  0184 7b09          	ld	a,(OFST-2,sp)
 863  0186 a403          	and	a,#3
 864  0188 b703          	ld	c_lreg+3,a
 865  018a 3f02          	clr	c_lreg+2
 866  018c 3f01          	clr	c_lreg+1
 867  018e 3f00          	clr	c_lreg
 868  0190 a610          	ld	a,#16
 869  0192 cd0000        	call	c_llsh
 871  0195 96            	ldw	x,sp
 872  0196 1c0001        	addw	x,#OFST-10
 873  0199 cd0000        	call	c_lor
 875  019c 96            	ldw	x,sp
 876  019d 1c0005        	addw	x,#OFST-6
 877  01a0 cd0000        	call	c_lor
 881  01a3 5b0b          	addw	sp,#11
 882  01a5 81            	ret
 907                     ; 87 uint8_t MAX30102_Init(void) {
 908                     	switch	.text
 909  01a6               _MAX30102_Init:
 913                     ; 88     MAX30102_Write(0x09, 0x40); delay_ms(100);
 915  01a6 ae0940        	ldw	x,#2368
 916  01a9 cd0108        	call	_MAX30102_Write
 920  01ac ae0064        	ldw	x,#100
 921  01af cd0000        	call	_delay_ms
 923                     ; 89     MAX30102_Write(0x08, 0x4F); MAX30102_Write(0x0A, 0x27); 
 925  01b2 ae084f        	ldw	x,#2127
 926  01b5 cd0108        	call	_MAX30102_Write
 930  01b8 ae0a27        	ldw	x,#2599
 931  01bb cd0108        	call	_MAX30102_Write
 933                     ; 90     MAX30102_Write(0x0C, 0x1F); MAX30102_Write(0x0D, 0x1F); MAX30102_Write(0x09, 0x03);
 935  01be ae0c1f        	ldw	x,#3103
 936  01c1 cd0108        	call	_MAX30102_Write
 940  01c4 ae0d1f        	ldw	x,#3359
 941  01c7 cd0108        	call	_MAX30102_Write
 945  01ca ae0903        	ldw	x,#2307
 946  01cd cd0108        	call	_MAX30102_Write
 948                     ; 91     return 1;
 950  01d0 a601          	ld	a,#1
 953  01d2 81            	ret
 979                     ; 94 uint8_t MPU6050_Init(void) { i2c_start(); i2c_write_byte(MPU6050_ADDR); i2c_write_byte(0x6B); i2c_write_byte(0x00); i2c_stop(); return 0; }
 980                     	switch	.text
 981  01d3               _MPU6050_Init:
 987  01d3 cd0000        	call	_i2c_start
 991  01d6 a6d0          	ld	a,#208
 992  01d8 cd0000        	call	_i2c_write_byte
 996  01db a66b          	ld	a,#107
 997  01dd cd0000        	call	_i2c_write_byte
1001  01e0 4f            	clr	a
1002  01e1 cd0000        	call	_i2c_write_byte
1006  01e4 cd0000        	call	_i2c_stop
1010  01e7 4f            	clr	a
1013  01e8 81            	ret
1092                     ; 95 void MPU6050_Read(MPUData* d) {
1093                     	switch	.text
1094  01e9               _MPU6050_Read:
1096  01e9 89            	pushw	x
1097  01ea 5206          	subw	sp,#6
1098       00000006      OFST:	set	6
1101                     ; 96     uint8_t b[6]; i2c_start(); i2c_write_byte(MPU6050_ADDR); i2c_write_byte(0x3B); i2c_stop();
1103  01ec cd0000        	call	_i2c_start
1107  01ef a6d0          	ld	a,#208
1108  01f1 cd0000        	call	_i2c_write_byte
1112  01f4 a63b          	ld	a,#59
1113  01f6 cd0000        	call	_i2c_write_byte
1117  01f9 cd0000        	call	_i2c_stop
1119                     ; 97     i2c_start(); i2c_write_byte(MPU6050_ADDR|1);
1121  01fc cd0000        	call	_i2c_start
1125  01ff a6d1          	ld	a,#209
1126  0201 cd0000        	call	_i2c_write_byte
1128                     ; 98     b[0]=i2c_read_byte(1); b[1]=i2c_read_byte(1); b[2]=i2c_read_byte(1); b[3]=i2c_read_byte(1); b[4]=i2c_read_byte(1); b[5]=i2c_read_byte(0); i2c_stop();
1130  0204 a601          	ld	a,#1
1131  0206 cd0000        	call	_i2c_read_byte
1133  0209 6b01          	ld	(OFST-5,sp),a
1136  020b a601          	ld	a,#1
1137  020d cd0000        	call	_i2c_read_byte
1139  0210 6b02          	ld	(OFST-4,sp),a
1142  0212 a601          	ld	a,#1
1143  0214 cd0000        	call	_i2c_read_byte
1145  0217 6b03          	ld	(OFST-3,sp),a
1148  0219 a601          	ld	a,#1
1149  021b cd0000        	call	_i2c_read_byte
1151  021e 6b04          	ld	(OFST-2,sp),a
1154  0220 a601          	ld	a,#1
1155  0222 cd0000        	call	_i2c_read_byte
1157  0225 6b05          	ld	(OFST-1,sp),a
1160  0227 4f            	clr	a
1161  0228 cd0000        	call	_i2c_read_byte
1163  022b 6b06          	ld	(OFST+0,sp),a
1166  022d cd0000        	call	_i2c_stop
1168                     ; 99     d->Ax=(int16_t)((b[0]<<8)|b[1]); d->Ay=(int16_t)((b[2]<<8)|b[3]); d->Az=(int16_t)((b[4]<<8)|b[5]);
1170  0230 7b01          	ld	a,(OFST-5,sp)
1171  0232 5f            	clrw	x
1172  0233 97            	ld	xl,a
1173  0234 7b02          	ld	a,(OFST-4,sp)
1174  0236 02            	rlwa	x,a
1175  0237 1607          	ldw	y,(OFST+1,sp)
1176  0239 90ff          	ldw	(y),x
1179  023b 7b03          	ld	a,(OFST-3,sp)
1180  023d 5f            	clrw	x
1181  023e 97            	ld	xl,a
1182  023f 7b04          	ld	a,(OFST-2,sp)
1183  0241 02            	rlwa	x,a
1184  0242 1607          	ldw	y,(OFST+1,sp)
1185  0244 90ef02        	ldw	(2,y),x
1188  0247 7b05          	ld	a,(OFST-1,sp)
1189  0249 5f            	clrw	x
1190  024a 97            	ld	xl,a
1191  024b 7b06          	ld	a,(OFST+0,sp)
1192  024d 02            	rlwa	x,a
1193  024e 1607          	ldw	y,(OFST+1,sp)
1194  0250 90ef04        	ldw	(4,y),x
1195                     ; 100 }
1198  0253 5b08          	addw	sp,#8
1199  0255 81            	ret
1323                     .const:	section	.text
1324  0000               L24:
1325  0000 0000000a      	dc.l	10
1326  0004               L44:
1327  0004 00007530      	dc.l	30000
1328  0008               L64:
1329  0008 00000060      	dc.l	96
1330  000c               L05:
1331  000c 00000178      	dc.l	376
1332  0010               L25:
1333  0010 00000546      	dc.l	1350
1334  0014               L65:
1335  0014 1dcd6501      	dc.l	500000001
1336  0018               L06:
1337  0018 000003e9      	dc.l	1001
1338  001c               L26:
1339  001c 00002711      	dc.l	10001
1340                     ; 102 main() {
1341                     	switch	.text
1342  0256               _main:
1344  0256 5216          	subw	sp,#22
1345       00000016      OFST:	set	22
1348                     ; 110     CLK_Config(); i2c_init(); TIM4_Config(); UART1_Config(); 
1350  0258 cd0029        	call	_CLK_Config
1354  025b cd0000        	call	_i2c_init
1358  025e cd003d        	call	_TIM4_Config
1362  0261 cd0080        	call	_UART1_Config
1364                     ; 111     init_ok = MAX30102_Init(); MPU6050_Init();
1366  0264 cd01a6        	call	_MAX30102_Init
1368  0267 6b13          	ld	(OFST-3,sp),a
1371  0269 cd01d3        	call	_MPU6050_Init
1373                     ; 112     enableInterrupts();
1376  026c 9a            rim
1378                     ; 114     if(!init_ok) { while(1) { UART1_SendString("LOI_CAM_BIEN\n"); delay_ms(1000); } }
1381  026d 0d13          	tnz	(OFST-3,sp)
1382  026f 260e          	jrne	L724
1383  0271               L134:
1386  0271 ae00a4        	ldw	x,#L534
1387  0274 cd00ad        	call	_UART1_SendString
1391  0277 ae03e8        	ldw	x,#1000
1392  027a cd0000        	call	_delay_ms
1395  027d 20f2          	jra	L134
1396  027f               L724:
1397                     ; 116     UART1_SendString("KHOI_DONG: CHE_DO_ON_DINH\n"); 
1399  027f ae0089        	ldw	x,#L734
1400  0282 cd00ad        	call	_UART1_SendString
1402  0285               L144:
1403                     ; 119         if (current_millis - lastReadTime >= SAMPLE_PERIOD) {
1405  0285 ae0000        	ldw	x,#_current_millis
1406  0288 cd0000        	call	c_ltor
1408  028b ae0004        	ldw	x,#_lastReadTime
1409  028e cd0000        	call	c_lsub
1411  0291 ae0000        	ldw	x,#L24
1412  0294 cd0000        	call	c_lcmp
1414  0297 25ec          	jrult	L144
1415                     ; 120             lastReadTime = current_millis;
1417  0299 be02          	ldw	x,_current_millis+2
1418  029b bf06          	ldw	_lastReadTime+2,x
1419  029d be00          	ldw	x,_current_millis
1420  029f bf04          	ldw	_lastReadTime,x
1421                     ; 122             ir_value = MAX30102_Read_IR();
1423  02a1 cd0121        	call	_MAX30102_Read_IR
1425  02a4 96            	ldw	x,sp
1426  02a5 1c000f        	addw	x,#OFST-7
1427  02a8 cd0000        	call	c_rtol
1429                     ; 124             if (ir_value < FINGER_DETECT_THRESHOLD) {
1431  02ab 96            	ldw	x,sp
1432  02ac 1c000f        	addw	x,#OFST-7
1433  02af cd0000        	call	c_ltor
1435  02b2 ae0004        	ldw	x,#L44
1436  02b5 cd0000        	call	c_lcmp
1438  02b8 243a          	jruge	L744
1439                     ; 126                 bpm_to_display = 0;
1441  02ba 5f            	clrw	x
1442  02bb bf16          	ldw	_bpm_to_display,x
1443                     ; 127                 last_valid_bpm = 0; 
1445  02bd 5f            	clrw	x
1446  02be bf18          	ldw	_last_valid_bpm,x
1447                     ; 128                 beatDetected = 0;
1449  02c0 3f14          	clr	_beatDetected
1450                     ; 129                 ir_avg = 0; ir_smooth = 0;
1452  02c2 ae0000        	ldw	x,#0
1453  02c5 bf0e          	ldw	_ir_avg+2,x
1454  02c7 ae0000        	ldw	x,#0
1455  02ca bf0c          	ldw	_ir_avg,x
1458  02cc ae0000        	ldw	x,#0
1459  02cf bf12          	ldw	_ir_smooth+2,x
1460  02d1 ae0000        	ldw	x,#0
1461  02d4 bf10          	ldw	_ir_smooth,x
1462                     ; 130                 lastBeatTime = 0;
1464  02d6 ae0000        	ldw	x,#0
1465  02d9 bf0a          	ldw	_lastBeatTime+2,x
1466  02db ae0000        	ldw	x,#0
1467  02de bf08          	ldw	_lastBeatTime,x
1468                     ; 131                 for(x=0; x<RATE_SIZE; x++) rates[x] = 0; 
1470  02e0 0f16          	clr	(OFST+0,sp)
1471  02e2               L154:
1474  02e2 7b16          	ld	a,(OFST+0,sp)
1475  02e4 5f            	clrw	x
1476  02e5 97            	ld	xl,a
1477  02e6 6f06          	clr	(_rates,x)
1480  02e8 0c16          	inc	(OFST+0,sp)
1483  02ea 7b16          	ld	a,(OFST+0,sp)
1484  02ec a104          	cp	a,#4
1485  02ee 25f2          	jrult	L154
1487  02f0 ac640464      	jpf	L754
1488  02f4               L744:
1489                     ; 134                 if (ir_smooth == 0) ir_smooth = ir_value;
1491  02f4 ae0010        	ldw	x,#_ir_smooth
1492  02f7 cd0000        	call	c_lzmp
1494  02fa 2608          	jrne	L164
1497  02fc 1e11          	ldw	x,(OFST-5,sp)
1498  02fe bf12          	ldw	_ir_smooth+2,x
1499  0300 1e0f          	ldw	x,(OFST-7,sp)
1500  0302 bf10          	ldw	_ir_smooth,x
1501  0304               L164:
1502                     ; 135                 ir_smooth = (ir_smooth * 7 + ir_value) / 8;
1504  0304 ae0010        	ldw	x,#_ir_smooth
1505  0307 cd0000        	call	c_ltor
1507  030a a607          	ld	a,#7
1508  030c cd0000        	call	c_smul
1510  030f 96            	ldw	x,sp
1511  0310 1c000f        	addw	x,#OFST-7
1512  0313 cd0000        	call	c_ladd
1514  0316 a603          	ld	a,#3
1515  0318 cd0000        	call	c_lursh
1517  031b ae0010        	ldw	x,#_ir_smooth
1518  031e cd0000        	call	c_rtol
1520                     ; 137                 if (ir_avg == 0) ir_avg = ir_smooth;
1522  0321 ae000c        	ldw	x,#_ir_avg
1523  0324 cd0000        	call	c_lzmp
1525  0327 2608          	jrne	L364
1528  0329 be12          	ldw	x,_ir_smooth+2
1529  032b bf0e          	ldw	_ir_avg+2,x
1530  032d be10          	ldw	x,_ir_smooth
1531  032f bf0c          	ldw	_ir_avg,x
1532  0331               L364:
1533                     ; 138                 ir_avg = (ir_avg * 95 + ir_smooth) / 96; 
1535  0331 ae000c        	ldw	x,#_ir_avg
1536  0334 cd0000        	call	c_ltor
1538  0337 a65f          	ld	a,#95
1539  0339 cd0000        	call	c_smul
1541  033c ae0010        	ldw	x,#_ir_smooth
1542  033f cd0000        	call	c_ladd
1544  0342 ae0008        	ldw	x,#L64
1545  0345 cd0000        	call	c_ludv
1547  0348 ae000c        	ldw	x,#_ir_avg
1548  034b cd0000        	call	c_rtol
1550                     ; 140                 if (ir_smooth > ir_avg + BEAT_DETECT_HYSTERESIS && beatDetected == 0) {
1552  034e ae000c        	ldw	x,#_ir_avg
1553  0351 cd0000        	call	c_ltor
1555  0354 a678          	ld	a,#120
1556  0356 cd0000        	call	c_ladc
1558  0359 ae0010        	ldw	x,#_ir_smooth
1559  035c cd0000        	call	c_lcmp
1561  035f 2503          	jrult	L46
1562  0361 cc0454        	jp	L564
1563  0364               L46:
1565  0364 3d14          	tnz	_beatDetected
1566  0366 2703          	jreq	L66
1567  0368 cc0454        	jp	L564
1568  036b               L66:
1569                     ; 141                     beatDetected = 1;
1571  036b 35010014      	mov	_beatDetected,#1
1572                     ; 143                     if (lastBeatTime != 0) {
1574  036f ae0008        	ldw	x,#_lastBeatTime
1575  0372 cd0000        	call	c_lzmp
1577  0375 2603          	jrne	L07
1578  0377 cc044a        	jp	L764
1579  037a               L07:
1580                     ; 144                         IBI = current_millis - lastBeatTime;
1582  037a ae0000        	ldw	x,#_current_millis
1583  037d cd0000        	call	c_ltor
1585  0380 ae0008        	ldw	x,#_lastBeatTime
1586  0383 cd0000        	call	c_lsub
1588  0386 96            	ldw	x,sp
1589  0387 1c000b        	addw	x,#OFST-11
1590  038a cd0000        	call	c_rtol
1592                     ; 146                         if (IBI > 375 && IBI < 1350) {
1594  038d 96            	ldw	x,sp
1595  038e 1c000b        	addw	x,#OFST-11
1596  0391 cd0000        	call	c_ltor
1598  0394 ae000c        	ldw	x,#L05
1599  0397 cd0000        	call	c_lcmp
1601  039a 2403          	jruge	L27
1602  039c cc044a        	jp	L764
1603  039f               L27:
1605  039f 96            	ldw	x,sp
1606  03a0 1c000b        	addw	x,#OFST-11
1607  03a3 cd0000        	call	c_ltor
1609  03a6 ae0010        	ldw	x,#L25
1610  03a9 cd0000        	call	c_lcmp
1612  03ac 2503          	jrult	L47
1613  03ae cc044a        	jp	L764
1614  03b1               L47:
1615                     ; 147                             new_bpm = 60000 / IBI;
1617  03b1 aeea60        	ldw	x,#60000
1618  03b4 bf02          	ldw	c_lreg+2,x
1619  03b6 ae0000        	ldw	x,#0
1620  03b9 bf00          	ldw	c_lreg,x
1621  03bb 96            	ldw	x,sp
1622  03bc 1c000b        	addw	x,#OFST-11
1623  03bf cd0000        	call	c_ludv
1625  03c2 be02          	ldw	x,c_lreg+2
1626  03c4 1f14          	ldw	(OFST-2,sp),x
1627                     ; 149                             if (last_valid_bpm == 0) {
1629  03c6 be18          	ldw	x,_last_valid_bpm
1630  03c8 2618          	jrne	L374
1631                     ; 150                                 last_valid_bpm = new_bpm;
1633  03ca 1e14          	ldw	x,(OFST-2,sp)
1634  03cc bf18          	ldw	_last_valid_bpm,x
1635                     ; 151                                 rates[rateSpot++] = (uint8_t)new_bpm;
1637  03ce b615          	ld	a,_rateSpot
1638  03d0 97            	ld	xl,a
1639  03d1 3c15          	inc	_rateSpot
1640  03d3 9f            	ld	a,xl
1641  03d4 5f            	clrw	x
1642  03d5 97            	ld	xl,a
1643  03d6 7b15          	ld	a,(OFST-1,sp)
1644  03d8 e706          	ld	(_rates,x),a
1645                     ; 152                                 rateSpot %= RATE_SIZE;
1647  03da b615          	ld	a,_rateSpot
1648  03dc a403          	and	a,#3
1649  03de b715          	ld	_rateSpot,a
1651  03e0 202e          	jra	L574
1652  03e2               L374:
1653                     ; 155                                 diff = (int)new_bpm - (int)last_valid_bpm;
1655  03e2 1e14          	ldw	x,(OFST-2,sp)
1656  03e4 72b00018      	subw	x,_last_valid_bpm
1657  03e8 1f09          	ldw	(OFST-13,sp),x
1658                     ; 156                                 if (diff > 15 || diff < -15) { } 
1660  03ea 9c            	rvf
1661  03eb 1e09          	ldw	x,(OFST-13,sp)
1662  03ed a30010        	cpw	x,#16
1663  03f0 2e1e          	jrsge	L574
1665  03f2 9c            	rvf
1666  03f3 1e09          	ldw	x,(OFST-13,sp)
1667  03f5 a3fff1        	cpw	x,#65521
1668  03f8 2f16          	jrslt	L574
1669                     ; 158                                     rates[rateSpot++] = (uint8_t)new_bpm;
1671  03fa b615          	ld	a,_rateSpot
1672  03fc 97            	ld	xl,a
1673  03fd 3c15          	inc	_rateSpot
1674  03ff 9f            	ld	a,xl
1675  0400 5f            	clrw	x
1676  0401 97            	ld	xl,a
1677  0402 7b15          	ld	a,(OFST-1,sp)
1678  0404 e706          	ld	(_rates,x),a
1679                     ; 159                                     rateSpot %= RATE_SIZE;
1681  0406 b615          	ld	a,_rateSpot
1682  0408 a403          	and	a,#3
1683  040a b715          	ld	_rateSpot,a
1684                     ; 160                                     last_valid_bpm = new_bpm; 
1686  040c 1e14          	ldw	x,(OFST-2,sp)
1687  040e bf18          	ldw	_last_valid_bpm,x
1688  0410               L574:
1689                     ; 164                             beatAvg = 0; count = 0;
1691  0410 5f            	clrw	x
1692  0411 1f14          	ldw	(OFST-2,sp),x
1695  0413 0f13          	clr	(OFST-3,sp)
1696                     ; 165                             for (x = 0 ; x < RATE_SIZE ; x++) {
1698  0415 0f16          	clr	(OFST+0,sp)
1699  0417               L505:
1700                     ; 166                                 if (rates[x] != 0) { beatAvg += rates[x]; count++; }
1702  0417 7b16          	ld	a,(OFST+0,sp)
1703  0419 5f            	clrw	x
1704  041a 97            	ld	xl,a
1705  041b 6d06          	tnz	(_rates,x)
1706  041d 2710          	jreq	L315
1709  041f 7b16          	ld	a,(OFST+0,sp)
1710  0421 5f            	clrw	x
1711  0422 97            	ld	xl,a
1712  0423 e606          	ld	a,(_rates,x)
1713  0425 1b15          	add	a,(OFST-1,sp)
1714  0427 6b15          	ld	(OFST-1,sp),a
1715  0429 2402          	jrnc	L45
1716  042b 0c14          	inc	(OFST-2,sp)
1717  042d               L45:
1720  042d 0c13          	inc	(OFST-3,sp)
1721  042f               L315:
1722                     ; 165                             for (x = 0 ; x < RATE_SIZE ; x++) {
1724  042f 0c16          	inc	(OFST+0,sp)
1727  0431 7b16          	ld	a,(OFST+0,sp)
1728  0433 a104          	cp	a,#4
1729  0435 25e0          	jrult	L505
1730                     ; 168                             if (count > 0) beatAvg /= count;
1732  0437 0d13          	tnz	(OFST-3,sp)
1733  0439 2707          	jreq	L515
1736  043b 1e14          	ldw	x,(OFST-2,sp)
1737  043d 7b13          	ld	a,(OFST-3,sp)
1738  043f 62            	div	x,a
1739  0440 1f14          	ldw	(OFST-2,sp),x
1740  0442               L515:
1741                     ; 169                             if (beatAvg > 0) bpm_to_display = beatAvg;
1743  0442 1e14          	ldw	x,(OFST-2,sp)
1744  0444 2704          	jreq	L764
1747  0446 1e14          	ldw	x,(OFST-2,sp)
1748  0448 bf16          	ldw	_bpm_to_display,x
1749  044a               L764:
1750                     ; 172                     lastBeatTime = current_millis;
1752  044a be02          	ldw	x,_current_millis+2
1753  044c bf0a          	ldw	_lastBeatTime+2,x
1754  044e be00          	ldw	x,_current_millis
1755  0450 bf08          	ldw	_lastBeatTime,x
1757  0452 2010          	jra	L754
1758  0454               L564:
1759                     ; 174                 else if (ir_smooth < ir_avg) {
1761  0454 ae0010        	ldw	x,#_ir_smooth
1762  0457 cd0000        	call	c_ltor
1764  045a ae000c        	ldw	x,#_ir_avg
1765  045d cd0000        	call	c_lcmp
1767  0460 2402          	jruge	L754
1768                     ; 175                     beatDetected = 0; 
1770  0462 3f14          	clr	_beatDetected
1771  0464               L754:
1772                     ; 179             switch (alarm_state) {
1774  0464 b61e          	ld	a,_alarm_state
1776                     ; 220                     break;
1777  0466 4d            	tnz	a
1778  0467 2710          	jreq	L743
1779  0469 4a            	dec	a
1780  046a 2603          	jrne	L67
1781  046c cc0528        	jp	L153
1782  046f               L67:
1783  046f 4a            	dec	a
1784  0470 2603          	jrne	L001
1785  0472 cc0560        	jp	L353
1786  0475               L001:
1787  0475 ac850285      	jpf	L144
1788  0479               L743:
1789                     ; 180                 case 0: // BINH THUONG
1789                     ; 181                     MPU6050_Read(&mpu_data);
1791  0479 ae0000        	ldw	x,#_mpu_data
1792  047c cd01e9        	call	_MPU6050_Read
1794                     ; 182                     accel_mag_sq = (uint32_t)mpu_data.Ax*mpu_data.Ax + (uint32_t)mpu_data.Ay*mpu_data.Ay + (uint32_t)mpu_data.Az*mpu_data.Az;
1796  047f be04          	ldw	x,_mpu_data+4
1797  0481 90be04        	ldw	y,_mpu_data+4
1798  0484 cd0000        	call	c_vmul
1800  0487 96            	ldw	x,sp
1801  0488 1c0005        	addw	x,#OFST-17
1802  048b cd0000        	call	c_rtol
1804  048e be02          	ldw	x,_mpu_data+2
1805  0490 90be02        	ldw	y,_mpu_data+2
1806  0493 cd0000        	call	c_vmul
1808  0496 96            	ldw	x,sp
1809  0497 1c0001        	addw	x,#OFST-21
1810  049a cd0000        	call	c_rtol
1812  049d be00          	ldw	x,_mpu_data
1813  049f 90be00        	ldw	y,_mpu_data
1814  04a2 cd0000        	call	c_vmul
1816  04a5 96            	ldw	x,sp
1817  04a6 1c0001        	addw	x,#OFST-21
1818  04a9 cd0000        	call	c_ladd
1820  04ac 96            	ldw	x,sp
1821  04ad 1c0005        	addw	x,#OFST-17
1822  04b0 cd0000        	call	c_ladd
1824  04b3 ae001f        	ldw	x,#_accel_mag_sq
1825  04b6 cd0000        	call	c_rtol
1827                     ; 184                     if (accel_mag_sq > ACCEL_IMPACT_THRESHOLD_SQ) {
1829  04b9 ae001f        	ldw	x,#_accel_mag_sq
1830  04bc cd0000        	call	c_ltor
1832  04bf ae0014        	ldw	x,#L65
1833  04c2 cd0000        	call	c_lcmp
1835  04c5 2512          	jrult	L135
1836                     ; 185                         alarm_state = 1; fall_timer = current_millis; 
1838  04c7 3501001e      	mov	_alarm_state,#1
1841  04cb be02          	ldw	x,_current_millis+2
1842  04cd bf1c          	ldw	_fall_timer+2,x
1843  04cf be00          	ldw	x,_current_millis
1844  04d1 bf1a          	ldw	_fall_timer,x
1845                     ; 186                         UART1_SendString("PHAT_HIEN_NGA\n"); 
1847  04d3 ae007a        	ldw	x,#L335
1848  04d6 cd00ad        	call	_UART1_SendString
1850  04d9               L135:
1851                     ; 189                     if (current_millis - lastUartSendTime > 1000) { 
1853  04d9 ae0000        	ldw	x,#_current_millis
1854  04dc cd0000        	call	c_ltor
1856  04df ae0023        	ldw	x,#_lastUartSendTime
1857  04e2 cd0000        	call	c_lsub
1859  04e5 ae0018        	ldw	x,#L06
1860  04e8 cd0000        	call	c_lcmp
1862  04eb 2403          	jruge	L201
1863  04ed cc0285        	jp	L144
1864  04f0               L201:
1865                     ; 190                         lastUartSendTime = current_millis;
1867  04f0 be02          	ldw	x,_current_millis+2
1868  04f2 bf25          	ldw	_lastUartSendTime+2,x
1869  04f4 be00          	ldw	x,_current_millis
1870  04f6 bf23          	ldw	_lastUartSendTime,x
1871                     ; 191                         if (bpm_to_display > 0) UART_SendBPM((uint8_t)bpm_to_display);
1873  04f8 be16          	ldw	x,_bpm_to_display
1874  04fa 2709          	jreq	L735
1877  04fc b617          	ld	a,_bpm_to_display+1
1878  04fe cd00c5        	call	_UART_SendBPM
1881  0501 ac850285      	jpf	L144
1882  0505               L735:
1883                     ; 192                         else if (ir_value < FINGER_DETECT_THRESHOLD) UART1_SendString("KHONG_CO_TAY\n");
1885  0505 96            	ldw	x,sp
1886  0506 1c000f        	addw	x,#OFST-7
1887  0509 cd0000        	call	c_ltor
1889  050c ae0004        	ldw	x,#L44
1890  050f cd0000        	call	c_lcmp
1892  0512 240a          	jruge	L345
1895  0514 ae006c        	ldw	x,#L545
1896  0517 cd00ad        	call	_UART1_SendString
1899  051a ac850285      	jpf	L144
1900  051e               L345:
1901                     ; 193                         else UART1_SendString("DANG_DO...\n");
1903  051e ae0060        	ldw	x,#L155
1904  0521 cd00ad        	call	_UART1_SendString
1906  0524 ac850285      	jpf	L144
1907  0528               L153:
1908                     ; 197                 case 1: //NGHI NGO
1908                     ; 198                     if (current_millis - fall_timer > 10000) { 
1910  0528 ae0000        	ldw	x,#_current_millis
1911  052b cd0000        	call	c_ltor
1913  052e ae001a        	ldw	x,#_fall_timer
1914  0531 cd0000        	call	c_lsub
1916  0534 ae001c        	ldw	x,#L26
1917  0537 cd0000        	call	c_lcmp
1919  053a 2403          	jruge	L401
1920  053c cc0285        	jp	L144
1921  053f               L401:
1922                     ; 199                         if (bpm_to_display >= 40) { 
1924  053f be16          	ldw	x,_bpm_to_display
1925  0541 a30028        	cpw	x,#40
1926  0544 250c          	jrult	L555
1927                     ; 200                             alarm_state = 0; 
1929  0546 3f1e          	clr	_alarm_state
1930                     ; 201                             UART1_SendString("HUY_CANH_BAO\n"); 
1932  0548 ae0052        	ldw	x,#L755
1933  054b cd00ad        	call	_UART1_SendString
1936  054e ac850285      	jpf	L144
1937  0552               L555:
1938                     ; 204                             alarm_state = 2; 
1940  0552 3502001e      	mov	_alarm_state,#2
1941                     ; 205                             UART1_SendString("CANH_BAO_KICH_HOAT\n"); 
1943  0556 ae003e        	ldw	x,#L365
1944  0559 cd00ad        	call	_UART1_SendString
1946  055c ac850285      	jpf	L144
1947  0560               L353:
1948                     ; 210                 case 2: //Canh bao
1948                     ; 211                     if (bpm_to_display >= 40) { 
1950  0560 be16          	ldw	x,_bpm_to_display
1951  0562 a30028        	cpw	x,#40
1952  0565 250c          	jrult	L565
1953                     ; 212                         alarm_state = 0; 
1955  0567 3f1e          	clr	_alarm_state
1956                     ; 213                         UART1_SendString("DUNG_CANH_BAO\n"); 
1958  0569 ae002f        	ldw	x,#L765
1959  056c cd00ad        	call	_UART1_SendString
1962  056f ac850285      	jpf	L144
1963  0573               L565:
1964                     ; 215                         if (current_millis - lastUartSendTime > 1000) {
1966  0573 ae0000        	ldw	x,#_current_millis
1967  0576 cd0000        	call	c_ltor
1969  0579 ae0023        	ldw	x,#_lastUartSendTime
1970  057c cd0000        	call	c_lsub
1972  057f ae0018        	ldw	x,#L06
1973  0582 cd0000        	call	c_lcmp
1975  0585 2403          	jruge	L601
1976  0587 cc0285        	jp	L144
1977  058a               L601:
1978                     ; 216                             lastUartSendTime = current_millis;
1980  058a be02          	ldw	x,_current_millis+2
1981  058c bf25          	ldw	_lastUartSendTime+2,x
1982  058e be00          	ldw	x,_current_millis
1983  0590 bf23          	ldw	_lastUartSendTime,x
1984                     ; 217                             UART1_SendString("DANG_BAO_DONG\n"); 
1986  0592 ae0020        	ldw	x,#L575
1987  0595 cd00ad        	call	_UART1_SendString
1989  0598 ac850285      	jpf	L144
1990  059c               L725:
1991  059c ac850285      	jpf	L144
2143                     	xdef	_main
2144                     	xdef	_MPU6050_Read
2145                     	xdef	_MPU6050_Init
2146                     	xdef	_MAX30102_Init
2147                     	xdef	_MAX30102_Read_IR
2148                     	xdef	_MAX30102_Write
2149                     	xdef	_UART_SendBPM
2150                     	xdef	_UART1_SendString
2151                     	xdef	_UART1_SendChar
2152                     	xdef	_UART1_Config
2153                     	xdef	f_TIM4_UPD_OVF_IRQHandler
2154                     	xdef	_TIM4_Config
2155                     	xdef	_CLK_Config
2156                     	xdef	_delay_ms
2157                     	xdef	_lastUartSendTime
2158                     	xdef	_accel_mag_sq
2159                     	xdef	_alarm_state
2160                     	xdef	_fall_timer
2161                     	switch	.ubsct
2162  0000               _mpu_data:
2163  0000 000000000000  	ds.b	6
2164                     	xdef	_mpu_data
2165                     	xdef	_last_valid_bpm
2166                     	xdef	_bpm_to_display
2167                     	xdef	_rateSpot
2168  0006               _rates:
2169  0006 00000000      	ds.b	4
2170                     	xdef	_rates
2171                     	xdef	_beatDetected
2172                     	xdef	_ir_smooth
2173                     	xdef	_ir_avg
2174                     	xdef	_lastBeatTime
2175                     	xdef	_lastReadTime
2176                     	xdef	_current_millis
2177                     	xref	_i2c_read_byte
2178                     	xref	_i2c_write_byte
2179                     	xref	_i2c_stop
2180                     	xref	_i2c_start
2181                     	xref	_i2c_init
2182                     	xref	_UART1_GetFlagStatus
2183                     	xref	_UART1_SendData8
2184                     	xref	_UART1_Cmd
2185                     	xref	_UART1_Init
2186                     	xref	_UART1_DeInit
2187                     	xref	_TIM4_ClearITPendingBit
2188                     	xref	_TIM4_ClearFlag
2189                     	xref	_TIM4_ITConfig
2190                     	xref	_TIM4_Cmd
2191                     	xref	_TIM4_TimeBaseInit
2192                     	xref	_CLK_HSIPrescalerConfig
2193                     	xref	_CLK_PeripheralClockConfig
2194                     	xref	_CLK_DeInit
2195                     	switch	.const
2196  0020               L575:
2197  0020 44414e475f42  	dc.b	"DANG_BAO_DONG",10,0
2198  002f               L765:
2199  002f 44554e475f43  	dc.b	"DUNG_CANH_BAO",10,0
2200  003e               L365:
2201  003e 43414e485f42  	dc.b	"CANH_BAO_KICH_HOAT"
2202  0050 0a00          	dc.b	10,0
2203  0052               L755:
2204  0052 4855595f4341  	dc.b	"HUY_CANH_BAO",10,0
2205  0060               L155:
2206  0060 44414e475f44  	dc.b	"DANG_DO...",10,0
2207  006c               L545:
2208  006c 4b484f4e475f  	dc.b	"KHONG_CO_TAY",10,0
2209  007a               L335:
2210  007a 504841545f48  	dc.b	"PHAT_HIEN_NGA",10,0
2211  0089               L734:
2212  0089 4b484f495f44  	dc.b	"KHOI_DONG: CHE_DO_"
2213  009b 4f4e5f44494e  	dc.b	"ON_DINH",10,0
2214  00a4               L534:
2215  00a4 4c4f495f4341  	dc.b	"LOI_CAM_BIEN",10,0
2216  00b2               L722:
2217  00b2 0a00          	dc.b	10,0
2218  00b4               L322:
2219  00b4 4e6869705469  	dc.b	"NhipTim:",0
2220                     	xref.b	c_lreg
2221                     	xref.b	c_x
2222                     	xref.b	c_y
2242                     	xref	c_vmul
2243                     	xref	c_ladc
2244                     	xref	c_ludv
2245                     	xref	c_lursh
2246                     	xref	c_ladd
2247                     	xref	c_smul
2248                     	xref	c_lzmp
2249                     	xref	c_lcmp
2250                     	xref	c_lsub
2251                     	xref	c_ltor
2252                     	xref	c_lor
2253                     	xref	c_rtol
2254                     	xref	c_umul
2255                     	xref	c_llsh
2256                     	xref	c_smodx
2257                     	xref	c_sdivx
2258                     	xref	c_lgadc
2259                     	end
