require 'pdf-reader-turtletext'
require 'writeexcel'

class Pdf2excel
	attr_accessor :file, :page, :full_content, :info_content, :mod_content, :y_precision, :col_position, :max


	def initialize(file,page)
		options = {:y_precision =>5}
		@file = PDF::Reader::Turtletext.new(file, options)
		@page = page
	 #returns the precision required in y positions helps align text correctly which may visually appear on the same line but is off by a few pixels
		@full_content = [] #original content with x and y coordinates
		@info_content = [] #content with only x info
		@mod_content = []
		@col_position = []
		@max = 1
		@is_col_set = false
	end

	def get_content #returns positional text content collection as a hash [y_position, [[x_position, content]]]
		@full_content = @file.content(@page) #a[6][0] = yposition, a[6][1] = text content, a[6][1].count = # of parts in the line of text
		create_info_content #can only do this after full content is pulled
		create_mod_content_structure
	end

	def get_precise_content #returns exact positional text content collection as a hash [y_position, [[x_position, content]]]
		@file.precise_content(@page) #does not merge lines based on y-position
	end


	def set_col_position
		@info_content.each do |col|
			# binding.pry
			if @max == col.count
				col.each do |x_pos|
					@col_position << x_pos.first 
				end
			end 
		end
		return avg_col_position
	end

	def transform_content
		@info_content.each_with_index do |line, row_index| 
			# binding.pry
			line.each do |info|
				# binding.pry
				col_index = return_position(info.first)
				info_str = info.last.strip! #takes away spaces to standardize patterns
				if contains_words?(info_str) #check in order to prevent incorrect sanitization of dates 
					# binding.pry
					# puts info_str
					@mod_content[row_index][col_index] = info_str  
				elsif contains_multiple_digits?(info_str) #true
					# binding.pry
					new_info_arr = sanitize(info_str) #returns_arry ["232", "3232", "(4242)"]
					separate_info(new_info_arr, row_index, col_index)
					# binding.pry
				else #all other cases (i.e single digits)
					# binding.pry
					@mod_content[row_index][col_index] = info_str
				end
			end
		end
		return @mod_content
	end

	def transfer_to_excel
		binding.pry
		wb_name = "PDF2EXCEL" + "#{Time.now.strftime("%m%d%Y %H%M")}" + ".xls"
		workbook = WriteExcel.new(wb_name)
		worksheet = workbook.add_worksheet
		index = 0
		@mod_content.each do |info|
			worksheet.write_row(index, 0, info)
			index += 1
		end
		workbook.close
	end



	private

	def create_info_content #private
		@full_content.each { |info| @info_content << info[1]} #puts only x_position info inside info_content
		set_max
	end

	def create_mod_content_structure
		@info_content.count.times {@mod_content << []} #create the correct number of lines
		@mod_content.each { |col| @max.times { col << ""}} #create the correct numbers of columns
	end

	def set_max
		@max = 1
		@info_content.each do |info|
			num_of_col = info.count
			@max = num_of_col if num_of_col > @max 
		end
		puts @max
	end


	def contains_multiple_digits?(info_str)
		regex = /\d+\)*\s\-*\.*\(*\w{0,1}\W{0,1}\s*\d+/
		(info_str =~ regex) == nil ? false : true #if it is nil then return false (does not contain multiple digits)
	end #private

	def contains_words?(info_str)
		regex = /[a-zA-Z]{2,}/ #words more than 2 letters - in order to prevent sanitization of dates.
		(info_str =~ regex) == nil ? false : true #if it is nil then return false (does not contain words) 
	end #private

	
	def sanitize(digit_str) #remove unnecessary characters and whitespaces
		regex = /[^\d\-\.\(\)\s]/
		digit_str.gsub!(regex, "")
		#regex for scanning 
		#regex = /(\(*\-*\d+\.*\d*\)*)/ #(separate_arrays ()*)
		regex_arr = /\(*\-*\d+\.*\d*\)*/ #(same array)
		digit_str.scan(regex_arr) # returns ["14.9342", "(3242)", "32324"]
	end #private

	def separate_info(info_arr, row, col) #placing it in the right column for @mod_content
		info_arr.each do |info|
			# binding.pry
			@mod_content[row][col] = info
			col += 1
		end
	end #private

	def return_position(num) #indicate index
		min = @col_position[-1] #assume the largest gap is the largest of the averages in @col_position
		min_store = Hash.new
		@col_position.each_with_index do |position, index|
			element = (position - num).abs
			if element < min
				min = element
				min_store[min] = index
			end			
		end
		return min_store[min]
	end

		#should be private need to figure out what happens if desired is 4 columns but only get 3
	def avg_col_position #sets @col_positions
		total_num = @col_position.count
		tracker = 0
		index = 0
		num_of_count = total_num/@max
		new_col = []
		while tracker < @max
			avg_col = []
			num_of_count.times do 
				item = @col_position[tracker]
				tracker += max
				avg_col << item
			end
			avg_col = avg_col.reduce(:+)/num_of_count
			new_col << avg_col.round(1)
			index += 1
			tracker = index
		end
		@col_position.clear
		@col_position = new_col
	end


end




# regex = /[^\d\-.]\s{1}/
# strip!
# gsub(/\s\s+/,"")


	# i = 1 #not zero because y_position is the first. 
	# if a.count < max  
	# end



	# def show_text
	# 	puts @file.info
	# end

	# def add_fields(fields)
	# 	if fields.kind_of?(Array)
	# 		fields.each {|field| @is_fields << field}
	# 	else
	# 		@is_fields << field
	# 	end 
	# end



	# def change_to_content
	# 	page_text = @file.page(@page).text
	# 	@content = remove_whitespace(page_text)
	# 	puts @content
	# end

	# def remove_whitespace(page_text)
	# 	binding.pry
	# 	page_text.squeeze(" ") #removes extraneous spacing
	# 	page_arr = page_text.split("\n") #creates array by splitting at the newline
	# 	page_arr.delete_if{|item| item == ""} #delete items with only "" to filter for only the necessary sheets
	# 	num_extract_arr = [] 
	# 	page_arr.each_index do |index|
	# 		binding.pry
	# 		item = page_arr[index]
	# 		binding.pry
	# 		item.gsub!(/^\s/,"") #take out space in the front
	# 		item.gsub!(/[,$.]/,"") if item.match(/\d+/)#subs "$" and ","" in numbers
	# 		binding.pry
	# 		num_extract = item.scan(/\d+/)
	# 		binding.pry
	# 		num_extract_arr << num_extract
	# 	end
	# end

	# "\\W|[0-9]"

		# a[7] = [503.1, [[81.9, "Royalties from Franchisees "], [326.1, "25,213,940 23,577,062 21,396,083 "]]]]
	# a[7][1] = [[81.9, "Royalties from Franchisees "], [326.1, "25,213,940 23,577,062 21,396,083 "]]]
	#  = 
	# col_position = [80.55, 337.5, 416.325, 495.90]

	# a[7][1][0] = [81.9, "Royalties from Franchisees "]
	# a[7][1][1] = [326.1, "25,213,940 23,577,062 21,396,083 "]


	# if a[7][1].count != @max # count of how many items and columns. 
	# 	start modification
	# end


	# #clear arrays and store it
	# #start modication 
	# @content = a[7][1] #store before clearing
	# a.clear 
	# @max.times {a[7][1] << []} #order the information correctly. 
	 
	
	# # tie_this_to sanitize
	# @content.each do |x|
	# 	index = return_position(x.first) #get index 
	# 	x.last.strip! #takes away spaces to distinguish whether or not there is more than one digit. 
	# 	if @content =~ (/^\(*\-*\d+\.*\d*\)*/)
	# 		new_el = sanitize(x.last)		
	# 		el_count = new_el.count
	# 	el_index = 1
	# 		if el_count > 1 
	# 			while index < max 
	# 				a[7][1][index] = el_count.fetch(el_index, '-')
	# 				index += 1
	# 				el_index += 1
	# 			end
	# 		else
	# 			a[7][1][index] = el_count.first
	# 		end
	# 	else #@content has only words or just digits #easiest case
	# 		a[7][1][index] = x.last
	# 	end
	# end

