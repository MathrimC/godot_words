extends Control

@export var letters_button: Button
@export var letters_label: Label
@export var input: LineEdit
@export var response_label: Label
@export var words: WordsNode
@export var labels_container: Container

var answers: Dictionary

func on_letters_button_pressed():
	for label in answers.values():
		label.queue_free()
	answers.clear()
	letters_label.text = words.get_letters(8)
	response_label.text = ""
	var all_answers = words.get_answers()
	for answer in all_answers:
		# In this example, we're only accepting ansers that are 4 letters or more
		if answer.length() > 3:
			create_answer_label(answer)

func on_input_submit(guess: String):
	if answers.has(guess):
		var label = answers[guess]
		label.text = guess
		response_label.text = "%s is correct!" % guess
	else:
		response_label.text = "%s is wrong!" % guess

func on_reveal_pressed():
	response_label.text = ""
	for answer in answers:
		answers[answer].text = answer

func create_answer_label(answer: String):
	var label = Label.new()
	for i in answer.length():
		label.text += "_ "
	labels_container.add_child(label)
	answers[answer] = label
	
