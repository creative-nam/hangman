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

  def guesses_left_msg(guesses_left)
    "You have #{guesses_left} guesses left."
  end

  def incorrect_guesses_msg(incorrect_guesses)
    "Incorrect guesses: #{incorrect_guesses.to_s.red}"
  end
end
