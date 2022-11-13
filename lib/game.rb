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

  attr_accessor :word_to_be_guessed, :guesses_left, :correct_guesses,
                :incorrect_guesses, :saved_before, :serialization_id

  def initialize
    self.word_to_be_guessed = generate_random_word
    self.guesses_left = @@max_amount_of_guesses

    self.incorrect_guesses = []
    self.correct_guesses = []

    self.serialization_id = nil
  end

  def determine_state
    state = prompt_for_state

    return unless state == 2

    if saved_games?
      update_state!
    else
      puts no_saved_games_msg
    end
  end

  def prompt_for_state
    option = 0

    until valid_state?(option)
      puts state_prompt_msg
      option = gets.chomp.to_i

      puts invalid_state_msg unless valid_state?(option)
    end

    option
  end

  def update_state!
    id = prompt_for_id
    game_paused = File.read(generate_file_name(id))

    unserialize!(game_paused)
  end

  # if the player chooses to resume a previously saved game, he should be
  # prompted for the game's ID
  def prompt_for_id
    id = 0

    until game_exists?(id)
      puts id_prompt_msg
      id = gets.chomp.to_i

      puts invalid_id_msg unless game_exists?(id)
    end

    id
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

    puts saved_game_msg(serialization_id)
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

  def valid_state?(state)
    state.between?(1, 2)
  end
end

game = Game.new
puts "Word to be guessed: #{game.word_to_be_guessed}"

game.determine_state
game.play
puts ''
puts 'Serialized game:'
puts serialized_game = game.serialize

puts ''
puts 'Unserialized game:'
puts game.unserialize!(serialized_game)

puts 'Serialized again:'
puts game.unserialize!(serialized_game).serialize
