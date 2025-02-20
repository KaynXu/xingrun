extends Node2D
@onready var end_image: CanvasLayer = $EndImage
@onready var pads_dict = {}
@onready var pad_rects = []
@onready var lilypads: GridContainer = $UI/Lilypads
@onready var path = []
@onready var step: int
@onready var frog: AnimatedSprite2D = $UI/Frog
@onready var timer_label: Label = $UI/Control/TimerLabel
@onready var score_label: Label = $UI/Control/Label
@onready var texture_buttons = [
	$UI/HBoxContainer/TextureButton,
	$UI/HBoxContainer/TextureButton2,
	$UI/HBoxContainer/TextureButton3,
	$UI/HBoxContainer/TextureButton4
]

var preset_paths = {
	14: [
		# 路径1 - 之字形
		[
			Vector2(2,0), Vector2(3,1), Vector2(4,2), Vector2(3,3),
			Vector2(2,4), Vector2(1,5), Vector2(0,6), Vector2(1,6),
			Vector2(2,6), Vector2(3,6), Vector2(4,7), Vector2(3,8),
			Vector2(2,8), Vector2(1,8)
		],
		# 路径2 - S形
		[
			Vector2(4,0), Vector2(3,1), Vector2(2,2), Vector2(1,3),
			Vector2(0,4), Vector2(1,5), Vector2(2,5), Vector2(3,5),
			Vector2(4,6), Vector2(3,7), Vector2(2,7), Vector2(1,8),
			Vector2(2,8), Vector2(3,8)
		],
		# 路径3 - 直线型
		[
			Vector2(1,0), Vector2(1,1), Vector2(1,2), Vector2(2,3),
			Vector2(2,4), Vector2(2,5), Vector2(3,5), Vector2(3,6),
			Vector2(4,6), Vector2(4,7), Vector2(4,8), Vector2(3,8),
			Vector2(2,8), Vector2(1,8)
		],
		# 路径4 - 蛇形
		[
			Vector2(0,0), Vector2(1,1), Vector2(2,1), Vector2(3,2),
			Vector2(4,2), Vector2(5,3), Vector2(4,4), Vector2(3,5),
			Vector2(2,6), Vector2(1,6), Vector2(0,7), Vector2(1,8),
			Vector2(2,8), Vector2(3,8)
		],
		# 路径5 - 对角线型
		[
			Vector2(5,0), Vector2(4,1), Vector2(3,2), Vector2(2,3),
			Vector2(1,4), Vector2(0,5), Vector2(1,5), Vector2(2,6),
			Vector2(3,6), Vector2(4,6), Vector2(5,7), Vector2(4,8),
			Vector2(3,8), Vector2(2,8)
		]
	],
	16: [
		# 路径1 - 双Z形
		[
			Vector2(0,0), Vector2(1,1), Vector2(2,1), Vector2(3,2),
			Vector2(4,2), Vector2(5,3), Vector2(4,4), Vector2(3,4),
			Vector2(2,5), Vector2(1,5), Vector2(0,6), Vector2(1,7),
			Vector2(2,7), Vector2(3,8), Vector2(4,8), Vector2(5,8)
		],
		# 路径2 - 螺旋形
		[
			Vector2(2,0), Vector2(3,0), Vector2(4,1), Vector2(5,2),
			Vector2(4,3), Vector2(3,3), Vector2(2,3), Vector2(1,4),
			Vector2(0,5), Vector2(1,6), Vector2(2,6), Vector2(3,6),
			Vector2(4,7), Vector2(3,8), Vector2(2,8), Vector2(1,8)
		],
		# 路径3 - 阶梯形
		[
			Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(2,1),
			Vector2(2,2), Vector2(3,2), Vector2(3,3), Vector2(4,3),
			Vector2(4,4), Vector2(5,4), Vector2(5,5), Vector2(4,6),
			Vector2(3,7), Vector2(2,8), Vector2(1,8), Vector2(0,8)
		],
		# 路径4 - 之字回环
		[
			Vector2(3,0), Vector2(2,1), Vector2(1,2), Vector2(0,3),
			Vector2(1,3), Vector2(2,3), Vector2(3,4), Vector2(4,4),
			Vector2(5,5), Vector2(4,6), Vector2(3,6), Vector2(2,6),
			Vector2(1,7), Vector2(2,8), Vector2(3,8), Vector2(4,8)
		],
		# 路径5 - M形
		[
			Vector2(0,0), Vector2(1,1), Vector2(2,2), Vector2(3,1),
			Vector2(4,0), Vector2(5,1), Vector2(4,2), Vector2(3,3),
			Vector2(2,4), Vector2(1,5), Vector2(0,6), Vector2(1,7),
			Vector2(2,8), Vector2(3,8), Vector2(4,8), Vector2(5,8)
		]
	],
	18: [
		# 路径1 - 大蛇形
		[
			Vector2(2,0), Vector2(3,0), Vector2(4,1), Vector2(5,1),
			Vector2(5,2), Vector2(4,3), Vector2(3,3), Vector2(2,4),
			Vector2(1,4), Vector2(0,5), Vector2(1,5), Vector2(2,5),
			Vector2(3,6), Vector2(4,6), Vector2(5,7), Vector2(4,8),
			Vector2(3,8), Vector2(2,8)
		],
		# 路径2 - 双回环
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,1), Vector2(3,1),
			Vector2(4,2), Vector2(3,3), Vector2(2,3), Vector2(1,3),
			Vector2(0,4), Vector2(1,5), Vector2(2,5), Vector2(3,5),
			Vector2(4,6), Vector2(3,7), Vector2(2,7), Vector2(1,8),
			Vector2(2,8), Vector2(3,8)
		],
		# 路径3 - 交错阶梯
		[
			Vector2(5,0), Vector2(4,1), Vector2(3,1), Vector2(2,2),
			Vector2(1,2), Vector2(0,3), Vector2(1,4), Vector2(2,4),
			Vector2(3,5), Vector2(4,5), Vector2(5,6), Vector2(4,6),
			Vector2(3,6), Vector2(2,7), Vector2(1,7), Vector2(0,8),
			Vector2(1,8), Vector2(2,8)
		],
		# 路径4 - W形
		[
			Vector2(0,0), Vector2(1,1), Vector2(2,2), Vector2(3,1),
			Vector2(4,2), Vector2(5,1), Vector2(4,3), Vector2(3,4),
			Vector2(2,3), Vector2(1,4), Vector2(0,5), Vector2(1,6),
			Vector2(2,6), Vector2(3,7), Vector2(4,7), Vector2(5,8),
			Vector2(4,8), Vector2(3,8)
		],
		# 路径5 - 复合形
		[
			Vector2(3,0), Vector2(4,0), Vector2(5,1), Vector2(4,2),
			Vector2(3,2), Vector2(2,3), Vector2(1,3), Vector2(0,4),
			Vector2(1,4), Vector2(2,4), Vector2(3,5), Vector2(4,5),
			Vector2(5,6), Vector2(4,7), Vector2(3,7), Vector2(2,8),
			Vector2(1,8), Vector2(0,8)
		]
	],
	20: [
		# 路径1 - 复杂蛇形
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,1), Vector2(3,1),
			Vector2(4,2), Vector2(5,2), Vector2(4,3), Vector2(3,3),
			Vector2(2,4), Vector2(1,4), Vector2(0,5), Vector2(1,5),
			Vector2(2,5), Vector2(3,6), Vector2(4,6), Vector2(5,7),
			Vector2(4,7), Vector2(3,8), Vector2(2,8), Vector2(1,8)
		],
		# 路径2 - 三重回环
		[
			Vector2(2,0), Vector2(3,0), Vector2(4,1), Vector2(3,2),
			Vector2(2,2), Vector2(1,3), Vector2(0,3), Vector2(1,4),
			Vector2(2,4), Vector2(3,4), Vector2(4,5), Vector2(3,5),
			Vector2(2,5), Vector2(1,6), Vector2(0,6), Vector2(1,7),
			Vector2(2,7), Vector2(3,7), Vector2(4,8), Vector2(5,8)
		],
		# 路径3 - 双S形
		[
			Vector2(5,0), Vector2(4,1), Vector2(3,1), Vector2(2,2),
			Vector2(1,2), Vector2(0,3), Vector2(1,3), Vector2(2,3),
			Vector2(3,4), Vector2(4,4), Vector2(5,5), Vector2(4,5),
			Vector2(3,5), Vector2(2,6), Vector2(1,6), Vector2(0,7),
			Vector2(1,7), Vector2(2,7), Vector2(3,8), Vector2(4,8)
		],
		# 路径4 - 交错之字
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,1),
			Vector2(2,2), Vector2(1,2), Vector2(0,3), Vector2(1,4),
			Vector2(2,4), Vector2(3,4), Vector2(4,5), Vector2(3,5),
			Vector2(2,6), Vector2(1,6), Vector2(0,7), Vector2(1,7),
			Vector2(2,7), Vector2(3,8), Vector2(4,8), Vector2(5,8)
		],
		# 路径5 - 螺旋阶梯
		[
			Vector2(3,0), Vector2(4,0), Vector2(5,1), Vector2(4,2),
			Vector2(3,2), Vector2(2,3), Vector2(1,3), Vector2(0,4),
			Vector2(1,4), Vector2(2,4), Vector2(3,5), Vector2(4,5),
			Vector2(5,6), Vector2(4,6), Vector2(3,6), Vector2(2,7),
			Vector2(1,7), Vector2(0,8), Vector2(1,8), Vector2(2,8)
		]
	],
	21: [
		# 路径1 - 复杂交错
		[
			Vector2(2,0), Vector2(3,0), Vector2(4,1), Vector2(5,1),
			Vector2(4,2), Vector2(3,2), Vector2(2,3), Vector2(1,3),
			Vector2(0,4), Vector2(1,4), Vector2(2,4), Vector2(3,5),
			Vector2(4,5), Vector2(5,6), Vector2(4,6), Vector2(3,6),
			Vector2(2,7), Vector2(1,7), Vector2(0,8), Vector2(1,8),
			Vector2(2,8)
		],
		# 路径2 - 大型Z形
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,1), Vector2(3,1),
			Vector2(4,2), Vector2(5,2), Vector2(4,3), Vector2(3,3),
			Vector2(2,4), Vector2(1,4), Vector2(0,5), Vector2(1,5),
			Vector2(2,5), Vector2(3,6), Vector2(4,6), Vector2(5,7),
			Vector2(4,7), Vector2(3,7), Vector2(2,8), Vector2(1,8),
			Vector2(0,8)
		],
		# 路径3 - 双回环加强版
		[
			Vector2(5,0), Vector2(4,1), Vector2(3,1), Vector2(2,2),
			Vector2(1,2), Vector2(0,3), Vector2(1,3), Vector2(2,3),
			Vector2(3,4), Vector2(4,4), Vector2(5,5), Vector2(4,5),
			Vector2(3,5), Vector2(2,6), Vector2(1,6), Vector2(0,7),
			Vector2(1,7), Vector2(2,7), Vector2(3,8), Vector2(4,8),
			Vector2(5,8)
		],
		# 路径4 - M形加强版
		[
			Vector2(0,0), Vector2(1,1), Vector2(2,1), Vector2(3,0),
			Vector2(4,1), Vector2(5,1), Vector2(4,2), Vector2(3,3),
			Vector2(2,3), Vector2(1,4), Vector2(0,4), Vector2(1,5),
			Vector2(2,5), Vector2(3,6), Vector2(4,6), Vector2(5,7),
			Vector2(4,7), Vector2(3,7), Vector2(2,8), Vector2(1,8),
			Vector2(0,8)
		],
		# 路径5 - 复合螺旋
		[
			Vector2(3,0), Vector2(4,0), Vector2(5,1), Vector2(4,2),
			Vector2(3,2), Vector2(2,3), Vector2(1,3), Vector2(0,4),
			Vector2(1,4), Vector2(2,4), Vector2(3,5), Vector2(4,5),
			Vector2(5,6), Vector2(4,6), Vector2(3,6), Vector2(2,7),
			Vector2(1,7), Vector2(0,8), Vector2(1,8), Vector2(2,8),
			Vector2(3,8)
		]
	],
	24: [
		# 路径1 - 终极蛇形
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,1), Vector2(3,1),
			Vector2(4,2), Vector2(5,2), Vector2(4,3), Vector2(3,3),
			Vector2(2,4), Vector2(1,4), Vector2(0,5), Vector2(1,5),
			Vector2(2,5), Vector2(3,6), Vector2(4,6), Vector2(5,6),
			Vector2(4,7), Vector2(3,7), Vector2(2,7), Vector2(1,8),
			Vector2(0,8), Vector2(1,8), Vector2(2,8), Vector2(3,8)
		],
		# 路径2 - 四重回环
		[
			Vector2(2,0), Vector2(3,0), Vector2(4,1), Vector2(5,1),
			Vector2(4,2), Vector2(3,2), Vector2(2,3), Vector2(1,3),
			Vector2(0,4), Vector2(1,4), Vector2(2,4), Vector2(3,5),
			Vector2(4,5), Vector2(5,5), Vector2(4,6), Vector2(3,6),
			Vector2(2,6), Vector2(1,7), Vector2(0,7), Vector2(1,8),
			Vector2(2,8), Vector2(3,8), Vector2(4,8), Vector2(5,8)
		],
		# 路径3 - 复杂交错阶梯
		[
			Vector2(5,0), Vector2(4,1), Vector2(3,1), Vector2(2,2),
			Vector2(1,2), Vector2(0,3), Vector2(1,3), Vector2(2,3),
			Vector2(3,4), Vector2(4,4), Vector2(5,4), Vector2(4,5),
			Vector2(3,5), Vector2(2,5), Vector2(1,6), Vector2(0,6),
			Vector2(1,6), Vector2(2,7), Vector2(3,7), Vector2(4,7),
			Vector2(5,8), Vector2(4,8), Vector2(3,8), Vector2(2,8)
		],
		# 路径4 - 双W形
		[
			Vector2(0,0), Vector2(1,1), Vector2(2,0), Vector2(3,1),
			Vector2(4,0), Vector2(5,1), Vector2(4,2), Vector2(3,3),
			Vector2(2,2), Vector2(1,3), Vector2(0,4), Vector2(1,5),
			Vector2(2,4), Vector2(3,5), Vector2(4,4), Vector2(5,5),
			Vector2(4,6), Vector2(3,7), Vector2(2,6), Vector2(1,7),
			Vector2(0,8), Vector2(1,8), Vector2(2,8), Vector2(3,8)
		],
		# 路径5 - 终极螺旋
		[
			Vector2(3,0), Vector2(4,0), Vector2(5,1), Vector2(4,2),
			Vector2(3,2), Vector2(2,3), Vector2(1,3), Vector2(0,4),
			Vector2(1,4), Vector2(2,4), Vector2(3,5), Vector2(4,5),
			Vector2(5,5), Vector2(4,6), Vector2(3,6), Vector2(2,6),
			Vector2(1,7), Vector2(0,7), Vector2(1,8), Vector2(2,8),
			Vector2(3,8), Vector2(4,8), Vector2(5,8), Vector2(4,8)
		]
	]
}

func path_generate(steps: int) -> Array:
	path.clear()
	if preset_paths.has(steps):
		var preset_list = preset_paths[steps]
		path = preset_list[randi() % preset_list.size()]
		return(path)
	else:
		var visited = {}
		# Generate a start
		var current_row = 0
		var current_col = randi() % 6
		var vertical_steps = 8
		var horizontal_steps = steps - vertical_steps
		path.append(Vector2(current_col, current_row))
		visited[Vector2(current_col, current_row)] = true
		for i in range(steps - 1):
			var possible_moves = []
			# To left
			if current_col - 1 >= 0 and horizontal_steps > 0:
				var left = Vector2(current_col - 1, current_row)
				if not visited.has(left):
					possible_moves.append(left)
			# To right
			if current_col + 1 < 6 and horizontal_steps > 0:
				var right = Vector2(current_col + 1, current_row)
				if not visited.has(right):
					possible_moves.append(right)
			# Go down
			if current_row + 1 < 9 and vertical_steps > 0:
				var down = Vector2(current_col, current_row + 1)
				if not visited.has(down):
					possible_moves.append(down)
			# Go left down
			if current_row + 1 < 9 and current_col - 1 >= 0 and vertical_steps > 0 and horizontal_steps > 0:
				var left_down = Vector2(current_col - 1, current_row + 1)
				if not visited.has(left_down):
					possible_moves.append(left_down)
			# Go right down
			if current_row + 1 < 9 and current_col + 1 < 6 and vertical_steps > 0 and horizontal_steps > 0:
				var right_down = Vector2(current_col + 1, current_row + 1)
				if not visited.has(right_down):
					possible_moves.append(right_down)
			if possible_moves.size() > 0:
				var next_move = possible_moves[randi() % possible_moves.size()]
				path.append(next_move)
				visited[next_move] = true
				if next_move.x != current_col:
					horizontal_steps -= 1
				elif next_move.y > current_row:
					vertical_steps -= 1
				current_col = next_move.x
				current_row = next_move.y
			else:
				pass
		if path[path.size() - 1].y != 8:
			path.clear()
			for point in pads_dict.keys():
				var pad = pads_dict[point]
				pad.texture = load("res://Sprite/LingBoWeiBu/Lilypad(Trans).png")
			return path_generate(steps)
		return path



func encode_pads_as_2d_vector():
	for i in range(pad_rects.size()):
		var col = i % 6
		var row = floor(i / 6)
		pads_dict[Vector2(col, row)] = pad_rects[i]

func update_pads_texture(path: Array, pads_dict: Dictionary) -> void:
	for point in pads_dict.keys():
		var pad = pads_dict[point]
		if point in path:
			pad.texture = load("res://Sprite/LingBoWeiBu/Lilypad.png")
		else:
			pad.texture = load("res://Sprite/LingBoWeiBu/Lilypad(Trans).png")

func game_initialize(pads_dict: Dictionary):
	end_image.initialize()
	score_label.text = "0"
	timer_label.start()
	for point in pads_dict.keys():
		var pad = pads_dict[point]
		pad.texture = load("res://Sprite/LingBoWeiBu/Lilypad(Trans).png")
	update_pads_texture(path, pads_dict)

func step_generate() -> int:
	var score = int(score_label.text)
	var available_steps = []
	if score < 2:
		available_steps = [12,14,16]
	elif score < 4:
		available_steps = [14,16,18]
	elif score <= 6:
		available_steps = [18,20,21,24]
	available_steps.shuffle()
	return available_steps[0]
	
	
func answer_correct():
	if $UI/Control/Label.text == '6':
		timer_label.finish()
		end_image.show_win()
	else:
		var update_score = int(score_label.text) + 1
		score_label.text = str(update_score)
		step = step_generate()
		path_generate(step)
		while path.size() != step:
			step = step_generate()
			path_generate(step)
		update_pads_texture(path, pads_dict)

func wrong_answer():
	print("You lose!")
	timer_label.finish()
	end_image.show_lose()

func _ready() -> void:
	step = step_generate()
	if path.size() == 0:
		pass
	else:
		update_pads_texture(path, pads_dict)
	for child in lilypads.get_children():
		pad_rects.append(child)
	game_initialize(pads_dict)
	encode_pads_as_2d_vector()
	path_generate(step)
	while path.size() != step:
		path_generate(step)
	update_pads_texture(path, pads_dict)

func _on_texture_button_pressed() -> void:
	if step % 2 == 0:
		answer_correct()
	else:
		wrong_answer()

func _on_texture_button_2_pressed() -> void:
	if step % 3 == 0:
		answer_correct()
	else:
		wrong_answer()
		
func _on_texture_button_3_pressed():
	if step % 4 == 0:
		answer_correct()
	else:
		wrong_answer()

func _on_texture_button_4_pressed():
	if step % 5 == 0:
		answer_correct()
	else:
		wrong_answer()

func restart():
	game_initialize(pads_dict)

func _process(delta: float) -> void:
	print(step)
