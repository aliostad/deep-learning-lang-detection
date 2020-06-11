/*
 * Copyright (C) ST-Ericsson SA 2010. All rights reserved.
 * This code is ST-Ericsson proprietary and confidential.
 * Any use of the code for whatever purpose is subject to
 * specific written permission of ST-Ericsson SA.
 */ 

#ifndef __HALGPSTRACE_HIC__
#define __HALGPSTRACE_HIC__
/**
* \file halgpstrace.hic
* \date 10/04/2008
* \version 1.0
*
* <B>Compiler:</B> ARM ADS\n
*
* <B>Description:</B> This file contain all constant to manage trace.\n
* 
* <TABLE>
*     <TR>
*             <TD> Date</TD><TD> Author</TD><TD> Description</TD>
*     </TR>
*     <TR>
*             <TD> 10.04.08</TD><TD> M.BELOU </TD><TD> Creation </TD>
*     </TR>
* </TABLE>
*/
 

/**
* \def HALGPS_MAX_ERROR_SIZE
*
* Define the max size of buffer containing the error number
*/
#define HALGPS_MAX_ERROR_SIZE 64
 

/** 
* \enum e_halgps_internal_state  
*
*define the HALGPS State
*
*/
typedef enum 
{
    HALGPS_FIRST_ERROR=1,
    HALGPS_SECOND_ERROR,
    HALGPS_THIRD_ERROR,
    HALGPS_FOURTH_ERROR,
    HALGPS_FIFTH_ERROR
} e_halgps_ErrorNumberFunction; 


#endif /*__HALGPSTRACE_HIC__*/
