# frozen_string_literal: true

require 'yaml'

# This module will provide us the methods necessary to serialize and unserialize
# our objects
module Serializable
  @@serializer = YAML

  @@file_id = 1
  @@path = 'saved_games'
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
    serialized_game = serialize

    store_in_file(serialized_game)
  end

  def store_in_file(serialized_game)
    # If there already exists a file with the same ID, increment the id
    file_id = file_id_valid?(@@file_id) ? @@file_id : increment_file_id(@@file_id)
    file_name = name_file(file_id)

    update_file_id(file_id)

    # Create a new (and open in write mode) a new dile, and saved the 
    # serialized game string to it 
    File.open(file_name, 'w') { |file| file.puts serialized_game }
  end

  def name_file(id = @@file_id, name = 'game', path = @@path, extension =
    @@file_extension)
    "#{path}/#{name}_#{id}.#{extension}"
  end

  def file_id_valid?(file_id)
    !File.file?(name_file(file_id))
  end

  # If the program has been previously run and files were saved before (and not
  # deleted after), the @@file_id will probably be uhmm... 'outdated'(???) (it
  # will have been used already), so we have to update it to catch up with the
  # id of the last_filed created
  def increment_file_id(file_id)
    file_name = name_file(file_id)

    while File.file?(file_name)
      file_id += 1
      file_name = name_file(file_id)
    end

    update_file_id(file_id)
  end

  def update_file_id(new_id)
    @@file_id = new_id
  end
end
