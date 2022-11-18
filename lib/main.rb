require_relative 'game'

play_again = false
first_round = true

def play_again_msg
  'Would you like to play again? [Y/N]'
end

def play_again_prompt
  puts play_again_msg
  answer = gets.chomp[0].upcase

  play_again = answer == 'Y' ? true : false
end

while first_round || play_again
  game = Game.new
  game.determine_state
  game.play

  play_again = play_again_prompt

  first_round = false
end