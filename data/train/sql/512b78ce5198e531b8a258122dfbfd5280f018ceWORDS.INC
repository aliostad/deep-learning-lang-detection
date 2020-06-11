//words_numbers Include Library.
get_word: 
  string text 
  string dec_points
  number digits 
  indicator decimals 
  indicator tens
  indicator hundreds 
  indicator thousands
  indicator t_thousands
  indicator h_thousands
  indicator millions
  indicator t_millions
  indicator h_millions
  indicator jump
   
  indicate tens false
  indicate hundreds false
  indicate thousands false
  indicate t_thousands false
  indicate h_thousands false
  indicate millions false
  indicate t_millions false
  indicate h_millions false
  indicate decimals false 
  indicate jump false
   
  right numb to digits 5 
  if digits gt 0.99 indicate tens true 
  right numb to digits 6  
  if digits gt 99.99 indicate hundreds true 
  right numb to digits 7 
  if digits gt 999.99 indicate thousands true 
  right numb to digits 8 
  if digits gt 9999.99 indicate t_thousands true 
  right numb to digits 9 
  if digits gt 99999.99 indicate h_thousands true 
  right numb to digits 10 
  if digits gt 999999.99 indicate millions true 
  right numb to digits 11 
  if digits gt 9999999.99 indicate t_millions true 
  right numb to digits 12  
  if digits gt 99999999.99 indicate h_millions true 
  move "" to word_1
  move 0 to digits 

h_m:
  [h_millions] begin
     mid numb to digits 1 1 
     gosub a_word
     append word_1 text " HUNDRED"
     if NOT [t_millions] begin  
        if NOT [millions] append word_1 " MILLION" 
     end 
   end 

t_m:
  [t_millions] begin
     mid numb to digits 2 2 
     gosub a_word
     [h_millions] append word_1 " AND" 
     trim word_1 to word_1 
     append word_1 " " text " MILLION"
     goto h_t // to avoid getting millions twice!
  end

m:
  [millions] begin
     mid numb to digits 1 3  
     gosub a_word
     [h_millions] append word_1 " AND" 
     append word_1 " " text " MILLION" 
  end

h_t:
  [h_thousands] begin
     mid numb to digits 1 4 
     gosub a_word
     append word_1 " " text " HUNDRED"  
     if NOT [t_thousands] begin  
       if NOT [thousands] begin
         append word_1 " THOUSAND" 
         goto h 
       end 
     end 
   end


t_t:
  [t_thousands] begin
     mid numb to digits 2 5 
     gosub a_word
     [h_millions] indicate jump true
     [millions]   indicate jump true
     [t_millions] indicate jump true
     [h_thousands] indicate jump true
     [jump] begin
       append word_1 " AND"
     end 
       append word_1 " " text " THOUSAND"
     goto h
   end
t:
   [thousands] begin   
     mid numb to digits 1 6 
     gosub a_word
     [h_millions] indicate jump true
     [t_millions] indicate jump true
     [millions]   indicate jump true
     [h_thousands] indicate jump true
     [jump] begin
       append word_1 " AND" 
     end
     append word_1 " " text " THOUSAND" 
   end 

h:
  [hundreds] begin
     mid numb to digits 1 7 
     gosub a_word
     append word_1 " " text " HUNDRED" 
   end

ts:
  [tens] begin
     mid numb to digits 2 8 
     gosub a_word
     [h_millions] indicate jump true
     [t_millions] indicate jump true
     [millions]   indicate jump true
     [h_thousands] indicate jump true
     [t_thousands] indicate jump true
     [thousands]  indicate jump true
     [hundreds]   indicate jump true
     [jump] append word_1 " AND"
     append word_1 " " text
   end 

dec: 
   begin
     mid numb to digits 2 11 
     if digits gt 0 begin
       append word_1 " POINT "
       mid numb to dec_points 2 11
       append word_1 dec_points
     end
     else begin 
       append word_1 " ONLY"  
     end
   end 
return 

a_word:
move "" to text
if digits gt 90 goto a_word_91
if digits gt 80 goto a_word_81
if digits gt 70 goto a_word_71
if digits gt 60 goto a_word_61
if digits gt 50 goto a_word_51
if digits gt 40 goto a_word_41
if digits gt 30 goto a_word_31
if digits gt 20 goto a_word_21
if digits gt 10 goto a_word_11

IF DIGITS EQ 1 MOVE "ONE" TO TEXT
IF DIGITS EQ 2 MOVE "TWO" TO TEXT
IF DIGITS EQ 3 MOVE "THREE" TO TEXT
IF DIGITS EQ 4 MOVE "FOUR" TO TEXT
IF DIGITS EQ 5 MOVE "FIVE" TO TEXT
IF DIGITS EQ 6 MOVE "SIX" TO TEXT
IF DIGITS EQ 7 MOVE "SEVEN" TO TEXT
IF DIGITS EQ 8 MOVE "EIGHT" TO TEXT
IF DIGITS EQ 9 MOVE "NINE" TO TEXT
IF DIGITS EQ 10 MOVE "TEN" TO TEXT
IF TEXT NE "" RETURN
A_WORD_11:
IF DIGITS EQ 11 MOVE "ELEVEN" TO TEXT
IF DIGITS EQ 12 MOVE "TWELVE" TO TEXT
IF DIGITS EQ 13 MOVE "THIRTEEN" TO TEXT
IF DIGITS EQ 14 MOVE "FOURTEEN" TO TEXT
IF DIGITS EQ 15 MOVE "FIFTEEN" TO TEXT
IF DIGITS EQ 16 MOVE "SIXTEEN" TO TEXT
IF DIGITS EQ 17 MOVE "SEVENTEEN" TO TEXT
IF DIGITS EQ 18 MOVE "EIGHTEEN" TO TEXT
IF DIGITS EQ 19 MOVE "NINETEEN" TO TEXT
IF DIGITS EQ 20 MOVE "TWENTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_21:
IF DIGITS EQ 21 MOVE "TWENTY ONE" TO TEXT
IF DIGITS EQ 22 MOVE "TWENTY TWO" TO TEXT
IF DIGITS EQ 23 MOVE "TWENTY THREE" TO TEXT
IF DIGITS EQ 24 MOVE "TWENTY FOUR" TO TEXT
IF DIGITS EQ 25 MOVE "TWENTY FIVE" TO TEXT
IF DIGITS EQ 26 MOVE "TWENTY SIX" TO TEXT
IF DIGITS EQ 27 MOVE "TWENTY SEVEN" TO TEXT
IF DIGITS EQ 28 MOVE "TWENTY EIGHT" TO TEXT
IF DIGITS EQ 29 MOVE "TWENTY NINE" TO TEXT
IF DIGITS EQ 30 MOVE "THIRTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_31:
IF DIGITS EQ 31 MOVE "THIRTY ONE" TO TEXT
IF DIGITS EQ 32 MOVE "THIRTY TWO" TO TEXT
IF DIGITS EQ 33 MOVE "THIRTY THREE" TO TEXT
IF DIGITS EQ 34 MOVE "THIRTY FOUR" TO TEXT
IF DIGITS EQ 35 MOVE "THIRTY FIVE" TO TEXT
IF DIGITS EQ 36 MOVE "THIRTY SIX" TO TEXT
IF DIGITS EQ 37 MOVE "THIRTY SEVEN" TO TEXT
IF DIGITS EQ 38 MOVE "THIRTY EIGHT" TO TEXT
IF DIGITS EQ 39 MOVE "THIRTY NINE" TO TEXT
IF DIGITS EQ 40 MOVE "FORTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_41:
IF DIGITS EQ 41 MOVE "FORTY ONE" TO TEXT
IF DIGITS EQ 42 MOVE "FORTY TWO" TO TEXT
IF DIGITS EQ 43 MOVE "FORTY THREE" TO TEXT
IF DIGITS EQ 44 MOVE "FORTY FOUR" TO TEXT
IF DIGITS EQ 45 MOVE "FORTY FIVE" TO TEXT
IF DIGITS EQ 46 MOVE "FORTY SIX" TO TEXT
IF DIGITS EQ 47 MOVE "FORTY SEVEN" TO TEXT
IF DIGITS EQ 48 MOVE "FORTY EIGHT" TO TEXT
IF DIGITS EQ 49 MOVE "FORTY NINE" TO TEXT
IF DIGITS EQ 50 MOVE "FIFTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_51:
IF DIGITS EQ 51 MOVE "FIFTY ONE" TO TEXT
IF DIGITS EQ 52 MOVE "FIFTY TWO" TO TEXT
IF DIGITS EQ 53 MOVE "FIFTY THREE" TO TEXT
IF DIGITS EQ 54 MOVE "FIFTY FOUR" TO TEXT
IF DIGITS EQ 55 MOVE "FIFTY FIVE" TO TEXT
IF DIGITS EQ 56 MOVE "FIFTY SIX" TO TEXT
IF DIGITS EQ 57 MOVE "FIFTY SEVEN" TO TEXT
IF DIGITS EQ 58 MOVE "FIFTY EIGHT" TO TEXT
IF DIGITS EQ 59 MOVE "FIFTY NINE" TO TEXT
IF DIGITS EQ 60 MOVE "SIXTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_61:
IF DIGITS EQ 61 MOVE "SIXTY ONE" TO TEXT
IF DIGITS EQ 62 MOVE "SIXTY TWO" TO TEXT
IF DIGITS EQ 63 MOVE "SIXTY THREE" TO TEXT
IF DIGITS EQ 64 MOVE "SIXTY FOUR" TO TEXT
IF DIGITS EQ 65 MOVE "SIXTY FIVE" TO TEXT
IF DIGITS EQ 66 MOVE "SIXTY SIX" TO TEXT
IF DIGITS EQ 67 MOVE "SIXTY SEVEN" TO TEXT
IF DIGITS EQ 68 MOVE "SIXTY EIGHT" TO TEXT
IF DIGITS EQ 69 MOVE "SIXTY NINE" TO TEXT
IF DIGITS EQ 70 MOVE "SEVENTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_71:
IF DIGITS EQ 71 MOVE "SEVENTY ONE" TO TEXT
IF DIGITS EQ 72 MOVE "SEVENTY TWO" TO TEXT
IF DIGITS EQ 73 MOVE "SEVENTY THREE" TO TEXT
IF DIGITS EQ 74 MOVE "SEVENTY FOUR" TO TEXT
IF DIGITS EQ 75 MOVE "SEVENTY FIVE" TO TEXT
IF DIGITS EQ 76 MOVE "SEVENTY SIX" TO TEXT
IF DIGITS EQ 77 MOVE "SEVENTY SEVEN" TO TEXT
IF DIGITS EQ 78 MOVE "SEVENTY EIGHT" TO TEXT
IF DIGITS EQ 79 MOVE "SEVENTY NINE" TO TEXT
IF DIGITS EQ 80 MOVE "EIGHTY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_81:
IF DIGITS EQ 81 MOVE "EIGHTY ONE" TO TEXT
IF DIGITS EQ 82 MOVE "EIGHTY TWO" TO TEXT
IF DIGITS EQ 83 MOVE "EIGHTY THREE" TO TEXT
IF DIGITS EQ 84 MOVE "EIGHTY FOUR" TO TEXT
IF DIGITS EQ 85 MOVE "EIGHTY FIVE" TO TEXT
IF DIGITS EQ 86 MOVE "EIGHTY SIX" TO TEXT
IF DIGITS EQ 87 MOVE "EIGHTY SEVEN" TO TEXT
IF DIGITS EQ 88 MOVE "EIGHTY EIGHT" TO TEXT
IF DIGITS EQ 89 MOVE "EIGHTY NINE" TO TEXT
IF DIGITS EQ 90 MOVE "NINETY" TO TEXT
IF TEXT NE "" RETURN
A_WORD_91:
IF DIGITS EQ 91 MOVE "NINETY ONE" TO TEXT
IF DIGITS EQ 92 MOVE "NINETY TWO" TO TEXT
IF DIGITS EQ 93 MOVE "NINETY THREE" TO TEXT
IF DIGITS EQ 94 MOVE "NINETY FOUR" TO TEXT
IF DIGITS EQ 95 MOVE "NINETY FIVE" TO TEXT
IF DIGITS EQ 96 MOVE "NINETY SIX" TO TEXT
IF DIGITS EQ 97 MOVE "NINETY SEVEN" TO TEXT
IF DIGITS EQ 98 MOVE "NINETY EIGHT" TO TEXT
IF DIGITS EQ 99 MOVE "NINETY NINE" TO TEXT
RETURN
 



































