extends Node2D

#Load dices images
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

@onready var texture_rects = [
	$"UI/control/GridContainer2/TextureRect",
	$"UI/control/GridContainer2/TextureRect2",
	$"UI/control/GridContainer2/TextureRect3", 
	$"UI/control/GridContainer2/TextureRect4",
	$"UI/control/GridContainer2/TextureRect5", 
	$"UI/control/GridContainer2/TextureRect6", 
	$"UI/control/GridContainer2/TextureRect7", 
	$"UI/control/GridContainer2/TextureRect8", 
	$"UI/control/GridContainer2/TextureRect9"
]

@onready var food_images = [
	$"Foods/Apple",
	$"Foods/Bacon",
	$"Foods/Shrimp",
	$"Foods/Strawbarry",
	$"Foods/Cake",
	$"Foods/DragonFruit",
	$"Foods/Honey",
	$"Foods/Eggs"
]

@onready var buttons = [
	$"UI/control/HBoxContainer/TextureButton",
	$"UI/control/HBoxContainer/TextureButton2",
	$"UI/control/HBoxContainer/TextureButton3"
]

@onready var timer_label = $"UI/control/TimerLabel"
@onready var round_counter = $"UI/control/RoundCounter"

var num = [1,2,3,4,5,6,7,8,9]
var correct_number: int
var current_round: int = 1
var total_rounds: int = 9
var counter : int

func _ready() -> void:
	# 确保Foods节点可见
	var foods_node = $Foods
	if foods_node:
		foods_node.visible = true
		
	# 验证food_images引用
	var all_foods_valid = true
	for food in food_images:
		if not is_instance_valid(food):
			push_error("Food node not found: " + str(food))
			all_foods_valid = false
			
	if all_foods_valid:
		if is_instance_valid(round_counter):
			round_counter.set_round(total_rounds)  # 设置总回合数
			round_counter.clear()  # 重置当前回合
		game_start()
	else:
		push_error("Some food nodes are missing, game cannot start")

func game_start():
	if is_instance_valid(timer_label):
		timer_label.start()
	else:
		push_error("Timer label is null!")
		return
		
	current_round = 1
	
	# 添加检查确保round_counter引用有效
	if is_instance_valid(round_counter):
		round_counter.current_round = current_round  # 直接设置当前回合
	else:
		push_error("Round counter is null!")
		
	# 添加检查确保texture_rects中的所有引用都是有效的
	var all_rects_valid = true
	for rect in texture_rects:
		if not is_instance_valid(rect):
			push_error("TextureRect reference is null!")
			all_rects_valid = false
			break
			
	if not all_rects_valid:
		return
		
	# 清除纹理
	for rect in texture_rects:
		rect.texture = null
		
	num.shuffle()
	choose_correct_number()
	generate_image()
			
func choose_correct_number():
	correct_number = num[current_round - 1]
	var correct_images = dice_images[correct_number]
	var correct_image = correct_images[randi() % correct_images.size()]
	buttons[0].get_node("Sprite2D").texture = load(correct_image)
	buttons[0].set_meta("is_correct",true)
	#Generate wrong number and images
	var wrong_numbers = dice_images.keys()
	wrong_numbers.erase(correct_number)
	wrong_numbers.shuffle
	for i in range(1,buttons.size()):
		var wrong_images = dice_images[wrong_numbers[i-1]]
		var wrong_image = wrong_images[randi() % wrong_images.size()]
		buttons[i].get_node("Sprite2D").texture = load(wrong_image)
		buttons[i].set_meta("is_correct",false)
	buttons.shuffle()

func generate_image():
	# 清除之前的显示
	for rect in texture_rects:
		if is_instance_valid(rect):
			rect.texture = null
			
	# 验证food_images数组
	var valid_foods = []
	for food in food_images:
		if is_instance_valid(food):
			if food.texture != null:
				valid_foods.append(food)
			else:
				push_error("Food node " + str(food.name) + " has no texture")
				
	if valid_foods.is_empty():
		push_error("No valid food images available")
		return
		
	var random_sprite_index = randi() % valid_foods.size()
	var sprite_node = valid_foods[random_sprite_index]
	
	if not is_instance_valid(sprite_node):
		push_error("Selected sprite node is invalid")
		return
		
	var sprite_texture = sprite_node.texture
	if sprite_texture is AtlasTexture:
		# 确保不会超出范围
		var display_count = mini(correct_number, texture_rects.size())
		for i in range(display_count):
			if is_instance_valid(texture_rects[i]):
				texture_rects[i].texture = sprite_texture
	else:
		push_error("Error: Texture is not an AtlasTexture for " + sprite_node.name)

func answer_correct():
	if current_round < total_rounds:
		current_round += 1
		if is_instance_valid(round_counter):
			round_counter.current_round = current_round  # 更新当前回合
		for rect in texture_rects:
			rect.texture = null
		choose_correct_number()
		generate_image()
	else:
		game_over()
func game_over():
	$UI/EndImage.show_win()
	timer_label.finish()

func answer_incorrect():
	$UI/EndImage.show_lose()
	timer_label.finish()

func _on_texture_button_pressed() -> void:
	var this_button = $"UI/control/HBoxContainer/TextureButton"
	if this_button.get_meta("is_correct") == true:
		answer_correct()
	else:
		answer_incorrect()

func _on_texture_button_2_pressed() -> void:
	var this_button = $"UI/control/HBoxContainer/TextureButton2"
	if this_button.get_meta("is_correct") == true:
		answer_correct()
	else:
		answer_incorrect()

func _on_texture_button_3_pressed() -> void:
	var this_button = $"UI/control/HBoxContainer/TextureButton3"
	if this_button.get_meta("is_correct") == true:
		answer_correct()
	else:
		answer_incorrect()

func _on_lose_button_pressed() -> void:
	game_start()

func _on_win_button_pressed() -> void:
	game_start()
