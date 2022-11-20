# hangman
This is a simple, console-based Hangman made in Ruby; however, an extra 
feature the game offers is the ability to, while you're playing the game,
'pause' it, and then come back later and resume it.

This feature is delivered through serialization of the game.
When a player requests to have a game saved mid-game, the game object is 
attributed a 'serialization id' (to help identify the file later to retrieve),
and then serialized, and all of its data (held in instance variables) is saved 
into a string in a serialization format.

After that, that string is stored in a file (also matching the serialization 
format being used), with its ID on the name to identify it later.

When the user comes back and wants to resume the game, the file containing that
serialized game is retrieved, and its content read; that content is then
unserialized (and converted into a hash). A new Game object is then created,
with data inside the hash set as its instance variables - thus, leaving the 
game with same data/state as before.

# What i learned
During this project, i learned and/or practiced the following skils/concepts:

- File I/O
- Object Oriented Programming
- Serialazation

# Run the game
Using the following link you can run the game replit.com:
[![Run on Replit.com](https://replit.com/badge/github/creative-nam/hangman)](https://replit.com/new/github/creative-nam/hangman)