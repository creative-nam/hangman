# frozen_string_literal: true

require_relative 'messageable'
require_relative 'promptable'
require_relative 'serializable'
require_relative 'word_generator'

# This is the class that will be responsible for the core operations of our game,
# such as interacting with player, taking their input (a guess), decide if it's
# correct or not, and what to in each case.
class Game
  include Messageable
  include Promptable
  include Serializable
  include WordGenerator

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
    state = map_state(prompt_for_state)

    return unless state == :resume_previous_game

    saved_games? ? update_state! : (puts no_saved_games_msg)
  end

  def update_state!
    id = prompt_for_id
    game_paused = File.read(generate_file_name(id))

    unserialize!(game_paused)
  end

  def play
    guess = ''

    until guesses_left.zero? || player_won?
      clear_terminal
      puts "Word: #{censor_word_to_be_guessed}"

      decorate_line
      guess = prompt_for_guess

      (save_game or break) if player_wants_to_save_game?(guess)

      puts_with_padding guess_result_msg(correct?(guess))

      process_guess(guess)
    end

    end_game unless player_wants_to_save_game?(guess)
  end

  private

  def censor_word_to_be_guessed
    word = ''
    placeholder = '_'

    word_to_be_guessed.each_char do |letter|
      word += guessed?(letter) ? letter : placeholder
    end

    word
  end

  def end_game
    decorate_line
    puts_with_padding word_revelation_msg

    puts_with_decoration game_over_msg
    puts_with_decoration game_result_msg(player_won?), (player_won? ? '-'.green : '-'.red)
  end

  def save_game
    super

    puts saved_game_msg(serialization_id)
  end

  def guessed?(letter)
    correct_guesses.include?(letter)
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

  def player_won?
    (word_to_be_guessed.chars - correct_guesses).empty?
  end

  def player_wants_to_save_game?(guess)
    guess == @@save_game_keyword
  end

  def map_state(state)
    state == 1 ? :new_game : :resume_previous_game
  end
end

game = Game.new

game.determine_state
game.play

