# hangman
This is a simple, console-based Hangman game made in Ruby; however, an extra 
feature the game offers, is the ability to, while you're playing the game,
'pause' it, and then come back later and resume it.

This feature is delivered with through serialization of the game.
When to a player requests to have a game saved mid-game, the game is
serialized, and all of its data (held in instance variables) is saved as string
in the that serialization format.
After that, that string is stored in a file (also matching the serialization 
format being used), with an ID.

When the user comes back and wants to resume the game, the file containing that
serialized game is retrieved, and its content read; that content is then
unserialized (and converted into a hash) and a new instance of the game class
is created, with the the content in that hash passed to it as instance variables -
thus, leaving the game with same data/state as before.   

#What i learned
During this project, i learned and/or practiced the following skils/concepts
- Serialazation (in Ruby)