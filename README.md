#NLP_CODE

This repository contains a single directory named sentence_autocomplete which is an assignment submission and is purely for academic purposes.
Code description:
   The code file contains a class named "MarkovChain" which contains all the essential methods for creating markov chain using trigrams from the data loaded from a output file which is inturn generated using an original input file containing raw tweets.
   
   Method wise description:
      Class MarkovChain
         Method : initialize(input_file)
           Takes in a name of the file containing raw tweets and calls a method named "clean_data_and_save_to_file" which
           is in a module named DataPreprocessing in the same code file. This method "clean_data_and_save_to_file"                  removes unwanted material like special characters except apostrophe and urls from the tweets and writes back 
           the processed tweets to an output file. The initialize method then loads this file and read it line by line to
           produce trigrams from the line and calls the "add" function to add the trigrams to the trigram hash(@word).
         
         Method : add(word, word1, word2)
           Takes in three words and add the first two words as key in the dictionary(hash) and the third word as a hash 
           this key with value as the frequency of the occurence of this trigram.

         Method : get_possible_word(bigram)
           This method takes in two word combination and look up to the dictionary we created in "add" method and finds 
           all the keys under the main bigram. Then it calculates the weight of all the keys under this bigram and return
           the key with highest probability or frequency of occurence.
           Note that this method returns only one word.
         
         Method : print_dict
           This method simply prints out the trigram dictionary @word.
           

USAGE:
   Make an object of the class named "MarkovChain" and pass the input raw data text file.
     markov_obj = MarkovChain.new(<in_file>)
	 Pass last two words of an incomplete sentence to the method named "get_possible_word"	
		 str = "American sniper is directed by"
		 str_list = str.chomp.strip.split
		 wrd1 = str_list[-2]
		 wrd2 = str_list[-1]
		 search_string = "#{wrd1} #{wrd2}"
		 next_word = markov_obj.get_possible_word(search_string)
		 
	 To get the second possible word just pass the next_word generated before and the last word of the original incomplete sentence
	 to the "get_possible_method" again.
		
	
