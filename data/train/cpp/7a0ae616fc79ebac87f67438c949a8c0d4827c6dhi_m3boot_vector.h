/******************************************************************************/
/*  Copyright (C), 2007-2013, Hisilicon Technologies Co., Ltd. */
/******************************************************************************/
/* File name     : hi_m3boot_vector.h */
/* Version       : 2.0 */
/* Created       : 2013-05-10*/
/* Last Modified : */
/* Description   : */
/* Function List : */
/* History       : */
/* 1 Date        : */
/* Modification  : Create file */
/******************************************************************************/
#ifndef __HI_M3_VECTOR_H__
#define __HI_M3_VECTOR_H__

#define M3_BOOT_VECTORS \
    .word     STACK_ENTRY        ;  \
    .word     _start             ;  \
    .word     NmiSR              ;  \
    .word     FaultISR           ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     0                  ;  \
    .word     0                  ;  \
    .word     0                  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     0                  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler  ;  \
    .word     IntDefaultHandler

#endif
