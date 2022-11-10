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

  attr_accessor :word_to_be_guessed, :guesses_left, :incorrect_guesses, :correct_guesses

  def initialize(_word_to_guessed = nil, _incorrect_guesses = nil)
    self.word_to_be_guessed = generate_random_word
    self.guesses_left = @@max_amount_of_guesses

    self.incorrect_guesses = []
    self.correct_guesses = []
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

      puts guess_prompt_msg
      guess = gets.chomp[0]

      puts invalid_guess_msg unless guess_valid?(guess)
    end

    process_guess(guess)
  end

  def player_won?
    (word_to_be_guessed.chars - correct_guesses).empty?
  end

  def decorate_line
    30.times { print '-' }

    puts ''
  end

  private

  def guessed?(letter)
    correct_guesses.include?(letter)
  end

  def guess_valid?(guess)
    guess && guess.match?(/[[:alpha:]]/)
  end

  def correct?(guess)
    word_to_be_guessed.include?(guess)
  end

  def process_guess(guess)
    if correct?(guess)
      correct_guesses << guess
    else
      incorrect_guesses << guess

      decrement_guesses_left
    end
  end

  def decrement_guesses_left
    self.guesses_left -= 1
  end
end

game = Game.new
puts "Word to be guessed: #{game.word_to_be_guessed}"

until game.guesses_left.zero? || game.player_won?
  puts "Word: #{game.display_word}"

  game.decorate_line
  game.prompt_for_guess
end

puts "Word to be guesses: #{game.word_to_be_guessed.chars}"
puts "Letters guessed: #{game.correct_guesses}"
puts "Won? #{game.player_won?}"
puts game.player_won? ? 'You won!' : 'You lost!'
