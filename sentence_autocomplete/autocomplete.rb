module DataPreprocessing
	def self.clean_data_and_save_to_file(input_file)
		limit = 0
		begin
			input_fh = File.open(input_file,"r")
		rescue Exception => e
			puts e.message
			exit(0)
		end

		out_file_path = input_file.gsub(/(\.txt)/,"_out.txt")
		output_fh = File.open(out_file_path,"w")
		puts "processing input data and writing to file #{out_file_path} ..."	
		input_fh.each_line do |line|
			line = line.gsub(/(https?:\/\/t\.co\/\w+)/,"")
			line = line.gsub(/@\w+/," ")
			line = line.gsub(/[^a-zA-Z \']/," ")
			line = line.gsub(/\s+/," ")
			#line = line.force_encoding("utf-8")
			line.downcase!
			line = line.chomp.strip if line
			next if not line.split.size > 3
			output_fh.write("#{line}\n")
		end
		input_fh.close
		output_fh.close
		return out_file_path
	end
end

class MarkovChain
	include DataPreprocessing
	def initialize(input_file)
		out_file = DataPreprocessing::clean_data_and_save_to_file(input_file)
    		@words = Hash.new
    		begin
			data_fh = File.open(out_file,"r")
		rescue Exception => e
			puts e.message
			exit(0)
		end
		data_fh.each_line do |line|
			wordlist = line.split
    			wordlist.each_with_index do |word, index|
    				add(word, wordlist[index + 1], wordlist[index + 2]) if index <= wordlist.size - 3
   			end
		end
		data_fh.close
  	end

  	def add(word, word1, word2)
    		@words["#{word} #{word1}"] = Hash.new(0) if !@words["#{word} #{word1}"]
		@words["#{word} #{word1}"][word2] += 1
  	end
	
	def print_dict
		puts @words
	end	 
	  	
	def get_possible_word(bigram)
    		return "" if !@words[bigram]
    		followers = @words[bigram]
    		sum = followers.inject(0) {|sum,kv| sum += kv[1]}
    		random = rand(sum)+1
    		partial_sum = 0
    		next_word = followers.find do |word, count|
    			partial_sum += count
			partial_sum >= random
    		end.first
    		next_word
  	end
end

if __FILE__ == $0
	puts "enter the input data file path"
	in_file = gets.chomp
	markov_obj = MarkovChain.new(in_file)
	#markov_obj.print_dict
	str = nil
	while (1)
		puts "Type a partial string to autocomplete and press ENTER. Blank ENTER to EXIT"
		str = gets.chomp
		break if str == ""
		str_break = str.split
		wrd1 = str_break[-2]
		wrd2 = str_break[-1]
		search_string = "#{wrd1} #{wrd2}"
		word1 = markov_obj.get_possible_word(search_string)
		word2 = markov_obj.get_possible_word("#{wrd2} #{word1}") if word1
		output_string = str + " #{word1} #{word2}"
		puts output_string
	end
end
