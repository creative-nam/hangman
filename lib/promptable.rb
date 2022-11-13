# frozen_string_literal: true

# This module contains the methods related to prompting the user for a certain
# information, as well as to validate the input received after as a response.
module Promptable
  def prompt_for_state
    option = 0

    until state_valid?(option)
      puts state_prompt_msg
      option = gets.chomp.to_i

      puts invalid_state_msg unless state_valid?(option)
    end

    option
  end

  def prompt_for_id
    id = 0

    until game_exists?(id)
      puts id_prompt_msg
      id = gets.chomp.to_i

      puts invalid_id_msg unless game_exists?(id)
    end

    id
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

  def state_valid?(state)
    state.between?(1, 2)
  end

  def guess_valid?(guess)
    guess&.match?(/[[:alpha:]]/)
  end
end
