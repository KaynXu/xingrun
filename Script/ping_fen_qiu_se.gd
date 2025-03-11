extends Node2D
@onready var timer_label: Label = $UI/Control/TimerLabel
@onready var round_counter: TextureRect = $UI/Control/RoundCounter
@onready var item_button: TextureButton = $UI/Control/ItemButton
@onready var texture_rect: TextureRect = $UI/Control/ItemButton/TextureRect
@onready var grid_container: GridContainer = $UI/Control/GridContainer
@onready var select_item
@onready var end_image: CanvasLayer = $EndImage
@onready var double_clicker: Timer = $DoubleClicker
var game_running:bool
var click_count = 0
var baskest_count = {
	"baskect_3_1" : 0,
	"baskect_3_2" : 0,
	"baskect_3_3" : 0,
	"baskect_5_1" : 0,
	"baskect_5_2" : 0,
	"baskect_5_3" : 0,
	"baskect_5_4" : 0,
	"baskect_5_5" : 0
}
var item_array = ["res://Sprite/PingFenQiuSe/Cabbage.tres",
"res://Sprite/PingFenQiuSe/Carrot.tres",
"res://Sprite/PingFenQiuSe/Corn.tres",
"res://Sprite/PingFenQiuSe/Diamond.tres",
"res://Sprite/PingFenQiuSe/Ruby.tres",
"res://Sprite/PingFenQiuSe/Watermelon.tres"]
var level_1_3 = [9,12]
var level_1_5 = [10,15]
var level_2_3 = [15,18]
var level_2_5 = [20,25]
var level_3_3 = [21,24]
var level_3_5 = [30,35]
var multi_3 = [level_1_3,level_2_3,level_3_3]
var multi_5 = [level_1_5,level_2_5,level_3_5]
var multi = [multi_3,multi_5]

func image_generate(number:int) -> void:
	var this_item = item_array[randi() % item_array.size()]
	texture_rect.texture = load(this_item)
	for i in range(number):
		var new_node = item_button.duplicate()
		new_node.pressed.connect(
			func()  -> void:
				_on_item_button_pressed(new_node)
		)
		grid_container.add_child(new_node)

func initialize():
	end_image.initialize()
	for key in baskest_count.keys():
		baskest_count[key] = 0
	var baskets_3 = [$"UI/Control/3Buckets/baskect_3_1",
		$"UI/Control/3Buckets/baskect_3_2",
		$"UI/Control/3Buckets/baskect_3_3"
		]
	for basket in baskets_3:
		basket.get_node("Label").text = "0"
	var baskets_5 = [
		$"UI/Control/5Buckets/baskect_5_1",
		 $"UI/Control/5Buckets/baskect_5_2",
		 $"UI/Control/5Buckets/baskect_5_3",
		 $"UI/Control/5Buckets/baskect_5_4",
		 $"UI/Control/5Buckets/baskect_5_5"
	]
	for basket in baskets_5:
		basket.get_node("Label").text = "0"
	round_counter.clear()
	timer_label.clear()
	$EndImage/Win.visible = false
	$EndImage/Lose.visible = false

func choose(level:int , multi):
	var number
	#Level 1 choosing
	if level == 1 :
		var multi_choose = multi[randi() % 2]
		if multi_choose == multi[0]:
			var level_choose = multi_choose[0]
			number = level_choose[randi() % 2]
		if multi_choose == multi[1]:
			var level_choose = multi_choose[0]
			number = level_choose[randi() % 2]
	#Level 2 choosing
	if level == 2 :
		var multi_choose = multi[randi() % 2]
		if multi_choose == multi[0]:
			var level_choose = multi_choose[1]
			number = level_choose[randi() % 2]
		if multi_choose == multi[1]:
			var level_choose = multi_choose[1]
			number = level_choose[randi() % 2]
	#Level 3 choosing
	if level == 3 :
		var multi_choose = multi[randi() % 2]
		if multi_choose == multi[0]:
			var level_choose = multi_choose[2]
			number = level_choose[randi() % 2]
		if multi_choose == multi[1]:
			var level_choose = multi_choose[2]
			number = level_choose[randi() % 2]
	if number % 3 == 0:
		$"UI/Control/3Buckets".visible = true
		$"UI/Control/5Buckets".visible = false
	if number % 5 == 0:
		$"UI/Control/3Buckets".visible = false
		$"UI/Control/5Buckets".visible = true
	return number

func game_start():
	var number = choose(1, multi)
	image_generate(number)
	game_running = true
		
func answer_correct():
	for key in baskest_count.keys():
		baskest_count[key] = 0
	round_counter.update()
	var level
	if round_counter.current_round <= 2:
		level = 1
	else:
		if round_counter.current_round <= 4:
			level = 2
		else:
			if round_counter.current_round <= 6:
				level = 3
			else:
				if round_counter.current_round == 7:
					game_running = false
					timer_label.finish()
					$EndImage.get_child(1).visible = true
	var number = choose(level,multi)
	image_generate(number)
	if $"UI/Control/3Buckets".visible == true:
		var baskets_3 = [$"UI/Control/3Buckets/baskect_3_1",
		$"UI/Control/3Buckets/baskect_3_2",
		$"UI/Control/3Buckets/baskect_3_3"
		]
		for basket in baskets_3:
			basket.get_node("Label").text = "0"
	if $"UI/Control/5Buckets".visible == true:
		var baskets_5 = [
		$"UI/Control/5Buckets/baskect_5_1",
		 $"UI/Control/5Buckets/baskect_5_2",
		 $"UI/Control/5Buckets/baskect_5_3",
		 $"UI/Control/5Buckets/baskect_5_4",
		 $"UI/Control/5Buckets/baskect_5_5"
	]
		for basket in baskets_5:
			basket.get_node("Label").text = "0"

func wrong_answer():
	game_running = false
	timer_label.finish()
	$EndImage.get_child(0).visible = true
	

func _on_item_button_pressed(item) -> void:
	select_item = item
	if not timer_label.timer_running:
		timer_label.start()

func _on_basket_pressed(basket) -> void:
	click_count += 1
	if click_count == 1:
		if select_item != null:
			var basket_name = basket.name
			baskest_count[basket_name] += 1
			basket.get_node("Label").text = str(baskest_count[basket_name])
			select_item.queue_free()
			select_item = null
		double_clicker.start()
	else:
		if click_count == 2:
			click_count = 0
			double_clicker.timeout
			_on_basket_double_clicked(basket)
	

func _ready() -> void:
	round_counter.total_rounds = 6
	round_counter.current_round = 1
	var baskets_3 = [
		$"UI/Control/3Buckets/baskect_3_1",
		$"UI/Control/3Buckets/baskect_3_2",
		$"UI/Control/3Buckets/baskect_3_3"
	]
	for basket in baskets_3:
		basket.pressed.connect(func():
			_on_basket_pressed(basket))
	var baskets_5 = [
		$"UI/Control/5Buckets/baskect_5_1",
		 $"UI/Control/5Buckets/baskect_5_2",
		 $"UI/Control/5Buckets/baskect_5_3",
		 $"UI/Control/5Buckets/baskect_5_4",
		 $"UI/Control/5Buckets/baskect_5_5"
	]
	for basket in baskets_5:
		basket.pressed.connect(func():
			_on_basket_pressed(basket))
	game_start()
	
func _process(delta: float) -> void:
	if not game_running:
		return
	var value_of_basket_3 = [baskest_count["baskect_3_1"],baskest_count["baskect_3_2"],baskest_count["baskect_3_3"]]
	var value_of_basket_5 = [baskest_count["baskect_5_1"],baskest_count["baskect_5_2"],baskest_count["baskect_5_3"],baskest_count["baskect_5_4"],baskest_count["baskect_5_5"]]
	if grid_container.get_child_count() == 0:
		if value_of_basket_3.max() == value_of_basket_3.min() and value_of_basket_3.max() != 0:
			answer_correct()
		else:
			if value_of_basket_5.max() == value_of_basket_5.min() and value_of_basket_5.max() != 0:
				answer_correct()
			else:
				wrong_answer()
	




func _on_basket_double_clicked(basket):
	var basket_name = basket.name
	if baskest_count.has(basket_name) and baskest_count[basket_name] > 0:
		var items_to_return = baskest_count[basket_name]
		baskest_count[basket_name] = 0
		basket.get_node("Label").text = "0"
		for i in range(items_to_return):
			var new_item = item_button.duplicate()
			new_item.pressed.connect(
				func()  -> void:
					_on_item_button_pressed(new_item)
			)
			grid_container.add_child(new_item)
			
func _on_double_clicker_timeout() -> void:
	if click_count == 1:
		click_count = 0



func _on_lose_restart_button_pressed() -> void:
	initialize()
	game_start()


func _on_win_restart_button_pressed() -> void:
	initialize()
	game_start()
