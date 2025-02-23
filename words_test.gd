extends Control

@export var letters_button: Button
@export var letters_label: Label
@export var input: LineEdit
@export var response_label: Label
@export var words: WordsNode

var letters: String
var answers: Array[String]

func on_letters_button_pressed():
	letters = words.get_letters(8)
	letters_label.text = letters

func on_input_submit(guess: String):
	if !answers.has(guess) && words.check_word(guess, letters):
		response_label.text = "%s is correct!" % guess
		answers.append(guess)
	else:
		response_label.text = "%s is wrong!" % guess
