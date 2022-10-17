
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R4
	.DEF _status=R3
	.DEF _dem=R5
	.DEF _gapLevel=R7
	.DEF _speed=R9
	.DEF _speedTemp=R11
	.DEF _timerOverFlow=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  _pin_change_isr1
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0xA3:
	.DB  0x69,0x6E,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x53,0x50,0x44,0x3A,0x20,0x25,0x64,0x20
	.DB  0x6B,0x6D,0x2F,0x68,0x0,0x4D,0x4F,0x44
	.DB  0x45,0x3A,0x20,0x41,0x43,0x43,0x0,0x47
	.DB  0x41,0x50,0x3A,0x20,0x0,0x7C,0x7C,0x0
	.DB  0x7C,0x7C,0x7C,0x0,0x44,0x49,0x53,0x3A
	.DB  0x20,0x25,0x30,0x2E,0x32,0x66,0x20,0x6D
	.DB  0x0,0x4D,0x4F,0x44,0x45,0x3A,0x20,0x43
	.DB  0x43,0x0,0x53,0x45,0x54,0x20,0x54,0x4F
	.DB  0x20,0x41,0x43,0x54,0x49,0x56,0x45,0x0
	.DB  0x53,0x54,0x41,0x54,0x55,0x53,0x3A,0x20
	.DB  0x50,0x41,0x55,0x53,0x45,0x0,0x53,0x54
	.DB  0x41,0x54,0x55,0x53,0x3A,0x20,0x41,0x43
	.DB  0x54,0x49,0x56,0x45,0x0,0x4D,0x4F,0x44
	.DB  0x45,0x3A,0x20,0x4E,0x4F,0x52,0x4D,0x41
	.DB  0x4C,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _0x29
	.DW  _0x0*2+13

	.DW  0x06
	.DW  _0x29+10
	.DW  _0x0*2+23

	.DW  0x03
	.DW  _0x29+16
	.DW  _0x0*2+29

	.DW  0x04
	.DW  _0x29+19
	.DW  _0x0*2+32

	.DW  0x09
	.DW  _0x29+23
	.DW  _0x0*2+49

	.DW  0x0E
	.DW  _0x29+32
	.DW  _0x0*2+58

	.DW  0x0E
	.DW  _0x29+46
	.DW  _0x0*2+72

	.DW  0x0F
	.DW  _0x29+60
	.DW  _0x0*2+86

	.DW  0x0D
	.DW  _0x29+75
	.DW  _0x0*2+101

	.DW  0x0C
	.DW  0x03
	.DW  _0xA3*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*---------------------------------------Full stack develope this project: Nguyen Quoc Truong---------------------------------------*/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;
;#define CRUISE_BTN PIND.2
;#define ADAPTIVE_BTN PIND.2
;#define RES_BTN PINC.2
;#define CANCEL_BTN PINC.3
;#define SET_BTN PINC.4
;#define GAS_PEDAL PINC.0
;#define BRAKE_PEDAL PINC.1
;#define ECHO_PORT PORTB.0
;#define TRIGGER_PORT PORTB.1
;#define ON 0
;
;char mode = 'n'; // There are 3 modes: a <-> adaptive cruise control, c <-> cruise control, n <-> normal
;char status = 'i'; // Status of mode cruise control or adaptive cruise control, it can be i<->initial, w <-> waiting and s <-> set
;unsigned int dem = 0, gapLevel = 0;
;unsigned int speed, speedTemp;
;float distance;
;int timerOverFlow = 0;
;
;
;void wheelAndThrottleControl();
;void brakeLightControl();
;void showLCD(unsigned int);
;void activeRadar();
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0021 {

	.CSEG
_timer1_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0022     timerOverFlow++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 0023 }
	RJMP _0xA2
;
;interrupt [PC_INT1] void pin_change_isr1(void)
; 0000 0026 {
_pin_change_isr1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0027     if(SET_BTN == ON && status == 'i' && speed >= 45)
	LDI  R26,0
	SBIC 0x6,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x4
	LDI  R30,LOW(105)
	CP   R30,R3
	BRNE _0x4
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CP   R9,R30
	CPC  R10,R31
	BRSH _0x5
_0x4:
	RJMP _0x3
_0x5:
; 0000 0028     {
; 0000 0029         status = 's';
	LDI  R30,LOW(115)
	MOV  R3,R30
; 0000 002A         wheelAndThrottleControl();
	CALL SUBOPT_0x0
; 0000 002B         brakeLightControl();
; 0000 002C         showLCD(speed);
; 0000 002D         delay_ms(200);
	CALL SUBOPT_0x1
; 0000 002E     }
; 0000 002F     else if(RES_BTN == ON && status == 'w' && mode == 'c')
	RJMP _0x6
_0x3:
	LDI  R26,0
	SBIC 0x6,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x8
	LDI  R30,LOW(119)
	CP   R30,R3
	BRNE _0x8
	LDI  R30,LOW(99)
	CP   R30,R4
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 0030     {
; 0000 0031         status = 's';
	LDI  R30,LOW(115)
	MOV  R3,R30
; 0000 0032         while(speed != speedTemp)
_0xA:
	__CPWRR 11,12,9,10
	BREQ _0xC
; 0000 0033         {
; 0000 0034             if(speed > speedTemp)
	__CPWRR 11,12,9,10
	BRSH _0xD
; 0000 0035             {
; 0000 0036                 speed--;
	CALL SUBOPT_0x2
; 0000 0037                 delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0038                 wheelAndThrottleControl();
; 0000 0039                 brakeLightControl();
; 0000 003A                 showLCD(speed);
; 0000 003B                 if(CANCEL_BTN == ON || BRAKE_PEDAL == ON)
	CALL SUBOPT_0x4
	BREQ _0xF
	CALL SUBOPT_0x5
	BRNE _0xE
_0xF:
; 0000 003C                 {
; 0000 003D                     status = 'w';
	LDI  R30,LOW(119)
	MOV  R3,R30
; 0000 003E                     break;
	RJMP _0xC
; 0000 003F                 }
; 0000 0040             }
_0xE:
; 0000 0041             else
	RJMP _0x11
_0xD:
; 0000 0042             {
; 0000 0043                 speed++;
	CALL SUBOPT_0x6
; 0000 0044                 delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0045                 wheelAndThrottleControl();
; 0000 0046                 brakeLightControl();
; 0000 0047                 showLCD(speed);
; 0000 0048                 if(CANCEL_BTN == ON || BRAKE_PEDAL == ON)
	CALL SUBOPT_0x4
	BREQ _0x13
	CALL SUBOPT_0x5
	BRNE _0x12
_0x13:
; 0000 0049                 {
; 0000 004A                     status = 'w';
	LDI  R30,LOW(119)
	MOV  R3,R30
; 0000 004B                     break;
	RJMP _0xC
; 0000 004C                 }
; 0000 004D             }
_0x12:
_0x11:
; 0000 004E         }
	RJMP _0xA
_0xC:
; 0000 004F     }
; 0000 0050     else if(RES_BTN == ON && status == 'w' && mode == 'a')
	RJMP _0x15
_0x7:
	LDI  R26,0
	SBIC 0x6,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x17
	LDI  R30,LOW(119)
	CP   R30,R3
	BRNE _0x17
	LDI  R30,LOW(97)
	CP   R30,R4
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 0051     {
; 0000 0052         status = 's';
	LDI  R30,LOW(115)
	MOV  R3,R30
; 0000 0053     }
; 0000 0054 }
_0x16:
_0x15:
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Active cruise control mode
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0058 {
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0059      if(dem == 0)
	MOV  R0,R5
	OR   R0,R6
	BRNE _0x19
; 0000 005A      {
; 0000 005B           mode = 'c';
	LDI  R30,LOW(99)
	MOV  R4,R30
; 0000 005C      }
; 0000 005D      else
	RJMP _0x1A
_0x19:
; 0000 005E      {
; 0000 005F           mode = 'n';
	LDI  R30,LOW(110)
	MOV  R4,R30
; 0000 0060           status = 'i';
	LDI  R30,LOW(105)
	MOV  R3,R30
; 0000 0061      }
_0x1A:
; 0000 0062      dem++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 0063      if(dem == 2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0x1B
; 0000 0064      {
; 0000 0065           dem = 0;
	CLR  R5
	CLR  R6
; 0000 0066      }
; 0000 0067 }
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
;
;// Active adaptive cruise control mode
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 006B {
_ext_int1_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 006C     if(mode == 'c')
	LDI  R30,LOW(99)
	CP   R30,R4
	BRNE _0x1C
; 0000 006D     {
; 0000 006E         mode = 'a';
	LDI  R30,LOW(97)
	MOV  R4,R30
; 0000 006F     }
; 0000 0070     gapLevel++;
_0x1C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
; 0000 0071     if(gapLevel == 4)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x1D
; 0000 0072     {
; 0000 0073         gapLevel = 0;
	CLR  R7
	CLR  R8
; 0000 0074         mode = 'c';
	LDI  R30,LOW(99)
	MOV  R4,R30
; 0000 0075     }
; 0000 0076 }
_0x1D:
_0xA2:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;void activeRadar()
; 0000 0079 {
_activeRadar:
; 0000 007A     unsigned int duration;
; 0000 007B     // Trigger generate pulse
; 0000 007C     TRIGGER_PORT = 1;
	ST   -Y,R17
	ST   -Y,R16
;	duration -> R16,R17
	SBI  0x5,1
; 0000 007D     delay_us(10);
	__DELAY_USB 27
; 0000 007E     TRIGGER_PORT = 0;
	CBI  0x5,1
; 0000 007F     // Delete timer1
; 0000 0080     TCNT1H = 0;
	CALL SUBOPT_0x7
; 0000 0081     TCNT1L = 0;
; 0000 0082     TCCR1B=0b01000001; // Catch rising edge mode
	LDI  R30,LOW(65)
	STS  129,R30
; 0000 0083     TIFR1 = 0b00100001; // Delete input capture and overflow flag
	LDI  R30,LOW(33)
	OUT  0x16,R30
; 0000 0084 
; 0000 0085     // Compute pulse width
; 0000 0086     while(TIFR1 & (1 << ICF1) == 0); // Waiting rising edge
_0x22:
	IN   R30,0x16
	ANDI R30,LOW(0x0)
	BRNE _0x22
; 0000 0087     // Delete timer1
; 0000 0088     TCNT1H = 0;
	CALL SUBOPT_0x7
; 0000 0089     TCNT1L = 0;
; 0000 008A     TCCR1B=0b00000001; // Catch falling edge mode
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 008B     TIFR1 = 0b00100001; // Delete input capture and overflow flag
	LDI  R30,LOW(33)
	OUT  0x16,R30
; 0000 008C     timerOverFlow = 0; // Delete timer1 value
	CLR  R13
	CLR  R14
; 0000 008D 
; 0000 008E     while(TIFR1 & (1 << ICF1) == 0); // Waiting falling edge
_0x25:
	IN   R30,0x16
	ANDI R30,LOW(0x0)
	BRNE _0x25
; 0000 008F     duration = (ICR1L + ICR1H*256) + (65535 * timerOverFlow);
	LDS  R30,134
	LDI  R31,0
	MOVW R26,R30
	LDS  R30,135
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	__GETW1R 13,14
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	MOVW R16,R30
; 0000 0090     distance = 1.0f*duration/466.47;
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3F800000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43E93C29
	CALL __DIVF21
	STS  _distance,R30
	STS  _distance+1,R31
	STS  _distance+2,R22
	STS  _distance+3,R23
; 0000 0091 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void showLCD(unsigned int speed)
; 0000 0094 {
_showLCD:
; 0000 0095     char buffer[16], buffer1[16];
; 0000 0096     lcd_clear();
	SBIW R28,32
;	speed -> Y+32
;	buffer -> Y+16
;	buffer1 -> Y+0
	CALL _lcd_clear
; 0000 0097     sprintf(buffer, "SPD: %d km/h", speed);
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x8
; 0000 0098     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0099     lcd_puts(buffer);
	MOVW R30,R28
	ADIW R30,16
	CALL SUBOPT_0x9
; 0000 009A 
; 0000 009B     if(mode == 'a')
	LDI  R30,LOW(97)
	CP   R30,R4
	BREQ PC+3
	JMP _0x28
; 0000 009C     {
; 0000 009D         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 009E         lcd_puts("MODE: ACC");
	__POINTW1MN _0x29,0
	CALL SUBOPT_0x9
; 0000 009F         lcd_gotoxy(0,2);
	CALL SUBOPT_0xB
; 0000 00A0         lcd_puts("GAP: ");
	__POINTW1MN _0x29,10
	CALL SUBOPT_0x9
; 0000 00A1         if(gapLevel == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x2A
; 0000 00A2         {
; 0000 00A3             lcd_putchar('|');
	LDI  R30,LOW(124)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00A4         }
; 0000 00A5         else if(gapLevel == 2)
	RJMP _0x2B
_0x2A:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x2C
; 0000 00A6         {
; 0000 00A7             lcd_puts("||");
	__POINTW1MN _0x29,16
	RJMP _0x9D
; 0000 00A8         }
; 0000 00A9         else if(gapLevel == 3)
_0x2C:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x2E
; 0000 00AA         {
; 0000 00AB             lcd_puts("|||");
	__POINTW1MN _0x29,19
_0x9D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00AC         }
; 0000 00AD         lcd_gotoxy(0,3);
_0x2E:
_0x2B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00AE         sprintf(buffer1, "DIS: %0.2f m", distance);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,36
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_distance
	LDS  R31,_distance+1
	LDS  R22,_distance+2
	LDS  R23,_distance+3
	CALL SUBOPT_0x8
; 0000 00AF         lcd_puts(buffer1);
	MOVW R30,R28
	RJMP _0x9E
; 0000 00B0     }
; 0000 00B1     else if(mode == 'c')
_0x28:
	LDI  R30,LOW(99)
	CP   R30,R4
	BRNE _0x30
; 0000 00B2     {
; 0000 00B3         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 00B4         lcd_puts("MODE: CC");
	__POINTW1MN _0x29,23
	CALL SUBOPT_0x9
; 0000 00B5         lcd_gotoxy(0,2);
	CALL SUBOPT_0xB
; 0000 00B6         if(status == 'i')
	LDI  R30,LOW(105)
	CP   R30,R3
	BRNE _0x31
; 0000 00B7         {
; 0000 00B8             lcd_puts("SET TO ACTIVE");
	__POINTW1MN _0x29,32
	RJMP _0x9F
; 0000 00B9         }
; 0000 00BA         else if(status == 'w')
_0x31:
	LDI  R30,LOW(119)
	CP   R30,R3
	BRNE _0x33
; 0000 00BB         {
; 0000 00BC             lcd_puts("STATUS: PAUSE");
	__POINTW1MN _0x29,46
	RJMP _0x9F
; 0000 00BD         }
; 0000 00BE         else
_0x33:
; 0000 00BF         {
; 0000 00C0             lcd_puts("STATUS: ACTIVE");
	__POINTW1MN _0x29,60
_0x9F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00C1         }
; 0000 00C2     }
; 0000 00C3     else
	RJMP _0x35
_0x30:
; 0000 00C4     {
; 0000 00C5         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 00C6         lcd_puts("MODE: NORMAL");
	__POINTW1MN _0x29,75
_0x9E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00C7     }
_0x35:
; 0000 00C8 }
	ADIW R28,34
	RET

	.DSEG
_0x29:
	.BYTE 0x58
;
;void normalMode()
; 0000 00CB {

	.CSEG
_normalMode:
; 0000 00CC     if(GAS_PEDAL == ON && speed < 200)
	LDI  R26,0
	SBIC 0x6,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x37
	CALL SUBOPT_0xC
	BRLO _0x38
_0x37:
	RJMP _0x36
_0x38:
; 0000 00CD     {
; 0000 00CE         if(speed < 30)
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R9,R30
	CPC  R10,R31
	BRSH _0x39
; 0000 00CF         {
; 0000 00D0             speed+=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0xA0
; 0000 00D1         }
; 0000 00D2         else
_0x39:
; 0000 00D3         {
; 0000 00D4             speed++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0xA0:
	__ADDWRR 9,10,30,31
; 0000 00D5         }
; 0000 00D6     }
; 0000 00D7     else if(BRAKE_PEDAL == ON && speed > 0)
	RJMP _0x3B
_0x36:
	CALL SUBOPT_0x5
	BRNE _0x3D
	CLR  R0
	CP   R0,R9
	CPC  R0,R10
	BRLO _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 00D8     {
; 0000 00D9         if(speed > 120)
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CP   R30,R9
	CPC  R31,R10
	BRSH _0x3F
; 0000 00DA         {
; 0000 00DB             speed-=20;
	__GETW1R 9,10
	SBIW R30,20
	RJMP _0xA1
; 0000 00DC         }
; 0000 00DD         else if(speed > 80 && speed < 120)
_0x3F:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CP   R30,R9
	CPC  R31,R10
	BRSH _0x42
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CP   R9,R30
	CPC  R10,R31
	BRLO _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 00DE         {
; 0000 00DF             speed-=10;
	__GETW1R 9,10
	SBIW R30,10
	RJMP _0xA1
; 0000 00E0         }
; 0000 00E1         else if(speed > 20 && speed < 80)
_0x41:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R9
	CPC  R31,R10
	BRSH _0x46
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CP   R9,R30
	CPC  R10,R31
	BRLO _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 00E2         {
; 0000 00E3             speed-=5;
	__GETW1R 9,10
	SBIW R30,5
	RJMP _0xA1
; 0000 00E4         }
; 0000 00E5         else
_0x45:
; 0000 00E6         {
; 0000 00E7             speed--;
	__GETW1R 9,10
	SBIW R30,1
_0xA1:
	__PUTW1R 9,10
; 0000 00E8         }
; 0000 00E9     }
; 0000 00EA     else
	RJMP _0x49
_0x3C:
; 0000 00EB     {
; 0000 00EC         if(speed > 0)
	CLR  R0
	CP   R0,R9
	CPC  R0,R10
	BRSH _0x4A
; 0000 00ED         {
; 0000 00EE             speed--;
	CALL SUBOPT_0x2
; 0000 00EF             delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0xD
; 0000 00F0         }
; 0000 00F1     }
_0x4A:
_0x49:
_0x3B:
; 0000 00F2     showLCD(speed);
	ST   -Y,R10
	ST   -Y,R9
	RCALL _showLCD
; 0000 00F3     wheelAndThrottleControl();
	RCALL _wheelAndThrottleControl
; 0000 00F4     brakeLightControl();
	RCALL _brakeLightControl
; 0000 00F5     delay_ms(200);
	CALL SUBOPT_0x1
; 0000 00F6 }
	RET
;
;void cruiseControlMode()
; 0000 00F9 {
_cruiseControlMode:
; 0000 00FA     // This mode initially operate same as normal mode
; 0000 00FB     if(status == 'i')
	LDI  R30,LOW(105)
	CP   R30,R3
	BRNE _0x4B
; 0000 00FC     {
; 0000 00FD         normalMode();
	RCALL _normalMode
; 0000 00FE     }
; 0000 00FF     // When set button is pressed speed is locked, +/-/cancel buttons are actived
; 0000 0100     if(status == 's')
_0x4B:
	LDI  R30,LOW(115)
	CP   R30,R3
	BREQ PC+3
	JMP _0x4C
; 0000 0101     {
; 0000 0102         int i;
; 0000 0103         if(RES_BTN == ON)
	SBIW R28,2
;	i -> Y+0
	SBIC 0x6,2
	RJMP _0x4D
; 0000 0104         {
; 0000 0105             if((200 - speed) >= 5)
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	SUB  R30,R9
	SBC  R31,R10
	SBIW R30,5
	BRLO _0x4E
; 0000 0106             {
; 0000 0107                 for(i = 0; i < 5; i++)
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x50:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRGE _0x51
; 0000 0108                 {
; 0000 0109                     speed++;
	CALL SUBOPT_0x6
; 0000 010A                     delay_ms(400);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0xD
; 0000 010B                     wheelAndThrottleControl();
	CALL SUBOPT_0x0
; 0000 010C                     brakeLightControl();
; 0000 010D                     showLCD(speed);
; 0000 010E                 }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x50
_0x51:
; 0000 010F             }
; 0000 0110             else
	RJMP _0x52
_0x4E:
; 0000 0111             {
; 0000 0112                 while(speed < 200)
_0x53:
	CALL SUBOPT_0xC
	BRSH _0x55
; 0000 0113                 {
; 0000 0114                     speed++;
	CALL SUBOPT_0x6
; 0000 0115                     delay_ms(400);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0xD
; 0000 0116                     wheelAndThrottleControl();
	CALL SUBOPT_0x0
; 0000 0117                     brakeLightControl();
; 0000 0118                     showLCD(speed);
; 0000 0119                 }
	RJMP _0x53
_0x55:
; 0000 011A             }
_0x52:
; 0000 011B         }
; 0000 011C         else if(SET_BTN == ON)
	RJMP _0x56
_0x4D:
	SBIC 0x6,4
	RJMP _0x57
; 0000 011D         {
; 0000 011E             if((speed - 5) >= 45)
	__GETW2R 9,10
	SBIW R26,5
	SBIW R26,45
	BRLO _0x58
; 0000 011F             {
; 0000 0120                 for(i = 0; i < 5; i++)
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x5A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRGE _0x5B
; 0000 0121                 {
; 0000 0122                     speed--;
	CALL SUBOPT_0x2
; 0000 0123                     delay_ms(600);
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CALL SUBOPT_0xD
; 0000 0124                     wheelAndThrottleControl();
	CALL SUBOPT_0x0
; 0000 0125                     brakeLightControl();
; 0000 0126                     showLCD(speed);
; 0000 0127                 }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x5A
_0x5B:
; 0000 0128             }
; 0000 0129             else
	RJMP _0x5C
_0x58:
; 0000 012A             {
; 0000 012B                 while(speed > 45)
_0x5D:
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CP   R30,R9
	CPC  R31,R10
	BRSH _0x5F
; 0000 012C                 {
; 0000 012D                     speed--;
	CALL SUBOPT_0x2
; 0000 012E                     delay_ms(600);
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CALL SUBOPT_0xD
; 0000 012F                     wheelAndThrottleControl();
	CALL SUBOPT_0x0
; 0000 0130                     brakeLightControl();
; 0000 0131                     showLCD(speed);
; 0000 0132                 }
	RJMP _0x5D
_0x5F:
; 0000 0133             }
_0x5C:
; 0000 0134         }
; 0000 0135         else if(CANCEL_BTN == ON || BRAKE_PEDAL == ON)
	RJMP _0x60
_0x57:
	CALL SUBOPT_0x4
	BREQ _0x62
	CALL SUBOPT_0x5
	BRNE _0x61
_0x62:
; 0000 0136         {
; 0000 0137             status = 'w';
	LDI  R30,LOW(119)
	MOV  R3,R30
; 0000 0138         }
; 0000 0139         else
	RJMP _0x64
_0x61:
; 0000 013A         {
; 0000 013B             wheelAndThrottleControl();
	CALL SUBOPT_0x0
; 0000 013C             brakeLightControl();
; 0000 013D             showLCD(speed);
; 0000 013E             delay_ms(200);
	CALL SUBOPT_0x1
; 0000 013F         }
_0x64:
_0x60:
_0x56:
; 0000 0140     }
	ADIW R28,2
; 0000 0141     // The mode will be paused and operated as normal mode when cancel button or brake pedal is pressed
; 0000 0142     if(status == 'w')
_0x4C:
	LDI  R30,LOW(119)
	CP   R30,R3
	BRNE _0x65
; 0000 0143     {
; 0000 0144         normalMode();
	RCALL _normalMode
; 0000 0145     }
; 0000 0146 }
_0x65:
	RET
;
;void wheelAndThrottleControl()
; 0000 0149 {
_wheelAndThrottleControl:
; 0000 014A     if(speed == 0)
	MOV  R0,R9
	OR   R0,R10
	BRNE _0x66
; 0000 014B     {
; 0000 014C         DDRD.5 = 0;
	CBI  0xA,5
; 0000 014D         DDRD.6 = 0;
	CBI  0xA,6
; 0000 014E     }
; 0000 014F     else
	RJMP _0x6B
_0x66:
; 0000 0150     {
; 0000 0151         DDRD.5 = 1;
	SBI  0xA,5
; 0000 0152         DDRD.6 = 1;
	SBI  0xA,6
; 0000 0153         OCR0B = speed*4*60/200; // Speed of wheel
	__GETW1R 9,10
	CALL __LSLW2
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL __DIVW21U
	OUT  0x28,R30
; 0000 0154         OCR0A = 32*(0.005*speed + 0.5) - 1; // Angle position of throttle
	__GETW1R 9,10
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3BA3D70A
	CALL SUBOPT_0xE
	__GETD2N 0x42000000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F800000
	CALL SUBOPT_0xF
	CALL __CFD1U
	OUT  0x27,R30
; 0000 0155     }
_0x6B:
; 0000 0156 }
	RET
;
;void brakeLightControl()
; 0000 0159 {
_brakeLightControl:
; 0000 015A     if(BRAKE_PEDAL == ON)
	SBIC 0x6,1
	RJMP _0x70
; 0000 015B     {
; 0000 015C         PORTB.2 = 1;
	SBI  0x5,2
; 0000 015D     }
; 0000 015E     else
	RJMP _0x73
_0x70:
; 0000 015F     {
; 0000 0160         PORTB.2 = 0;
	CBI  0x5,2
; 0000 0161     }
_0x73:
; 0000 0162 }
	RET
;
;int getGap(unsigned int gapLevel)
; 0000 0165 {
_getGap:
; 0000 0166     if(gapLevel == 1)
;	gapLevel -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x76
; 0000 0167     {
; 0000 0168         return 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x20C0007
; 0000 0169     }
; 0000 016A     else if(gapLevel == 2)
_0x76:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x78
; 0000 016B     {
; 0000 016C         return 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP _0x20C0007
; 0000 016D     }
; 0000 016E     else
_0x78:
; 0000 016F     {
; 0000 0170         return 70;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x20C0007
; 0000 0171     }
; 0000 0172 }
;
;void keepGap()
; 0000 0175 {
_keepGap:
; 0000 0176     if(status == 's' || status == 'i')
	LDI  R30,LOW(115)
	CP   R30,R3
	BREQ _0x7B
	LDI  R30,LOW(105)
	CP   R30,R3
	BRNE _0x7A
_0x7B:
; 0000 0177     {
; 0000 0178         if((distance < (getGap(gapLevel) - 6)) && speed > 0)
	ST   -Y,R8
	ST   -Y,R7
	RCALL _getGap
	SBIW R30,6
	CALL SUBOPT_0x10
	BRSH _0x7E
	CLR  R0
	CP   R0,R9
	CPC  R0,R10
	BRLO _0x7F
_0x7E:
	RJMP _0x7D
_0x7F:
; 0000 0179         {
; 0000 017A             speed--;
	CALL SUBOPT_0x2
; 0000 017B         }
; 0000 017C         else if((distance > getGap(gapLevel) + 6) && speed < 200)
	RJMP _0x80
_0x7D:
	ST   -Y,R8
	ST   -Y,R7
	RCALL _getGap
	ADIW R30,6
	CALL SUBOPT_0x10
	BREQ PC+2
	BRCC PC+3
	JMP  _0x82
	CALL SUBOPT_0xC
	BRLO _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 017D         {
; 0000 017E             speed++;
	CALL SUBOPT_0x6
; 0000 017F         }
; 0000 0180         if(CANCEL_BTN == ON || BRAKE_PEDAL == ON)
_0x81:
_0x80:
	CALL SUBOPT_0x4
	BREQ _0x85
	CALL SUBOPT_0x5
	BRNE _0x84
_0x85:
; 0000 0181         {
; 0000 0182             status = 'w';
	LDI  R30,LOW(119)
	MOV  R3,R30
; 0000 0183             speedTemp = speed;
	__MOVEWRR 11,12,9,10
; 0000 0184         }
; 0000 0185         wheelAndThrottleControl();
_0x84:
	CALL SUBOPT_0x0
; 0000 0186         brakeLightControl();
; 0000 0187         showLCD(speed);
; 0000 0188         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0xD
; 0000 0189     }
; 0000 018A     if(status == 'w')
_0x7A:
	LDI  R30,LOW(119)
	CP   R30,R3
	BRNE _0x87
; 0000 018B     {
; 0000 018C         normalMode();
	RCALL _normalMode
; 0000 018D     }
; 0000 018E }
_0x87:
	RET
;
;void main(void)
; 0000 0191 {
_main:
; 0000 0192 
; 0000 0193 // Crystal Oscillator division factor: 1
; 0000 0194 #pragma optsize-
; 0000 0195 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0196 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0197 #ifdef _OPTIMIZE_SIZE_
; 0000 0198 #pragma optsize+
; 0000 0199 #endif
; 0000 019A 
; 0000 019B // Timer/Counter 0 initialization
; 0000 019C TCCR0A=0b10100011;
	LDI  R30,LOW(163)
	OUT  0x24,R30
; 0000 019D TCCR0B=0b00000100;
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 019E 
; 0000 019F // Timer/Counter 1 initialization
; 0000 01A0 TCCR1A=0x00; // Normal mode
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 01A1 TIMSK1=0b00000001; // Allow interrupt when timer1 overflow
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 01A2 
; 0000 01A3 // Timer/Counter 2 initialization
; 0000 01A4 TCCR2B=0b00000101;
	LDI  R30,LOW(5)
	STS  177,R30
; 0000 01A5 
; 0000 01A6 // External Interrupt(s) initialization
; 0000 01A7 EICRA=0x0A;
	LDI  R30,LOW(10)
	STS  105,R30
; 0000 01A8 EIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x1D,R30
; 0000 01A9 EIFR=0x03;
	OUT  0x1C,R30
; 0000 01AA PCICR=0x02;
	LDI  R30,LOW(2)
	STS  104,R30
; 0000 01AB PCMSK1=0x1F;
	LDI  R30,LOW(31)
	STS  108,R30
; 0000 01AC PCIFR=0x02;
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0000 01AD 
; 0000 01AE // Alphanumeric LCD initialization
; 0000 01AF lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 01B0 
; 0000 01B1 // Set up for all Button
; 0000 01B2 PORTC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x8,R30
; 0000 01B3 PORTD.2 = 1;
	SBI  0xB,2
; 0000 01B4 PORTD.3 = 1;
	SBI  0xB,3
; 0000 01B5 
; 0000 01B6 // Set up for ultrasonic sensor
; 0000 01B7 DDRB.0 = 0;
	CBI  0x4,0
; 0000 01B8 DDRB.1 = 1;
	SBI  0x4,1
; 0000 01B9 
; 0000 01BA // Set up for brake light
; 0000 01BB DDRB.2 = 1;
	SBI  0x4,2
; 0000 01BC PORTB.2 = 0;
	CBI  0x5,2
; 0000 01BD 
; 0000 01BE // Global enable interrupts
; 0000 01BF #asm("sei")
	sei
; 0000 01C0 
; 0000 01C1 while (1)
_0x94:
; 0000 01C2       {
; 0000 01C3         // Cruise control mode
; 0000 01C4         if(mode == 'c')
	LDI  R30,LOW(99)
	CP   R30,R4
	BRNE _0x97
; 0000 01C5         {
; 0000 01C6             cruiseControlMode();
	RCALL _cruiseControlMode
; 0000 01C7         }
; 0000 01C8         // Adaptive cruise control mode
; 0000 01C9         if(mode == 'a')
_0x97:
	LDI  R30,LOW(97)
	CP   R30,R4
	BRNE _0x98
; 0000 01CA         {
; 0000 01CB             activeRadar();
	RCALL _activeRadar
; 0000 01CC             if(distance > 100)
	LDS  R26,_distance
	LDS  R27,_distance+1
	LDS  R24,_distance+2
	LDS  R25,_distance+3
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x99
; 0000 01CD             {
; 0000 01CE                 cruiseControlMode();
	RCALL _cruiseControlMode
; 0000 01CF             }
; 0000 01D0             else
	RJMP _0x9A
_0x99:
; 0000 01D1             {
; 0000 01D2                 keepGap();
	RCALL _keepGap
; 0000 01D3             }
_0x9A:
; 0000 01D4         }
; 0000 01D5         // Normal mode
; 0000 01D6         if(mode == 'n')
_0x98:
	LDI  R30,LOW(110)
	CP   R30,R4
	BRNE _0x9B
; 0000 01D7         {
; 0000 01D8             normalMode();
	RCALL _normalMode
; 0000 01D9         }
; 0000 01DA       }
_0x9B:
	RJMP _0x94
; 0000 01DB }
_0x9C:
	RJMP _0x9C
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x5,6
	RJMP _0x2000005
_0x2000004:
	CBI  0x5,6
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x5,7
	RJMP _0x2000007
_0x2000006:
	CBI  0x5,7
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0xB,4
	RJMP _0x2000009
_0x2000008:
	CBI  0xB,4
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0xB,7
	RJMP _0x200000B
_0x200000A:
	CBI  0xB,7
_0x200000B:
	__DELAY_USB 5
	SBI  0x5,5
	__DELAY_USB 13
	CBI  0x5,5
	__DELAY_USB 13
	RJMP _0x20C0006
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0006
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0007:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x11
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20C0006
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x5,3
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x5,3
	RJMP _0x20C0006
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x4,6
	SBI  0x4,7
	SBI  0xA,4
	SBI  0xA,7
	SBI  0x4,5
	SBI  0x4,3
	SBI  0x4,4
	CBI  0x5,5
	CBI  0x5,3
	CBI  0x5,4
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0006:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_buff_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020018
	__CPWRN 16,17,2
	BRLO _0x2020019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x13
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x202001A
	CALL SUBOPT_0x13
_0x202001A:
_0x2020019:
	RJMP _0x202001B
_0x2020016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x202001B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G101:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202001F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,0
	CALL SUBOPT_0x14
	RJMP _0x20C0005
_0x202001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202001E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,1
	CALL SUBOPT_0x14
	RJMP _0x20C0005
_0x202001E:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x2020021
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x2020021:
	LDD  R17,Y+11
_0x2020022:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020024
	CALL SUBOPT_0x15
	RJMP _0x2020022
_0x2020024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2020025
	LDI  R19,LOW(0)
	CALL SUBOPT_0x15
	RJMP _0x2020026
_0x2020025:
	LDD  R19,Y+11
	CALL SUBOPT_0x16
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020027
	CALL SUBOPT_0x15
_0x2020028:
	CALL SUBOPT_0x16
	BRLO _0x202002A
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	RJMP _0x2020028
_0x202002A:
	RJMP _0x202002B
_0x2020027:
_0x202002C:
	CALL SUBOPT_0x16
	BRSH _0x202002E
	CALL SUBOPT_0x17
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	SUBI R19,LOW(1)
	RJMP _0x202002C
_0x202002E:
	CALL SUBOPT_0x15
_0x202002B:
	__GETD1S 12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x16
	BRLO _0x202002F
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
_0x202002F:
_0x2020026:
	LDI  R17,LOW(0)
_0x2020030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2020032
	__GETD2S 4
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xE
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x17
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x17
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1A
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2020030
	CALL SUBOPT_0x1C
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2020030
_0x2020032:
	CALL SUBOPT_0x1E
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2020034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2020114
_0x2020034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2020114:
	ST   X,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x1E
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G101:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x13
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202003C
	CPI  R18,37
	BRNE _0x202003D
	LDI  R17,LOW(1)
	RJMP _0x202003E
_0x202003D:
	CALL SUBOPT_0x1F
_0x202003E:
	RJMP _0x202003B
_0x202003C:
	CPI  R30,LOW(0x1)
	BRNE _0x202003F
	CPI  R18,37
	BRNE _0x2020040
	CALL SUBOPT_0x1F
	RJMP _0x2020115
_0x2020040:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020041
	LDI  R16,LOW(1)
	RJMP _0x202003B
_0x2020041:
	CPI  R18,43
	BRNE _0x2020042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x202003B
_0x2020042:
	CPI  R18,32
	BRNE _0x2020043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x202003B
_0x2020043:
	RJMP _0x2020044
_0x202003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020045
_0x2020044:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020046
	ORI  R16,LOW(128)
	RJMP _0x202003B
_0x2020046:
	RJMP _0x2020047
_0x2020045:
	CPI  R30,LOW(0x3)
	BRNE _0x2020048
_0x2020047:
	CPI  R18,48
	BRLO _0x202004A
	CPI  R18,58
	BRLO _0x202004B
_0x202004A:
	RJMP _0x2020049
_0x202004B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202003B
_0x2020049:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x202004C
	LDI  R17,LOW(4)
	RJMP _0x202003B
_0x202004C:
	RJMP _0x202004D
_0x2020048:
	CPI  R30,LOW(0x4)
	BRNE _0x202004F
	CPI  R18,48
	BRLO _0x2020051
	CPI  R18,58
	BRLO _0x2020052
_0x2020051:
	RJMP _0x2020050
_0x2020052:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x202003B
_0x2020050:
_0x202004D:
	CPI  R18,108
	BRNE _0x2020053
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x202003B
_0x2020053:
	RJMP _0x2020054
_0x202004F:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x202003B
_0x2020054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020059
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x22
	RJMP _0x202005A
_0x2020059:
	CPI  R30,LOW(0x45)
	BREQ _0x202005D
	CPI  R30,LOW(0x65)
	BRNE _0x202005E
_0x202005D:
	RJMP _0x202005F
_0x202005E:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x2020060
_0x202005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x23
	CALL __GETD1P
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2020061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2020063
	RJMP _0x2020064
_0x2020061:
	CALL SUBOPT_0x26
	CALL __ANEGF1
	CALL SUBOPT_0x24
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020063:
	SBRS R16,7
	RJMP _0x2020065
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x22
	RJMP _0x2020066
_0x2020065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020066:
_0x2020064:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020068
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2020069
_0x2020068:
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G101
_0x2020069:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x27
	RJMP _0x202006A
_0x2020060:
	CPI  R30,LOW(0x73)
	BRNE _0x202006C
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	CALL SUBOPT_0x27
	RJMP _0x202006D
_0x202006C:
	CPI  R30,LOW(0x70)
	BRNE _0x202006F
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x202006D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2020071
	CP   R20,R17
	BRLO _0x2020072
_0x2020071:
	RJMP _0x2020070
_0x2020072:
	MOV  R17,R20
_0x2020070:
_0x202006A:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2020073
_0x202006F:
	CPI  R30,LOW(0x64)
	BREQ _0x2020076
	CPI  R30,LOW(0x69)
	BRNE _0x2020077
_0x2020076:
	ORI  R16,LOW(4)
	RJMP _0x2020078
_0x2020077:
	CPI  R30,LOW(0x75)
	BRNE _0x2020079
_0x2020078:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007A
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x29
	LDI  R17,LOW(10)
	RJMP _0x202007B
_0x202007A:
	__GETD1N 0x2710
	CALL SUBOPT_0x29
	LDI  R17,LOW(5)
	RJMP _0x202007B
_0x2020079:
	CPI  R30,LOW(0x58)
	BRNE _0x202007D
	ORI  R16,LOW(8)
	RJMP _0x202007E
_0x202007D:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200BC
_0x202007E:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020080
	__GETD1N 0x10000000
	CALL SUBOPT_0x29
	LDI  R17,LOW(8)
	RJMP _0x202007B
_0x2020080:
	__GETD1N 0x1000
	CALL SUBOPT_0x29
	LDI  R17,LOW(4)
_0x202007B:
	CPI  R20,0
	BREQ _0x2020081
	ANDI R16,LOW(127)
	RJMP _0x2020082
_0x2020081:
	LDI  R20,LOW(1)
_0x2020082:
	SBRS R16,1
	RJMP _0x2020083
	CALL SUBOPT_0x25
	CALL SUBOPT_0x23
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020116
_0x2020083:
	SBRS R16,2
	RJMP _0x2020085
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	CALL __CWD1
	RJMP _0x2020116
_0x2020085:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	CLR  R22
	CLR  R23
_0x2020116:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020087
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020088
	CALL SUBOPT_0x26
	CALL __ANEGD1
	CALL SUBOPT_0x24
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020088:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020089
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x202008A
_0x2020089:
	ANDI R16,LOW(251)
_0x202008A:
_0x2020087:
	MOV  R19,R20
_0x2020073:
	SBRC R16,0
	RJMP _0x202008B
_0x202008C:
	CP   R17,R21
	BRSH _0x202008F
	CP   R19,R21
	BRLO _0x2020090
_0x202008F:
	RJMP _0x202008E
_0x2020090:
	SBRS R16,7
	RJMP _0x2020091
	SBRS R16,2
	RJMP _0x2020092
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2020093
_0x2020092:
	LDI  R18,LOW(48)
_0x2020093:
	RJMP _0x2020094
_0x2020091:
	LDI  R18,LOW(32)
_0x2020094:
	CALL SUBOPT_0x1F
	SUBI R21,LOW(1)
	RJMP _0x202008C
_0x202008E:
_0x202008B:
_0x2020095:
	CP   R17,R20
	BRSH _0x2020097
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020098
	CALL SUBOPT_0x2A
	BREQ _0x2020099
	SUBI R21,LOW(1)
_0x2020099:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020098:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x202009A
	SUBI R21,LOW(1)
_0x202009A:
	SUBI R20,LOW(1)
	RJMP _0x2020095
_0x2020097:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x202009B
_0x202009C:
	CPI  R19,0
	BREQ _0x202009E
	SBRS R16,3
	RJMP _0x202009F
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20200A0
_0x202009F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20200A0:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x20200A1
	SUBI R21,LOW(1)
_0x20200A1:
	SUBI R19,LOW(1)
	RJMP _0x202009C
_0x202009E:
	RJMP _0x20200A2
_0x202009B:
_0x20200A4:
	CALL SUBOPT_0x2B
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A6
	SBRS R16,3
	RJMP _0x20200A7
	SUBI R18,-LOW(55)
	RJMP _0x20200A8
_0x20200A7:
	SUBI R18,-LOW(87)
_0x20200A8:
	RJMP _0x20200A9
_0x20200A6:
	SUBI R18,-LOW(48)
_0x20200A9:
	SBRC R16,4
	RJMP _0x20200AB
	CPI  R18,49
	BRSH _0x20200AD
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200AC
_0x20200AD:
	RJMP _0x20200AF
_0x20200AC:
	CP   R20,R19
	BRSH _0x2020117
	CP   R21,R19
	BRLO _0x20200B2
	SBRS R16,0
	RJMP _0x20200B3
_0x20200B2:
	RJMP _0x20200B1
_0x20200B3:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200B4
_0x2020117:
	LDI  R18,LOW(48)
_0x20200AF:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200B5
	CALL SUBOPT_0x2A
	BREQ _0x20200B6
	SUBI R21,LOW(1)
_0x20200B6:
_0x20200B5:
_0x20200B4:
_0x20200AB:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x20200B7
	SUBI R21,LOW(1)
_0x20200B7:
_0x20200B1:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x2B
	CALL __MODD21U
	CALL SUBOPT_0x24
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x29
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20200A5
	RJMP _0x20200A4
_0x20200A5:
_0x20200A2:
	SBRS R16,0
	RJMP _0x20200B8
_0x20200B9:
	CPI  R21,0
	BREQ _0x20200BB
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x22
	RJMP _0x20200B9
_0x20200BB:
_0x20200B8:
_0x20200BC:
_0x202005A:
_0x2020115:
	LDI  R17,LOW(0)
_0x202003B:
	RJMP _0x2020036
_0x2020038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x2C
	SBIW R30,0
	BRNE _0x20200BD
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x20200BD:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x2C
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x2D
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x2D
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x2D
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x20A0000,0
	RCALL SUBOPT_0x14
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x20A0000,1
	RCALL SUBOPT_0x14
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x1B
	CALL __MULF12
	RCALL SUBOPT_0x32
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x33
	CALL __ADDF12
	RCALL SUBOPT_0x2F
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x32
_0x20A0014:
	RCALL SUBOPT_0x33
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x32
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x20A0000,5
	RCALL SUBOPT_0x14
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0x30
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001C
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0xE
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x1D
	LDI  R31,0
	RCALL SUBOPT_0x31
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x2F
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x30
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x2F
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x1D
	LDI  R31,0
	RCALL SUBOPT_0x34
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x2F
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
_distance:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x0:
	CALL _wheelAndThrottleControl
	CALL _brakeLightControl
	ST   -Y,R10
	ST   -Y,R9
	JMP  _showLCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	__GETW1R 9,10
	SBIW R30,1
	__PUTW1R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBIC 0x6,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R26,0
	SBIC 0x6,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R9,R30
	CPC  R10,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDS  R26,_distance
	LDS  R27,_distance+1
	LDS  R24,_distance+2
	LDS  R25,_distance+3
	CALL __CWD1
	CALL __CDF1
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x15:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x16:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	__GETD1N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x20:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x22:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x23:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x20
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x23
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2A:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x30:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
