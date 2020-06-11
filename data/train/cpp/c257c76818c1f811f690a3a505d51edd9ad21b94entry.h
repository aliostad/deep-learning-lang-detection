/*
 * entry.h - Definició del punt d'entrada de les crides al sistema
 */

#ifndef __ENTRY_H__
#define __ENTRY_H__

// Interrupt handlers
void divide_error_handler();
void debug_handler();
void NMI_handler();
void breakpoint_handler();
void overflow_handler();
void bounds_check_handler();
void invalid_opcode_handler();
void device_not_available_handler();
void double_fault_handler();
void coprocessor_segment_overrun_handler();
void invalid_tss_handler();
void segment_not_present_handler();
void stack_exception_handler();
void general_protection_handler();
void page_fault_handler();
void floating_point_error_handler();
void aligment_check_handler();

void timer_handler();
void keyboard_handler();

void sys_call_handler();

#endif  /* __ENTRY_H__ */
