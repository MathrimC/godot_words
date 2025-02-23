class_name WordsNode
extends Node

const words_path := "res://woordenlijst.txt"

var words: Array[String]

func _ready() -> void:
	_load_words()

## Returns a new set of letters to use as an assignment for finding words
func get_letters(amount_of_letters: int) -> String:
	var options: Array[String]
	for word: String in words:
		if word.length() == amount_of_letters:
			options.append(word)
	var word = options[randi_range(0, options.size())]
	var letters: String = ""
	while word.length() > 0:
		var position := randi_range(0, word.length())
		letters += word.substr(position,1)
		word = word.erase(position,1)
	return letters

## Checks if all letters of the word appear in letters, and checks if the word exists in Dutch
func check_word(word: String, letters: String) -> bool:
	word = word.to_lower()
	letters = letters.to_lower()
	for letter in word:
		var position := letters.find(letter)
		if position < 0:
			return false
		else:
			letters = letters.erase(position,1)
	return words.has(word)

func _load_words() -> void:
	var file := FileAccess.open(words_path, FileAccess.ModeFlags.READ)
	var regex = RegEx.new()
	regex.compile("[1234567890.]")
	while file.get_position() < file.get_length():
		var word := file.get_line()
		var result := regex.search(word)
		if result != null:
			continue
		if word.length() > 1:
			words.append(word.to_lower())
