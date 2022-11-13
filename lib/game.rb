# frozen_string_literal: true

require_relative 'word_generator'
require_relative 'messageable'
require_relative 'serializable'

# This is the class that will be responsible for the core operations of our game,
# such as interacting with player, taking their input (a guess), decide if it's
# correct or not, and what to in each case.
class Game
  include WordGenerator
  include Messageable
  include Serializable

  @@max_amount_of_guesses = 12
  @@save_game_keyword = 'save'

  attr_accessor :word_to_be_guessed, :guesses_left, :correct_guesses, :incorrect_guesses, :id

  def initialize
    self.word_to_be_guessed = generate_random_word
    self.guesses_left = @@max_amount_of_guesses

    self.incorrect_guesses = []
    self.correct_guesses = []
  end

  def play
    guess = ''

    until guesses_left.zero? || player_won?
      puts "Word: #{display_word}"

      decorate_line
      guess = prompt_for_guess

      if player_wants_to_save_game?(guess)
        save_game

        break
      end

      puts_with_padding guess_result_msg(correct?(guess)), :both
      process_guess(guess)
    end

    return if player_wants_to_save_game?(guess)

    puts "The word was: #{word_to_be_guessed}"

    puts_with_decoration game_over_msg
    puts_with_decoration game_result_msg(player_won?), (player_won? ? '-'.green : '-'.red)
  end

  def prompt_for_guess
    guess = ''

    until guess_valid?(guess)
      puts incorrect_guesses_msg(incorrect_guesses) unless incorrect_guesses.empty?
      puts_with_padding guesses_left_msg(guesses_left)

      puts_with_padding guess_prompt_msg

      guess = gets.chomp.downcase
      break if player_wants_to_save_game?(guess)

      guess = guess[0]

      puts_with_padding invalid_guess_msg unless guess_valid?(guess)
    end

    guess
  end

  def display_word
    word = ''
    placeholder = '_'

    word_to_be_guessed.each_char do |letter|
      word += guessed?(letter) ? letter : placeholder
    end

    word
  end

  def player_won?
    (word_to_be_guessed.chars - correct_guesses).empty?
  end

  def decorate_line
    30.times { print '*' }

    puts ''
  end

  private

  def save_game
    super

    puts saved_game_msg(@@file_id)
  end

  def guessed?(letter)
    correct_guesses.include?(letter)
  end

  def guess_valid?(guess)
    guess&.match?(/[[:alpha:]]/)
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

  def player_wants_to_save_game?(guess)
    guess == @@save_game_keyword
  end
end

game = Game.new
puts "Word to be guessed: #{game.word_to_be_guessed}"

game.play
puts ''
puts 'Serialized game:'
puts serialized_game = game.serialize

puts ''
puts 'Unserialized game:'
puts game.unserialize!(serialized_game)

puts 'Serialized again:'
puts game.unserialize!(serialized_game).serialize
