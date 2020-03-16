#include "UART.h"

void UartInit(UART_TypeDef* UARTx,int BaudRate)
{
	UART_InitTypeDef       UART_InitStructure;  
	GPIO_InitTypeDef  GPIO_InitStructure;   
	
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOA, ENABLE);
	GPIO_InitStructure.GPIO_Pin  = GPIO_Pin_9;   //uart1_tx  PA9
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP; // ���⸴�����
  GPIO_Init(GPIOA, &GPIO_InitStructure);

  GPIO_InitStructure.GPIO_Pin  = GPIO_Pin_10;  //uart1_rx  PA10
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU; //��������   

  GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	GPIO_PinAFConfig(GPIOA, GPIO_Pin_9 | GPIO_Pin_10, GPIO_AF_UART_1); //PA9��PA10����Ϊ����1
	GPIO_PinAFConfig(GPIOA, GPIO_Pin_15, GPIO_AF_GPIO); //PA15����Ϊ��ͨGPIO
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_UART1, ENABLE);
	UART_InitStructure.UART_BaudRate = BaudRate; //������
  UART_InitStructure.UART_WordLength = UART_WordLength_8b;//����λ
  UART_InitStructure.UART_StopBits = UART_StopBits_1;//ֹͣλ
  UART_InitStructure.UART_Parity = UART_Parity_No ;
  UART_InitStructure.UART_Mode = UART_Mode_Rx | UART_Mode_Tx;//�������ģʽ
  UART_InitStructure.UART_HardwareFlowControl = UART_HardwareFlowControl_None; 	
	UART_Init(UARTx, &UART_InitStructure);
	UART_Cmd(UARTx, ENABLE);  //UART ģ��ʹ��
	
  UART_ClearITPendingBit(UARTx, 0xff); 

}
u8 Uart1_Receive(void)
{
	//�ж������Ƿ���
  while((UART1->CSR & (1<<1)) ==0);
	return UART1->RDR;

}

void send_data(u8 data)
{
	while((UART1->CSR &0x1) == 0);
	UART1->TDR = data; 
}
void send_group(u8*data,u16 len)
{
	while(len--)
	send_data(*data++);
}
void send_str(char *p)
{
		while(*p != '\0')
		{
			send_data(*p);
			p++;
		}
}

//�������д��룬���ù�ѡUSE microlib,ʹ��printf

// #pragma import(__use_no_semihosting)                          
// struct __FILE 
// { 
// int handle; 
// }; 
// FILE __stdout;       
// void _sys_exit(int x) 
// { 
// x = x; 
// } 
// int fputc(int ch, FILE *f)
// {      
// while((UART1->CSR &0x1) == 0){}
// 	UART1->TDR = (u8) ch;      
// return ch;
// }


