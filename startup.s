.equ RCC_BASE,0x40023800
.equ RCC_AHB1ENR,0x40023830
.equ RCC_AHB1Periph_GPIOA,0x00000001
.equ AHB1PERIPH_BASE,0x40020000
.equ GPIO_Pin_5, 0x0020
.equ GPIOA_BASE, AHB1PERIPH_BASE
.equ LEDDELAY,    800000
.syntax unified
.thumb

.global _start
# Allocate isr vector
.section  .isr_vector,"a",%progbits
_start: 
	.word   _estack
	.word Reset_Handler
	.word NMI_Handler
	.word HardFault_Handler
	.word MemManage_Handler
	.word BusFault_Handler
	.word UsageFault_Handler

.section	.text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
	b	Infinite_Loop
	.size	Default_Handler, .-Default_Handler

.text
.type Reset_Handler,%function
Reset_Handler:
	/* load RCC addr into r0*/
	ldr r0, = RCC_BASE
	/* load the content of RCC_AHB1ENR into r1*/
	ldr r1, [r0, #0x30]
	/*or r1 with 1 to enable gpioA*/
	orr r1, RCC_AHB1Periph_GPIOA
	str r1, [r0, #0x30]
	/*set gpioA to mode output */
	ldr r0, =GPIOA_BASE
	/*load the content of GPIOA_MODER register into r1*/
	ldr r1,[r0,#0x00]
	bic r1,r1,0xC00
	orr r1,0x400
	str r1,[r0, #0]
	/*set gpio as no pull*/
	mov r1, 0x00
	str r1, [r0, #0x0C]
loop:
	ldr r1, =GPIO_Pin_5
	strh r1, [r0, #0x18]
	ldr r1, = LEDDELAY
delay1:
	subs r1, 1
	bne delay1
	ldr r1, =GPIO_Pin_5
	strh r1, [r0, #0x1A]

	ldr r1, = LEDDELAY
delay2:
	subs r1, 1
	bne delay2
	b loop

.weak  NMI_Handler
.thumb_set NMI_Handler,Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler,Default_Handler

.weak MemManage_Handler
.thumb_set MemManage_Handler,Default_Handler

.weak BusFault_Handler
.thumb_set BusFault_Handler,Default_Handler

.weak UsageFault_Handler
.thumb_set UsageFault_Handler,Default_Handler
