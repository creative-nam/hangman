require_relative 'word_generator'

# frozen string literal: true

# This is the class that will be responsible for the core operations of our game,
# such as interacting with player, taking their input (a guess), decide if it's
# correct or not, and what to in each case.
class Game
  include WordGenerator

  attr_accessor :word_to_be_guessed, :incorrect_guesses, :letters_guessed

  def initialize(word_to_guessed = nil, incorrect_guesses = nil)
    self.word_to_be_guessed = generate_random_word
    self.incorrect_guesses = word_to_be_guessed.length

    self.letters_guessed = []
  end

  def display_word
    word = ''
    placeholder = '_'

    word_to_be_guessed.each_char do |letter|
      word += guessed?(letter) ? letter : placeholder
    end

    word
  end

  def guessed?(letter)
    letters_guessed.include?(letter)
  end

  def guess_letters
    puts "Word to guess as str: #{word_to_be_guessed.chars}"
    letters_guessed << word_to_be_guessed.chars.sample
  end
end

game = Game.new()
puts "Word to be guessed: #{game.word_to_be_guessed}"

puts "String: #{game.display_word}"
2.times { game.guess_letters }
puts "String 2: #{game.display_word}"

