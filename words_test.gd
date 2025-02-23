extends Control

@export var letters_button: Button
@export var letters_label: Label
@export var input: LineEdit
@export var response_label: Label
@export var words: WordsNode

func on_letters_button_pressed():
	letters_label.text = words.get_letters(8)
	response_label.text = ""

func on_input_submit(guess: String):
	if words.check_word(guess):
		response_label.text = "%s is correct!" % guess
	else:
		response_label.text = "%s is wrong!" % guess

func on_reveal_pressed():
	response_label.text = "The full word was %s" % words.get_longest_answer()
