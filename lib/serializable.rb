# frozen_string_literal: true

require 'yaml'

# This module will provide us the methods necessary to serialize and unserialize
# our objects
module Serializable
  @@serializer = YAML

  @@serialization_id = 1
  @@saved_games_dir = 'saved_games'
  @@file_extension = 'YAML'

  def serialize
    game = {}

    instance_variables.map do |variable|
      game[variable] = instance_variable_get(variable)
    end

    @@serializer.dump(game)
  end

  def unserialize(serialized_game)
    game_previously_paused = Game.new
    game_vars = @@serializer.load(serialized_game)

    game_vars.each do |variable, value|
      game_previously_paused.instance_variable_set(variable, value)
    end

    game_previously_paused
  end

  def unserialize!(serialized_game)
    game_vars = @@serializer.load(serialized_game)

    game_vars.each do |variable, value|
      instance_variable_set(variable, value)
    end

    self
  end

  def save_game
    self.serialization_id = serialization_id || generate_serialization_id

    serialized_game = serialize

    store_in_file(serialized_game, serialization_id)
  end

  def store_in_file(serialized_game, file_id)
    # If there already exists a file with the same ID, increment the id
    file_name = generate_file_name(file_id)

    # Create a new (and open in write mode) a new file, and saved the
    # serialized game string to it
    File.open(file_name, 'w') { |file| file.puts serialized_game }
  end

  def generate_file_name(id = @@file_id, name = 'game', path = @@saved_games_dir,
                         extension = @@file_extension)
    "#{path}/#{name}_#{id}.#{extension}"
  end

  def file_id_valid?(file_id)
    file_id > 1 && !game_exists?(file_id)
  end

  # If the program has been previously run and files were saved before (and not
  # deleted after), the @@file_id will probably be uhmm... 'outdated'(???) (it
  # will have been used already), so we have to update it to catch up with the
  # id of the last_filed created
  def generate_serialization_id(previous_file_id = nil)
    id = (previous_file_id or @@serialization_id)
    file_name = generate_file_name(id)

    while File.file?(file_name)
      id += 1
      file_name = generate_file_name(id)
    end

    update_serialization_id(id)
  end

  def update_serialization_id(new_id)
    @@serialization_id = new_id
  end

  def game_exists?(file_id)
    File.file?(generate_file_name(file_id))
  end

  def saved_games?
    !Dir.empty?(@@saved_games_dir)
  end
end
