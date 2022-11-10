# frozen_string_literal: true

require 'colorize'

# This module will be used to store all the messages or warnings that need to be
# displayed throughout the game, such as: the amount of guesses the player has
# left, the message to prompt for a guess, etc.
module Messageable
  def guess_prompt_msg
    'Please enter a letter as your guess:'
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
end
