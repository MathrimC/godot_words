class_name WordsNode
extends Node

const nl_wordlist_path := "res://wordlists/nl_wordlist.txt"
const en_wordlist_path := ["res://wordlists/en_wordlist_part1.txt", "res://wordlists/en_wordlist_part1.txt"]

enum Language { NL, EN }

@export var language: Language

var words: Array[String]
var letters: String
var longest_answer: String
var submitted_answers: Array[String]

func _ready() -> void:
	_load_words()

## Returns a new set of letters to use as an assignment for finding words
func get_letters(amount_of_letters: int) -> String:
	submitted_answers.clear()
	var options: Array[String]
	for word: String in words:
		if word.length() == amount_of_letters:
			options.append(word)
	var word = options[randi_range(0, options.size())]
	longest_answer = word
	word = word.to_lower()
	letters = ""
	while word.length() > 0:
		var position := randi_range(0, word.length())
		letters += word.substr(position,1)
		word = word.erase(position,1)
	return letters

## Checks if all letters of the word appear in letters, and checks if the word exists in Dutch
func check_word(word: String) -> bool:
	word = word.to_lower()
	if submitted_answers.has(word):
		return false
	var letters_copy := letters
	for letter in word:
		var position := letters_copy.find(letter)
		if position < 0:
			return false
		else:
			letters_copy = letters_copy.erase(position,1)
	if words.has(word):
		submitted_answers.append(word)
		return true
	else:
		return false

func get_answers() -> Array[String]:
	var answers: Array[String] = []
	_get_answers("", letters, answers)
	return answers

func _get_answers(word: String, remaining_letters: String, answers: Array[String]) -> void:
	# print("checking word %s" % word)
	var index := 0
	for letter in remaining_letters:
		var new_word := word + letter
		var new_letters := remaining_letters.erase(index,1)
		var lookup := words[words.bsearch(new_word)]
		if !answers.has(new_word) && lookup == new_word:
			answers.append(new_word)
		if lookup.begins_with(new_word):
			_get_answers(new_word, new_letters, answers)
		index += 1

## Returns the correct word using all the letters
func get_longest_answer() -> String:
	return longest_answer

func _load_words() -> void:
	match language:
		Language.NL:
			_load_nl_words()
		Language.EN:
			_load_en_words()

func _load_nl_words() -> void:
	var file := FileAccess.open(nl_wordlist_path, FileAccess.ModeFlags.READ)
	var regex = RegEx.new()
	regex.compile("[0-9A-Z.-]")
	while file.get_position() < file.get_length():
		var word := file.get_line()
		var result := regex.search(word)
		if result != null:
			continue
		if word.length() > 1:
			words.append(word.to_lower())

func _load_en_words() -> void:
	for path in en_wordlist_path:
		var file := FileAccess.open(path, FileAccess.ModeFlags.READ)
		while file.get_position() < file.get_length():
			var word := file.get_line()
			if word.length() > 1:
				words.append(word.to_lower())
	words.sort()
