# Stack Code (SC0)

0. CONST 3	# Building a new array: Load the size (3) onto the stack.
1. NEWARRAY	# Create the array in memory.
2. STORE 0	# Pop the stack and store into a
3. LOAD 0	# Load a onto the stack.
4. CONST 0	# Put 0 on the stack.
5. CONST 1	# Put 1 on the stack.
6. ASTORE	# Pop the stack and store into the array in memory.
7. LOAD 0	# Load a onto the stack.
8. CONST 1	# Put 1 on the stack.
9. CONST 2	# Put 2 on the stack.
10. NEG
11. ASTORE	# Pop the stack and store into the array in memory.
12. LOAD 0	# Load a onto the stack.
13. CONST 2	# Put 2 on the stack.
14. CONST 3	# Put 3 on the stack.
15. CONST 4	# Put 4 on the stack.
16. MUL		# MULval1 and val2
17. ASTORE	# Pop the stack and store into the array in memory.
18. LOAD 0	# Load a onto the stack.
19. CONST 0	# Put 0 on the stack.
20. ALOAD	# Load a onto the stack.
21. LOAD 0	# Load a onto the stack.
22. CONST 1	# Put 1 on the stack.
23. ALOAD	# Load a onto the stack.
24. ADD		# ADDval1 and val2
25. LOAD 0	# Load a onto the stack.
26. CONST 2	# Put 2 on the stack.
27. ALOAD	# Load a onto the stack.
28. ADD		# ADDval1 and val2
29. STORE 1	# Pop the stack and store into sum
30. LOAD 1	# Load sum onto the stack.
31. PRINT	# Pop the stack and print it.
