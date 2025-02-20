extends Node2D
@onready var current_number = 1

func assign_label(time):
	var numbers = []
	if time == 1:
		numbers = range(1,31)
	if time == 2:
		numbers = range(31,61)
	numbers.shuffle()
	var index = 0
	for button in $UI/UI/GridContainer.get_children():
		var label = button.get_node('Label')
		if label and index < numbers.size():
			label.text = str(numbers[index])
			index += 1
			
func _ready() -> void:
	assign_label(1)
	for button in $UI/UI/GridContainer.get_children():
		button.pressed.connect(on_pressed.bind(button))

func on_pressed(button):
	if str(current_number) == button.get_node("Label").text:
		var new_text = button.get_node("Label").text
		$UI/UI/TextureRect/Label.text += (" " + new_text)
		current_number += 1
		if button.get_node("Label").text == "1":
			$UI/UI/TextureRect/Label.text = "1"
			$UI/UI/TimerLabel.start()
		if button.get_node("Label").text == "30":
			assign_label(2)
		if button.get_node("Label").text == "60":
			current_number = 1
			$UI/UI/TimerLabel.finish()
			$EndImage/Win.visible = true
	else:
		current_number = 1
		$UI/UI/TimerLabel.finish()
		$EndImage/Lose.visible = true
