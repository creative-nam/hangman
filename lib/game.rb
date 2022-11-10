# frozen_string_literal: true

require_relative 'word_generator'
require_relative 'messageable'

# This is the class that will be responsible for the core operations of our game,
# such as interacting with player, taking their input (a guess), decide if it's
# correct or not, and what to in each case.
class Game
  include WordGenerator
  include Messageable

  @@max_amount_of_guesses = 12

  attr_accessor :word_to_be_guessed, :guesses_left, :incorrect_guesses, :letters_guessed

  def initialize(_word_to_guessed = nil, _incorrect_guesses = nil)
    self.word_to_be_guessed = generate_random_word
    self.guesses_left = @@max_amount_of_guesses

    self.incorrect_guesses = []
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

  def prompt_for_guess
    guess = ''

    until guess_valid?(guess)
      puts incorrect_guesses_msg(incorrect_guesses) unless incorrect_guesses.empty?

      puts guesses_left_msg(guesses_left)

      puts guess_prompt_msg(guesses_left)
      guess = gets.chomp
      guess = guess[0] if guess.length > 1

      puts invalid_guess_msg unless guess_valid?(guess)
    end
  end

  def decorate_line
    30.times { print '-' }

    puts ''
  end

  private

  def guessed?(letter)
    letters_guessed.include?(letter)
  end

  def guess_valid?(guess)
    guess && guess.match?(/[[:alpha:]]/)
  end
end

game = Game.new
puts "Word to be guessed: #{game.word_to_be_guessed}"

until game.guesses_left.zero? || game.letters_guessed.length == game.word_to_be_guessed.length
  puts "Word: #{game.display_word}"

  game.decorate_line
  game.prompt_for_guess
end
