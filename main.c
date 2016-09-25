#include <stdint.h>
#define RCC_BASE				0x40023800
#define RCC_AHB1ENR				(RCC_BASE + 0x30)
#define RCC_AHB1Periph_GPIOA	0x00000001
#define AHB1PERIPH_BASE			0x40020000
#define GPIOA_BASE				AHB1PERIPH_BASE
#define LEDDELAY				800000
#define GPIO_Pin_5				0x0020

#define writel(address, value)		(*((volatile uint32_t *)(address)) = value)
#define readl(address)				*((volatile uint32_t *)(address))
#define setbits(address, bitsmask)	(*((volatile uint32_t *)(address)) |= bitsmask)
#define clearbits(address, bitsmask)	(*((volatile uint32_t *)(address)) &= ~bitsmask)
void delay(uint32_t count)
{
	volatile uint32_t tmp = count;
	while(tmp--)
	{
	}
}

void led_init(void)
{
	setbits(RCC_BASE + 0x30, RCC_AHB1Periph_GPIOA);
	clearbits(GPIOA_BASE + 0x00, 0xC00);
	setbits(GPIOA_BASE + 0x00, 0x400);
	writel(GPIOA_BASE + 0x0C, 0x00);
}

void led_toggle(void)
{
	writel(GPIOA_BASE + 0x14, readl(GPIOA_BASE + 0x14) ^ GPIO_Pin_5);
}

int main(void)
{
	led_init();
	while(1)
	{
		led_toggle();
		delay(LEDDELAY);
	}
}
