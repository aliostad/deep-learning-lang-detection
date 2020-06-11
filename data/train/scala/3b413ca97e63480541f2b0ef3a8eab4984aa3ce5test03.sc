# Array length program

# int[] a = new int[4];
       0. CONST 4      
       1. NEWARRAY
       3. STORE 1      

# a[0] = 5;  
       4. LOAD 1       
       5. CONST 0      
       6. CONST 5      
       7. ASTORE       

# a[1] = 3;  
       8. LOAD 1       
       9. CONST 1      
      10. CONST 3      
      11. ASTORE       

# a[2] = 6;  
      12. LOAD 1       
      13. CONST 2      
      14. CONST 6
      16. ASTORE       

# a[3] = 0;
      17. LOAD 1       
      18. CONST 3      
      19. CONST 0      
      20. ASTORE       

# int i = 0;
      21. CONST 0      
      22. STORE 2      

# while (a[i] != 0) {
      23. LOAD 1       
      24. LOAD 2       
      25. ALOAD
      26. IFZ +6

#  i = i + 1;
      29. LOAD 2       
      30. CONST 1      
      31. ADD          
      32. STORE 2      
# }
      33. GOTO -8

# System.out.println(i);
      34. LOAD 2
      34. PRINT
