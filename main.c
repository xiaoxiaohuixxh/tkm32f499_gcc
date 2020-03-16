#include "HAL_conf.h"
#include "UART.h"
#include "sys.h"
// unsigned char test_str[0x8000]="123";

// void func (uint32_t reserved, uint32_t mach, uint32_t dt) __attribute__((section(".ARM.__at_0x70028000")));
 
// void func (uint32_t reserved, uint32_t mach, uint32_t dt) {
//     printf("\r\n xiaohui TK499 __at_0x7002c000 \r\n");
// }
int main(void)
{
	RemapVtorTable();
	uint32_t i ,j;
	// GPIO_InitTypeDef GPIO_InitStructure;
	// RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOD, ENABLE);

	// GPIO_InitStructure.GPIO_Pin  =  GPIO_Pin_8;
	// GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	// GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	// GPIO_Init(GPIOD, &GPIO_InitStructure);
	// memset(test_str+strlen(test_str),0,sizeof(test_str));
	// UartInit(UART1,460800);
	while(1)
	{
		// GPIO_SetBits(GPIOD, GPIO_Pin_8);
		// for(i=0;i<200000;i++);
		
		// GPIO_ResetBits(GPIOD, GPIO_Pin_8);
		// for(i=0;i<200000;i++);

		GPIO_SetBits(GPIOD, GPIO_Pin_8);
		printf("\r\n xiaohui TK499 2535418266@qq.com\r\n");
		printf("\r\n xiaohui TK499 2535418266@qq.com %x\r\n",*(uint32_t *)0x7002c000);
		// void (*kernel)(uint32_t reserved, uint32_t mach, uint32_t dt) = (void (*)(uint32_t, uint32_t, uint32_t))(0x7002c000);
		// kernel(0, ~0UL, 0x70024000);
		// printf("end kernel\r\n");
		printf("main addr %x\r\n",&main);
		printf("i addr %x\r\n",&i);
		// printf(test_str);
		for(i=0;i<2000;i++);
		GPIO_ResetBits(GPIOD, GPIO_Pin_8);
		i=1000000;while(i--); 
	}
}

int _write(int fd, char *ptr, int len)
{
	int i;
	for(i = 0; i < len; i++)
	{
		while((UART1->CSR &0x1) == 0){}
		// UART1->TDR=(u8)*ptr++;
		*(uint32_t *)(0x40010800)=(u8)*ptr++;
	}
 	
	return len;
}


