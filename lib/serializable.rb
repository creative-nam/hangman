# frozen string literal: true
require 'json'

# This module will provide us the methods necessary to serialize and unserialize
# our objects
module Serializable
  @@serializer = JSON

  def serialize
    game = {}

    instance_variables.map do |variable|
      game[variable] = instance_variable_get(variable)
    end

    @@serializer.dump(game)
  end

  def unserialize(serialized_game)
    game_previously_paused = Game.new()
    game_vars = @@serializer.load(serialized_game)

    game_vars.each do |variable, value|
      game_previously_paused.instance_variable_set(variable, value)
    end

    game_previously_paused
  end

  def unserialize!(serialized_game)
    game_previously_paused = Game.new()
    game_vars = @@serializer.load(serialized_game)

    game_vars.each do |variable, value|
      self.instance_variable_set(variable, value)
    end

    self
  end
end