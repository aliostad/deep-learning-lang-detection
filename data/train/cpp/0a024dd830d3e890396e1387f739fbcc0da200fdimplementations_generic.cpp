//Generic Implementations
#include "types.h"


longSample conv_split_unrolled4_sep_result(sample* data, sample* coeffs, int len, int last_idx)
{      
    sample *dp = data;
    sample *cp = coeffs;
    longSample a[4] = {0.0, 0.0, 0.0, 0.0};
   
    dp = data+last_idx;
    int cnt = len - last_idx;
    for (; cnt >= 4; cnt -= 4)
    {
        a[0] += (longSample)*dp++ * (longSample)*cp++;
        a[1] += (longSample)*dp++ * (longSample)*cp++;
        a[2] += (longSample)*dp++ * (longSample)*cp++;
        a[3] += (longSample)*dp++ * (longSample)*cp++;
    }   

    while (cnt--)
    {
        a[0] += (longSample)*dp++ * (longSample)*cp++; 
    }

    
    dp = data;
    cnt = last_idx;
    for (; cnt >= 4; cnt -= 4)
    {
        a[0] += (longSample)*dp++ * (longSample)*cp++;
        a[1] += (longSample)*dp++ * (longSample)*cp++;
        a[2] += (longSample)*dp++ * (longSample)*cp++;
        a[3] += (longSample)*dp++ * (longSample)*cp++;
    }

    while (cnt--)
    {
        a[1] += (longSample)*dp++ * (longSample)*cp++; 
    }

    return a[0] + a[1] + a[2] + a[3];
}

RegisterImplementation r1("convSplitU4SRLD", conv_split_unrolled4_sep_result, 4, true, true);

longSample conv_split_unrolled4_sep_result_no_long(sample* data, sample* coeffs, int len, int last_idx)
{      
    sample *dp = data;
    sample *cp = coeffs;
    longSample a[4] = {0.0, 0.0, 0.0, 0.0};
   
    dp = data+last_idx;
    int cnt = len - last_idx;
    for (; cnt >= 4; cnt -= 4)
    {
        a[0] += *dp++ * *cp++;
        a[1] += *dp++ * *cp++;
        a[2] += *dp++ * *cp++;
        a[3] += *dp++ * *cp++;
    }   

    while (cnt--)
    {
        a[0] += *dp++ * *cp++; 
    }

    
    dp = data;
    cnt = last_idx;
    for (; cnt >= 4; cnt -= 4)
    {
        a[0] += *dp++ * *cp++;
        a[1] += *dp++ * *cp++;
        a[2] += *dp++ * *cp++;
        a[3] += *dp++ * *cp++;
    }

    while (cnt--)
    {
        a[1] += *dp++ * *cp++; 
    }

    return a[0] + a[1] + a[2] + a[3];
}

RegisterImplementation r2("convSplitU4SRNLD", conv_split_unrolled4_sep_result_no_long, 4, true, false);

longSample conv_split_unrolled2_sep_result(sample* data, sample* coeffs, int len, int last_idx)
{      
    sample *dp = data;
    sample *cp = coeffs;
    longSample a[2] = {0.0, 0.0};
   
    dp = data+last_idx;
    int cnt = len - last_idx;
    for (; cnt >= 2; cnt -= 2)
    {
        a[0] += (longSample)*dp++ * (longSample)*cp++;
        a[1] += (longSample)*dp++ * (longSample)*cp++;
    }   

    if (cnt)
    {
        a[0] += (longSample)*dp++ * (longSample)*cp++; 
    }

    
    dp = data;
    cnt = last_idx;
    for (; cnt >= 2; cnt -= 2)
    {
        a[0] += (longSample)*dp++ * (longSample)*cp++;
        a[1] += (longSample)*dp++ * (longSample)*cp++;
    }

    if (cnt)
    {
        a[1] += (longSample)*dp++ * (longSample)*cp++; 
    }

    return a[0] + a[1];
}

RegisterImplementation r3("convSplitU2SRNLD", conv_split_unrolled2_sep_result, 2, true, true);


longSample conv_split_unrolled4_no_sep_result(sample* data, sample* coeffs, int len, int last_idx)
{      
    sample *dp = data;
    sample *cp = coeffs;
    longSample a = 0.0;
   
    dp = data+last_idx;
    int cnt = len - last_idx;
    for (; cnt >= 4; cnt -= 4)
    {
        a += (longSample)*dp++ * (longSample)*cp++;
        a += (longSample)*dp++ * (longSample)*cp++;
        a += (longSample)*dp++ * (longSample)*cp++;
        a += (longSample)*dp++ * (longSample)*cp++;
    }   

    while (cnt--)
    {
        a += (longSample)*dp++ * (longSample)*cp++; 
    }

    
    dp = data;
    cnt = last_idx;
    for (; cnt >= 4; cnt -= 4)
    {
        a += (longSample)*dp++ * (longSample)*cp++;
        a += (longSample)*dp++ * (longSample)*cp++;
        a += (longSample)*dp++ * (longSample)*cp++;
        a += (longSample)*dp++ * (longSample)*cp++;
    }

    while (cnt--)
    {
        a += (longSample)*dp++ * (longSample)*cp++; 
    }

    return a;
}

RegisterImplementation r4("convSplitU4SRNLD", conv_split_unrolled4_no_sep_result, 4, false, true);


longSample conv_split(sample* data, sample* coeffs, int len, int last_idx)
{      
    sample *dp = data;
    sample *cp = coeffs;
    longSample a = 0.0;
   
    dp = data+last_idx;
    int cnt = len - last_idx;
    for (; cnt >= 1; cnt -= 1)
    {
        a += (longSample)*dp++ * (longSample)*cp++;
    }   
 
    dp = data;
    cnt = last_idx;
    for (; cnt >= 1; cnt -= 1)
    {
        a += (longSample)*dp++ * (longSample)*cp++;   
    }

    return a;
}

RegisterImplementation r5("convSplit", conv_split, 1, false, true);


longSample conv_dummy_FPU(sample* data, sample* coeffs, int len, int last_idx)
{
    longSample a = 0;
    sample* dp = data;
    sample* cp = coeffs;

    int data_idx = last_idx;

    for (int i = 0; i < len; ++i)
    {
        a += (longSample)dp[data_idx] * (longSample)cp[i];
		if (data_idx >= len)
			data_idx = 0;
    }

    return a;
}

RegisterImplementation r6("conv_dummy_FPU", conv_dummy_FPU, 1, false, true);

longSample conv_dummy(sample* data, sample* coeffs, int len, int last_idx)
{
	longSample a = 0;
    sample* dp = data;
    sample* cp = coeffs;

    int data_idx = last_idx;

    for (int i = 0; i < len; ++i)
    {
        a += dp[data_idx] * cp[i];
		if (data_idx >= len)
			data_idx = 0;
    }

    return a;
}

RegisterImplementation r7("conv_dummy", conv_dummy, 1, false, false);
