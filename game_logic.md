The game:
  A simple hangman game

What should it do:
  - It should retrieve from our dictionary a random word with 5 to 12 letters;

  - After that, it should allow the player to try to guess what that word is, letter 
    by letter;

  - If the the player's guess is correct, it should display the word, showing (only)
    the correct(ly guessed) letters, and their position in the word;

  - If the guess is incorrect, it should decrement the amount of tries the player
    has left, and display the incorrect letter separately, in a list of incorrect guesses;
  
  - The information processed/generated throughout the game should be stored 
    inside the game object;

  - The class should be serializable, and have methods to serialize the objects (and 
    store all its information inside a string), as well as to unserialize the string and
    recreate the object, in its previous state.

How to do it:

1 - Retrieve random words from the dictionary
  1 - Store each line of the dictionary file in an array (of words)
  2 - Select from the previous array, the words that match the criteria
  3 - From the previous list, select a random word

2 - Display the word to player
  1 - Create a string with a placeholder (eg: a "_") for every letter of the word_to_be_guessed
  2 - Check which letters of the word have been guessed
  3 - Place every correct guess made so far in the string, in its respective position,
    replacing its placeholder
  4 - Display the string to the player

3 - Display the incorrect guesses to the player
  1 - Store every incorrect guess made by the player in a list
  2 - Display the list before each round

4 - Allow the player to make a guess
  1 - Prompt the player for a guess
  2 - Take (and validate), and store the player's guess

5 - Process the player's guess
  1 - Check if the player's guess is correct, and add it to the appropriate
    list (of correct or incorrect guesses)

6 - Store the game's information
  1 - Store all of the game's information generated so far (correct and 
    incorrect guesses, word_to_be_guessed, etc) for later serialization

7 - Allow serialization
  1 - Serialize the object
    1 - Make a hash containing all of our objects data
    2 - Turn that hash into a serialized string (initially thinking of using
      MessagePack, but that might change later)
    3 - Store that serialized string in a file
  
  2 - Unserialize the string and reconstruct the object
   1 - Look for the file which contains the serialized string that represents
    the game
  2 - Convert the data in that file to a Ruby hash
  3 - Make a new object, passing the data in the previous hash to the constructor  
