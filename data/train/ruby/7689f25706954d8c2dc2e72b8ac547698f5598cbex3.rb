def calculate_product_odd(array)
	first_flag = false
    product = 0
	array.each do |num| 
	    if num % 2 == 1
            if first_flag == false
            	 product = num
            	 first_flag = true
            else 
                 product *= num   
        	end
        end
    end
    first_flag ? product: nil
end


puts calculate_product_odd([1,2,3])     # returns 3, because 2 is even
puts calculate_product_odd([0,-1,-10])  # returns -1, because 0 and -10 are even
puts calculate_product_odd([1,2,3,4,5]) # returns 15, because 4 and 2 are even