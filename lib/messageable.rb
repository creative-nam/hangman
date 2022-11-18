# frozen_string_literal: true

require 'colorize'

# This module will be used to store all the messages or warnings that need to be
# displayed throughout the game, such as: the amount of guesses the player has
# left, the message to prompt for a guess, etc.
module Messageable
  # State related messages
  def state_prompt_msg
    "
    Would you like to continue resume a saved game or start a new one?
    Press 1 to start new game
    Press 2 to resume previous game
    "
  end

  def invalid_state_msg
    'Invalid option! Please select a number between 1 and 2.'.red
  end

  def no_saved_games_msg
    'Invalid option. There are no saved games to resume.'.red
  end

  # ID related messages
  def id_prompt_msg
    "What is the ID of the game you'd like to resume?"
  end

  def invalid_id_msg
    'Invalid ID. There are no games saved with that ID.'.red
  end

  # Guess related messages
  def guess_prompt_msg
    'Please enter a letter as your guess, or type \'save\' to save the game:'
  end

  # Guess validation
  def invalid_guess_msg
    'Invalid Guess! Your GUESS MUST BE A LETTER. Please try again.'.red
  end

  # Guess warnings
  def guesses_left_msg(guesses_left)
    "You have #{guesses_left} guesses left."
  end

  def incorrect_guesses_msg(incorrect_guesses)
    "Incorrect guesses: #{incorrect_guesses.to_s.red}"
  end

  def guess_result_msg(guess_correct)
    guess_correct ? 'Nice guess!'.green : 'Incorrect!'.red
  end

  def incorrect_guess_msg
    'Incorrect!'.red
  end

  # End of game, and result announcement
  def game_over_msg
    'GAME OVER'
  end

  def game_result_msg(win)
    win ? 'You WON!'.green : 'You LOST!'.red
  end

  def word_revelation_msg
    "The word was: #{word_to_be_guessed}"
  end

  # Serialization and file saving messages
  def saved_game_msg(game_file_id)
    "
    Your game was saved with the ID: #{game_file_id}

    You can use that ID to find your game later. You should write it down.
    ".yellow
  end

  # Make our messages prettier
  def puts_with_padding(str, padding_position = :before)
    case padding_position
    when :after
      puts str + "\n"
    when :before
      puts "\n" + str
    when :both
      puts "\n" + str + "\n"
    end
  end

  def puts_with_decoration(str, decorator = '-', amount_of_times = 30)
    amount_of_times.times { print decorator }
    print str
    amount_of_times.times { print decorator }

    puts ''
  end

  def decorate_line
    30.times { print '*' }

    puts ''
  end

  def clear_terminal
    system('cls') || system('clear')
  end
end
