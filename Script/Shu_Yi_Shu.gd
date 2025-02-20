extends Node2D

var dice_images: Dictionary = {
	1: ["res://Sprite/Dices/1.1.png", "res://Sprite/Dices/1.2.png", "res://Sprite/Dices/1.3.png"],
	2: ["res://Sprite/Dices/2.1.png", "res://Sprite/Dices/2.2.png", "res://Sprite/Dices/2.3.png", "res://Sprite/Dices/2.4.png", "res://Sprite/Dices/2.5.png"],
	3: ["res://Sprite/Dices/3.1.png", "res://Sprite/Dices/3.2.png", "res://Sprite/Dices/3.3.png", "res://Sprite/Dices/3.4.png", "res://Sprite/Dices/3.5.png"],
	4: ["res://Sprite/Dices/4.1.png", "res://Sprite/Dices/4.2.png", "res://Sprite/Dices/4.3.png", "res://Sprite/Dices/4.4.png", "res://Sprite/Dices/4.5.png"],
	5: ["res://Sprite/Dices/5.1.png", "res://Sprite/Dices/5.2.png", "res://Sprite/Dices/5.3.png", "res://Sprite/Dices/5.4.png", "res://Sprite/Dices/5.5.png"],
	6: ["res://Sprite/Dices/6.1.png", "res://Sprite/Dices/6.2.png", "res://Sprite/Dices/6.3.png", "res://Sprite/Dices/6.4.png", "res://Sprite/Dices/6.5.png"],
	7: ["res://Sprite/Dices/7.1.png", "res://Sprite/Dices/7.2.png", "res://Sprite/Dices/7.3.png"],
	8: ["res://Sprite/Dices/8.1.png", "res://Sprite/Dices/8.2.png", "res://Sprite/Dices/8.3.png"],
	9: ["res://Sprite/Dices/9.png"],
}
@onready var i = 0
@onready var end_image: CanvasLayer = $EndImage
@onready var correct_numbers = []
@onready var number: Label = $UI/Number
@onready var round_counter: TextureRect = $UI/RoundCounter
@onready var timer_label: Label = $UI/TimerLabel
@onready var h_box_container_1: HBoxContainer = $UI/Control/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $UI/Control/HBoxContainer2
@onready var h_box_container_3: HBoxContainer = $UI/Control/HBoxContainer3

func _ready() -> void:
	game_start()
	for button in $UI/Control/HBoxContainer.get_children():
		button.pressed.connect(_on_pressed.bind(button))
	for button in $UI/Control/HBoxContainer2.get_children():
		button.pressed.connect(_on_pressed.bind(button))
	for button in $UI/Control/HBoxContainer3.get_children():
		button.pressed.connect(_on_pressed.bind(button))
		print(correct_numbers)

func game_start():
	i = 0
	round_counter.set_round(10)
	$EndImage/Lose.visible = false
	$EndImage/Win.visible = false
	timer_label.start()
	round_counter.current_round = 1
	number_generate()
	update_buttons()
	number.text = str(correct_numbers[i])
	$UI/Control/HBoxContainer3.visible = true
	$UI/Control/HBoxContainer2.visible = true

func number_generate():
	correct_numbers.clear()
	for i in range(10):
		correct_numbers.append(randi() % 9 + 1)

# 更新三排按钮的内容
func update_buttons():
	for i in range(3):
		var container
		if i == 0:
			container = h_box_container_1
		elif i == 1:
			container = h_box_container_2
		else:
			container = h_box_container_3
		update_buttons_in_container(container, round_counter.current_round + i - 1)
func update_buttons_in_container(container: HBoxContainer, index: int):
	if index >= correct_numbers.size():
		return
	var correct_number = correct_numbers[index]
	var correct_images = dice_images[correct_number]
	var correct_image = correct_images[randi() % correct_images.size()]
	var buttons = container.get_children()
	buttons.shuffle()
	buttons[0].get_node("Sprite2D").texture = load(correct_image)
	buttons[0].set_meta("is_correct", true)
	var wrong_numbers = dice_images.keys()
	wrong_numbers.erase(correct_number)
	wrong_numbers.shuffle()
	for i in range(1, buttons.size()):
		var wrong_images = dice_images[wrong_numbers[i - 1]]
		var wrong_image = wrong_images[randi() % wrong_images.size()]
		buttons[i].get_node("Sprite2D").texture = load(wrong_image)
		buttons[i].set_meta("is_correct", false)
	print(buttons[0].get_meta("is_correct"))

func answer_correct():
	i += 1
	# 检查是否是最后一轮
	if round_counter.current_round == 10 :
		timer_label.finish()
		end_image.show_win()

	else:
		number.text = str(correct_numbers[i])
		round_counter.update()
		replace_row(h_box_container_1, h_box_container_2)
		replace_row(h_box_container_2, h_box_container_3)
		print(round_counter.current_round)
		update_buttons_in_container(h_box_container_3,round_counter.current_round + 1)
	print($UI/Control/HBoxContainer/TextureButton.get_meta("is_correct"))

func replace_row(target_container: HBoxContainer, source_container: HBoxContainer):
	var source_buttons = source_container.get_children()
	var target_buttons = target_container.get_children()
	for i in range(source_buttons.size()):
		target_buttons[i].get_node("Sprite2D").texture = source_buttons[i].get_node("Sprite2D").texture
		target_buttons[i].set_meta("is_correct", source_buttons[i].get_meta("is_correct"))
		

func answer_incorrect():
	timer_label.finish()
	end_image.show_lose()
	i = 0
	
func _on_pressed(button):
	print(button.name, " 被按下了")
	if button.get_meta("is_correct") == true:
		answer_correct()
	else:
		answer_incorrect()

func _on_lose_button_pressed() -> void:
	game_start()


func _on_win_button_pressed() -> void:
	game_start()

func _process(delta: float) -> void:
	if round_counter.current_round == 9:
		$UI/Control/HBoxContainer3.visible = false
	if round_counter.current_round == 10:
		$UI/Control/HBoxContainer2.visible = false
