class Chisel

	attr_reader :output, :input


	def initialize
		@input
		@output = []
	end

	def parse(string)
		@output = string.split("\n\n")
		sorter
		@output = @output.map do |sentence|
			emphasis(sentence)
		end

		# 
		# @output = @output.map do |sentence|
		# 	strong(sentence)
		# end

		puts @output.join("\n")
	end

	def sorter
		@output = @output.map do |sentence|
			if sentence[0] == "#"
				if sentence[0..3] == "####" && sentence[5] != "#"
					sentence.gsub("####", "<H4>").insert(-1, "</H4>")
				elsif sentence[0..2] =="###" && sentence[3] != "#"
					sentence.gsub("###", "<H3>").insert(-1, "</H3>")
				elsif sentence[0..1]=="##" && sentence[2] != "#"
					sentence.gsub("##", "<H2>").insert(-1, "</H2>")
				elsif sentence[0] == "#" && sentence[1] != "#"
					sentence.gsub("#", "<H1>").insert(-1, "</H1>")
				end
			else
				sentence.prepend("<p>").insert(-1, "</p>")
			end
		end
		@output.join

	end

	def emphasis(text)
    tagged = false

    starred = text.chars.map do |i|
      if tagged == false && i == '*'
        tagged = true
        i.sub(i, "<em>")
      elsif tagged == true && i == '*'
        tagged = false
        i.sub(i, "</em>")
      else
        i
      end
    end
    starred.join
  end

	def strong(text)
		strongged = text.map do |i|
				i.sub!("<em></em>", "<strong>")
		end
		strongged
	end

end



document = '# My Life in Desserts

## Chapter 1: The Beginning

"You just *have* to try the cheesecake," he said. "Ever since it appeared in
**Food & Wine** this place has been packed every night."'

test = Chisel.new
test.parse(document)




# 	def initialize
# 		@input
# 		@output = ""
# 		@chunk = []
# 		@chunk_sorted
# 	end
#
# 	def parse(input)
# 		@input	= input
# 		split_into_chunks(@input)
# 	end
#
# 	# 1. Split into individual sentences / chunks
# 	def split_into_chunks(string)
# 		 @chunk = string.split("\n\n")    #Input is split into chunks
#   #    @chunk.each do |chunk|
# 	# 		if chunk[0] == "#"
# 	# 			@chunk.push(hashes(chunk))
# 	# 		else
# 	# 			@chunk.push(paragraphs(chunk))
# 	# 		end
# 	end
#
# 	#2. If the chunk starts with #, put header symbols. If not, paragraph
#
# 	def sort(input)
# 		@chunk_sorted = input.map do |chunk|
# 			if chunk[0] == "#"
# 				if chunk[0..3] == "####" && chunk[5] != "#"
# 					chunk.gsub("####", "<H4>").insert(-1, "</H4>")
# 				elsif chunk[0..2] =="###" && chunk[3] != "#"
# 					chunk.gsub("###", "<H3>").insert(-1, "</H3>")
# 				elsif chunk[0..1]=="##" && chunk[2] != "#"
# 					chunk.gsub("##", "<H2>").insert(-1, "</H2>")
# 				elsif chunk[0] == "#" && chunk[1] != "#"
# 					chunk.gsub("#", "<H1>").insert(-1, "</H1>")
# 				end
# 			else
# 				chunk.prepend("<p>").insert(-1, "</p>")
# 			end
# 		end
# 	end
#
# 	def paragraphs(string)    ## Edited this to call hashes in else
# 		string.prepend("<p>")
# 		string << "</p>"
# 	end
#
# 	def tags(chunk)
# 		split_into_chunks(chunk)
# 		paragraphs(chunk)
# 	end
#
# 	def hashes(text)
# 		if text[0..3] == "####" && text[5] != "#"
# 			text.gsub("####", "<H4>").insert(-1, "</H4>")
# 		elsif text[0..2] =="###" && text[3] != "#"
# 			text.gsub("###", "<H3>").insert(-1, "</H3>")
# 		elsif text[0..1]=="##" && text[2] != "#"
# 			text.gsub("##", "<H2>").insert(-1, "</H2>")
# 		elsif text[0] == "#" && text[1] != "#"
# 			text.gsub("#", "<H1>").insert(-1, "</H1>")
# 		else
# 			paragraphs(text)
# 		end
# 	end
#
# end
