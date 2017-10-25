export
# Собираем все необходимые .h файлы FreeRTOS.

ifndef FREE_RTOS_C_FLAGS
	FREE_RTOS_C_FLAGS = $(C_FLAGS)
endif

# FreeRTOS.h должен обязательно идти первым! 
FREE_RTOS_H_FILE	:= FreeRTOS_for_stm32f2/FreeRTOS.h
FREE_RTOS_H_FILE	+= $(wildcard FreeRTOS_for_stm32f2/include/*.h)

# Директории, в которых лежат файлы FreeRTOS.
FREE_RTOS_DIR		:= FreeRTOS_for_stm32f2
FREE_RTOS_DIR		+= FreeRTOS_for_stm32f2/include

# Подставляем перед каждым путем директории префикс -I.
FREE_RTOS_PATH		:= $(addprefix -I, $(FREE_RTOS_DIR))

# Получаем список .c файлов ( путь + файл.c ).
FREE_RTOS_C_FILE	:= $(wildcard FreeRTOS_for_stm32f2/*.c)

# Получаем список .o файлов ( путь + файл.o ).
# Сначала прибавляем префикс ( чтобы все .o лежали в отдельной директории
# с сохранением иерархии.
FREE_RTOS_OBJ_FILE	:= $(addprefix build/obj/, $(FREE_RTOS_C_FILE))
# Затем меняем у всех .c на .o.
FREE_RTOS_OBJ_FILE	:= $(patsubst %.c, %.o, $(FREE_RTOS_OBJ_FILE))

FREE_RTOS_INCLUDE_FILE	:= -include"./FreeRTOS_for_stm32f2/include/StackMacros.h"

# Сборка FreeRTOS.
# $< - текущий .c файл (зависемость).
# $@ - текущая цель (создаваемый .o файл).
# $(dir путь) - создает папки для того, чтобы путь файла существовал.
build/obj/FreeRTOS_for_stm32f2/%.o:	FreeRTOS_for_stm32f2/%.c 
	@echo [CC] $<
	@mkdir -p $(dir $@)
	@$(CC) $(FREE_RTOS_C_FLAGS) $(FREE_RTOS_PATH) $(USER_CFG_PATH) $(FREE_RTOS_INCLUDE_FILE) -c $< -o $@


# Добавляем к общим переменным проекта.
PROJECT_PATH			+= $(FREE_RTOS_PATH)
PROJECT_OBJ_FILE		+= $(FREE_RTOS_OBJ_FILE)