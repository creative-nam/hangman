# frozen_string_literal: true

# This module will be used to generate (retrieve from the dictionary) random words
# which will be used as the word_to_guessed in the games
module WordGenerator
  private

  def generate_dictionary
    dict = []

    dict_file_name = 'dictionary.txt'
    dict_file = File.open(dict_file_name, 'r')

    # I chose to use #readline instead of #readlines because the former is better
    # in terms of performance
    # ie: [http://ruby.bastardsbook.com/chapters/io/#:~:text=The%20readline%20method%20seems,of%20each%20line%20either.]
    dict << dict_file.readline.chomp until dict_file.eof?
    dict_file.close

    dict
  end

  def generate_random_word(words_dict = generate_dictionary)
    words_dict.sample
  end
end
