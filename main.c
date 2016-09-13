#include <stdint.h>
#define RCC_BASE				0x40023800
#define RCC_AHB1ENR				(RCC_BASE + 0x30)
#define RCC_AHB1Periph_GPIOA	0x00000001
#define AHB1PERIPH_BASE			0x40020000
#define GPIOA_BASE				AHB1PERIPH_BASE
#define LEDDELAY				800000
#define GPIO_Pin_5				0x0020

void delay(uint32_t count)
{
	volatile uint32_t tmp = count;
	while(tmp--)
	{
	}
}
int main(void)
{
	*((volatile uint32_t *)(RCC_BASE + 0x30)) |= RCC_AHB1Periph_GPIOA;

	*((volatile uint32_t *)(GPIOA_BASE + 0x00)) &= ~0xC00;
	*((volatile uint32_t *)(GPIOA_BASE + 0x00)) |= 0x400;

	*((volatile uint32_t *)(GPIOA_BASE + 0x0C)) = 0x00;
	while(1)
	{
		*((volatile uint16_t *)(GPIOA_BASE + 0x14)) ^= GPIO_Pin_5;
		delay(LEDDELAY);
	}
}
