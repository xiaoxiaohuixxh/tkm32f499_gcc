    .syntax unified
    .arch armv7-m
	.thumb

/* Memory Model
   The HEAP starts at the end of the DATA section and grows upward.
   
   The STACK starts at the end of the RAM and grows downward     */
    .section .stack
    .align 3
    .globl    __StackTop
    .globl    __StackLimit
__StackLimit:
    .space    0x1200
__StackTop:


    .section .heap
    .align 3
    .globl    __HeapBase
    .globl    __HeapLimit
__HeapBase:
    .space    0x4000
__HeapLimit:


    .section .isr_vector
    .align 2
    .globl __isr_vector
__isr_vector:
    .long    __StackTop            
    .long    Reset_Handler         
    .long    NMI_Handler          
    .long    HardFault_Handler     
    .long    MemManage_Handler     
    .long    BusFault_Handler      
    .long    UsageFault_Handler   
    .long    0                    
    .long    0                    
    .long    0                    
    .long    0                     
    .long    SVC_Handler          
    .long    DebugMon_Handler     
    .long    0                     
    .long    PendSV_Handler           
    .long    SysTick_Handler         

    /* External interrupts */
    .long     WWDG_IRQHandler
    .long     0
    .long     TAMPER_IRQHandler           
    .long     RTC_IRQHandler              
    .long     0                           
    .long     RCC_IRQHandler              
    .long     EXTI0_IRQHandler            
    .long     EXTI1_IRQHandler            
    .long     EXTI2_IRQHandler            
    .long     EXTI3_IRQHandler            
    .long     EXTI4_IRQHandler            
    .long     DMA1_Channel1_IRQHandler    
    .long     DMA1_Channel2_IRQHandler    
    .long     DMA1_Channel3_IRQHandler    
    .long     DMA1_Channel4_IRQHandler    
    .long     DMA1_Channel5_IRQHandler    
    .long     DMA1_Channel6_IRQHandler    
    .long     DMA1_Channel7_IRQHandler    
    .long     ADC1_IRQHandler             
    .long     CAN1_IRQHandler         	 
    .long      0                          
    .long      0                          
    .long      0                          
    .long     EXTI9_5_IRQHandler          
    .long     TIM1_BRK_IRQHandler         
    .long     TIM1_UP_IRQHandler          
    .long     TIM1_TRG_COM_IRQHandler     
    .long     TIM1_CC_IRQHandler          
    .long     TIM3_IRQHandler             
    .long     TIM4_IRQHandler             
    .long     TIM5_IRQHandler             
    .long     TIM6_IRQHandler             
    .long     TIM7_IRQHandler             
    .long     I2C1_IRQHandler             
    .long     I2C2_IRQHandler             
    .long     SPI1_IRQHandler             
    .long     SPI2_IRQHandler             
    .long     UART1_IRQHandler            
    .long     UART2_IRQHandler            
    .long     UART3_IRQHandler            
    .long     EXTI15_10_IRQHandler        
    .long     RTCAlarm_IRQHandler         
    .long     USBAwake_IRQHandler         
    .long     TIM2_BRK_IRQHandler         
    .long     TIM2_UP_IRQHandler          
    .long     TIM2_TRG_COM_IRQHandler     
    .long     TIM2_CC_IRQHandler          
    .long     DMA1_Channel8_IRQHandler    
    .long     TK80_IRQHandler             
    .long     SDIO1_IRQHandler            
    .long     SDIO2_IRQHandler            
    .long     SPI3_IRQHandler             
    .long     UART4_IRQHandler            
    .long     UART5_IRQHandler            
    .long     0                           
    .long     TIM8_IRQHandler             
    .long     DMA2_Channel1_IRQHandler    
    .long     DMA2_Channel2_IRQHandler    
    .long     DMA2_Channel3_IRQHandler    
    .long     DMA2_Channel4_IRQHandler    
    .long     DMA2_Channel5_IRQHandler    
    .long     TIM9_IRQHandler             
    .long     TIM10_IRQHandler            
    .long     CAN2_IRQHandler             
    .long     0                           
    .long     0                           
    .long     0                           
    .long     USB_IRQHandler              
    .long     DMA2_Channel6_IRQHandler    
    .long     DMA2_Channel7_IRQHandler    
    .long     DMA2_Channel8_IRQHandler    
    .long      0                          
    .long     I2C3_IRQHandler             
    .long     I2C4_IRQHandler             
    .long     0                           
    .long     0                           
    .long     0                           
    .long     0                           
    .long     0                           
    .long     0                           
    .long     0                          
    .long     FPU_IRQHandler              
    .long     0                           
    .long     0                           
    .long     SPI4_IRQHandler             
    .long     0                           
    .long     TOUCHPAD_IRQHandler         
    .long     QSPI_IRQHandler             
    .long     LTDC_IRQHandler             
    .long     0                           
    .long     I2S1_IRQHandler             


	.section .text.Reset_Handler
    .align 2
    .globl    Reset_Handler
    .type     Reset_Handler, %function
Reset_Handler:
/* Loop to copy data from read only memory to RAM. The ranges
 * of copy from/to are specified by symbols evaluated in linker script.  */
    ldr    sp, =__StackTop    		 /* set stack pointer */
    @ LDR R1, =0x40010800
	@ MOV R2, #0x36
    @ STRB R2, [R1]
    @ ldr    r1, =__data_load__
    @ ldr    r2, =__data_start__
    @ ldr    r3, =__data_end__

@ .Lflash_to_ram_loop:
@     cmp     r2, r3
@     ittt    lo
@     ldrlo   r0, [r1], #4
@     strlo   r0, [r2], #4
@     blo    .Lflash_to_ram_loop


    ldr    r2, =__bss_start__
    ldr    r3, =__bss_end__
@ clean bss
.Lbss_to_ram_loop:
    cmp     r2, r3
    ittt    lo
    movlo   r0, #0
    strlo   r0, [r2], #4
    blo    .Lbss_to_ram_loop
    
    @ LDR     R0, =0xE000ED88    /*enable hard float math CP10,CP11*/
    @ LDR     R1,[R0]
    @ ORR     R1,R1,#(0xF << 20)
    @ STR     R1,[R0]

    ldr    r0, =main
    bx     r0
    .pool    


    .text
/* Macro to define default handlers. 
   Default handler will be weak symbol and just dead loops. */
    .macro    def_default_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .endm

    def_default_handler    NMI_Handler
    def_default_handler    HardFault_Handler
    def_default_handler    MemManage_Handler
    def_default_handler    BusFault_Handler
    def_default_handler    UsageFault_Handler
    def_default_handler    SVC_Handler
    def_default_handler    DebugMon_Handler
    def_default_handler    PendSV_Handler
    def_default_handler    SysTick_Handler

    def_default_handler    WWDG_IRQHandler
    def_default_handler    TAMPER_IRQHandler
    def_default_handler    RTC_IRQHandler
    def_default_handler    RCC_IRQHandler
    def_default_handler    EXTI0_IRQHandler
    def_default_handler    EXTI1_IRQHandler
    def_default_handler    EXTI2_IRQHandler
    def_default_handler    EXTI3_IRQHandler
    def_default_handler    EXTI4_IRQHandler
    def_default_handler    DMA1_Channel1_IRQHandler
    def_default_handler    DMA1_Channel2_IRQHandler
    def_default_handler    DMA1_Channel3_IRQHandler
    def_default_handler    DMA1_Channel4_IRQHandler
    def_default_handler    DMA1_Channel5_IRQHandler
    def_default_handler    DMA1_Channel6_IRQHandler
    def_default_handler    DMA1_Channel7_IRQHandler
    def_default_handler    ADC1_IRQHandler
    def_default_handler    CAN1_IRQHandler 	
    def_default_handler    EXTI9_5_IRQHandler
    def_default_handler    TIM1_BRK_IRQHandler
    def_default_handler    TIM1_UP_IRQHandler
    def_default_handler    TIM1_TRG_COM_IRQHandler
    def_default_handler    TIM1_CC_IRQHandler
    def_default_handler    TIM3_IRQHandler
    def_default_handler    TIM4_IRQHandler
    def_default_handler    TIM5_IRQHandler
    def_default_handler    TIM6_IRQHandler
    def_default_handler    TIM7_IRQHandler
    def_default_handler    I2C1_IRQHandler
    def_default_handler    I2C2_IRQHandler
    def_default_handler    SPI1_IRQHandler
    def_default_handler    SPI2_IRQHandler
    def_default_handler    UART1_IRQHandler
    def_default_handler    UART2_IRQHandler
    def_default_handler    UART3_IRQHandler
    def_default_handler    EXTI15_10_IRQHandler
    def_default_handler    RTCAlarm_IRQHandler
    def_default_handler    USBAwake_IRQHandler
    def_default_handler    TIM2_BRK_IRQHandler
    def_default_handler    TIM2_UP_IRQHandler
    def_default_handler    TIM2_TRG_COM_IRQHandler
    def_default_handler    TIM2_CC_IRQHandler
    def_default_handler    DMA1_Channel8_IRQHandler
    def_default_handler    TK80_IRQHandler
    def_default_handler    SDIO1_IRQHandler
    def_default_handler    SDIO2_IRQHandler
    def_default_handler    SPI3_IRQHandler
    def_default_handler    UART4_IRQHandler
    def_default_handler    UART5_IRQHandler
    def_default_handler    TIM8_IRQHandler
    def_default_handler    DMA2_Channel1_IRQHandler
    def_default_handler    DMA2_Channel2_IRQHandler
    def_default_handler    DMA2_Channel3_IRQHandler
    def_default_handler    DMA2_Channel4_IRQHandler
    def_default_handler    DMA2_Channel5_IRQHandler
    def_default_handler    TIM9_IRQHandler
    def_default_handler    TIM10_IRQHandler
    def_default_handler    CAN2_IRQHandler
    def_default_handler    USB_IRQHandler
    def_default_handler    DMA2_Channel6_IRQHandler
    def_default_handler    DMA2_Channel7_IRQHandler
    def_default_handler    DMA2_Channel8_IRQHandler
    def_default_handler    I2C3_IRQHandler
    def_default_handler    I2C4_IRQHandler
    def_default_handler    FPU_IRQHandler
    def_default_handler    SPI4_IRQHandler
    def_default_handler    QSPI_IRQHandler
    def_default_handler    TOUCHPAD_IRQHandler
    def_default_handler    LTDC_IRQHandler
    def_default_handler    I2S1_IRQHandler 

    def_default_handler    Default_Handler

    .end
