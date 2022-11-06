def retrieve_words
  dict_file_name = 'google-10000-english-no-swears.txt'
  dict_file = File.open(dict_file_name, 'r')
  words = []

  # I chose to use #readline instead of #readlines because (the former is better
  # in terms of performance)[http://ruby.bastardsbook.com/chapters/io/#:~:text=The%20readline%20method%20seems,of%20each%20line%20either.]
  until dict_file.eof?
    words << dict_file.readline.chomp
  end

  words
end

def filter_words(dictionary = retrieve_words)
  dictionary.select { |word| word.length.between?(5, 12) }
end

def create_new_dict_file(filtered_words = filter_words)
  file_name = 'dictionary.txt'
  new_dict_file = File.open(file_name, 'w')

  filtered_words.each do |word|
    new_dict_file.puts word
  end
end

puts create_new_dict_file