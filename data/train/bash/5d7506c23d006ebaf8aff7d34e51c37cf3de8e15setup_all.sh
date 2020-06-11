#!/bin/bash

dir=$(dirname $0)

source $dir/gpio.sh
source $dir/pwm.sh
source $dir/adc.sh

enable_adcs


### Motors ###

# Motor1_Dir on P9_13
load_gpio 31 out

# Motor2_Dir on P9_12
load_gpio 60 out

# Motor3_Dir on P9_27
load_gpio 115 out

# Motor_Enable on P9_25
load_gpio 117 out

# Motor1 on P9_16 (pwm4/EHRPM1B)
load_pwm 4
set_period 4 1000000
set_duty   4  250000
set_polarity 4 0

# Motor2 on P9_14 (pwm3/EHRPM1A)
load_pwm 3
set_period 3 1000000
set_duty   3  250000
set_polarity 3 0

# Motor3 on P9_29 (pwm1/EHRPM0B)
load_pwm 1
set_period 1 1000000
set_duty   1  250000
set_polarity 1 0


### IR ###

# IR_W on P8_27
load_gpio 86 in

# IR_S on P8_28
load_gpio 88 in

# IR_E on P8_29
load_gpio 87 in

# IR_N on P8_30
load_gpio 89 in

# IR_RX_enable on P9_23
load_gpio 49 out

# IR_TX_PWM on P9_28 (pwm7/ecap2)
load_pwm 7
set_period 7 18000  # ~56kHz
set_duty   7 12000
set_polarity 7 0


### Camera ###

# Camera servo on P9_42 (pwm2/ecap0)
load_pwm 2
set_period 2 10000000
set_duty   2  1924925   # 135 degrees
#set_duty   2  2400000
set_polarity 2 0
run_pwm 2


### DMS ###

# DMS_Sel_A on P9_11
load_gpio 30 out

# DMS_Sel_B on P9_21
load_gpio 3 out

# DMS_Sel_C on P9_22
load_gpio 2 out


