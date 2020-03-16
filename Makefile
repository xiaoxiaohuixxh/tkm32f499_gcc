CROSS_COMPILE ?= arm-none-eabi-
CC      = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
OBJSIZE = $(CROSS_COMPILE)size
CFLAGS  = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -std=c99 
CFLAGS += -ffunction-sections -fdata-sections -fno-common -funsigned-char -mno-unaligned-access

DEBUG = 0
ifeq ($(DEBUG),1)
CFLAGS += -O0 -g
else
CFLAGS += -O2
endif

ASFLAGS = $(CFLAGS)

LINKER_SCRIPT = tkm32.ld
LDFLAGS = -Wl,--gc-sections -Wl,-Map=$@.map -T $(LINKER_SCRIPT) -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -specs=nosys.specs -specs=nano.specs -u _printf_float


INC =  -ICMSIS_and_startup/CMSIS/
INC += -ICMSIS_and_startup/
INC += -IHal_lib/inc/
INC += -I.


SRC = $(addprefix Hal_lib/src/,\
	HAL_gpio.c\
	HAL_misc.c\
	HAL_rcc.c\
	HAL_tim.c\
	HAL_uart.c\
)
SRC += main.c
SRC += UART.c
SRC += CMSIS_and_startup/sys.c
SRS = startup_TKM32.s


BUILD ?= out

TARGET ?= tkm32_gcc

OBJS = $(addprefix $(BUILD)/, $(SRC:.c=.o) $(SRS:.s=.o))
.PHONY:all clean flash

all: $(BUILD)/$(TARGET).elf

$(BUILD)/$(TARGET).elf: $(OBJS)
	$(CC) -o $@ $(LDFLAGS) $(OBJS)
	$(OBJCOPY) -O ihex   $@ $(BUILD)/$(TARGET).hex
	$(OBJCOPY) -O binary $@ $(BUILD)/$(TARGET).bin
	$(OBJSIZE) $@
	$(OBJDUMP) -d $@ > $(BUILD)/$(TARGET).elf.dis

$(BUILD)/%.o: %.c
	echo "Compiling $^"
	$(CC) -c -o $@ $(CFLAGS) $(INC) $<

$(BUILD)/%.o: %.s
	echo "Assembling $^"
	$(CC) -c -o $@ $(ASFLAGS) $<


# $(sort $(var)) removes duplicates
#
# The net effect of this, is it causes the objects to depend on the
# object directories (but only for existence), and the object directories
# will be created if they don't exist.
OBJ_DIRS = $(sort $(dir $(OBJS)))
$(OBJS): | $(OBJ_DIRS)
$(OBJ_DIRS):
	mkdir -p $@

flash:
	./flash_download.exe $(BUILD)/$(TARGET).bin TK499_V2
clean:
	rm -rf $(BUILD)/*
