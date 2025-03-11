extends Node2D

@onready var numbers = {
	1: $"Numbers/1",
	2: $"Numbers/2", 
	3: $"Numbers/3",
	4: $"Numbers/4",
	5: $"Numbers/5",
	6: $"Numbers/6",
	7: $"Numbers/7",
	8: $"Numbers/8",
	9: $"Numbers/9"
}
@onready var grid_container = $UI/ColorRect2/GridContainer

const ROWS = 7
const COLS = 5
var grid = []
var selected = null
var current_round = 0
var total_rounds = 30
var steps = 3

func _ready():
	initialize_grid()
	setup_tiles()

func initialize_grid():
	grid = []
	for y in range(ROWS):
		var row = []
		for x in range(COLS):
			var valid_numbers = []
			# 获取所有可能的数字（1-9）
			for n in range(1, 10):
				valid_numbers.append(n)
			
			# 检查左边两个数字，如果相同则排除该数字
			if x >= 2:
				if row[x-1] == row[x-2]:
					valid_numbers.erase(row[x-1])
			
			# 检查上边两个数字，如果相同则排除该数字
			if y >= 2:
				if grid[y-1][x] == grid[y-2][x]:
					valid_numbers.erase(grid[y-1][x])
			
			# 检查L型模式
			if x > 0 and y > 0:
				# 检查左上角的L型
				if x > 1 and y > 0:
					if row[x-1] == row[x-2] and row[x-1] == grid[y-1][x-2]:
						valid_numbers.erase(row[x-1])
				# 检查右上角的L型
				if x > 0 and y > 1:
					if grid[y-1][x] == grid[y-2][x] and grid[y-2][x] == row[x-1]:
						valid_numbers.erase(grid[y-1][x])
			
			# 如果没有有效数字（极少数情况），重新添加所有数字
			if valid_numbers.size() == 0:
				for n in range(1, 10):
					valid_numbers.append(n)
			
			# 从有效数字中随机选择一个
			var value = valid_numbers[randi() % valid_numbers.size()]
			row.append(value)
		grid.append(row)

func setup_tiles():
	# 清除现有的图块
	for child in grid_container.get_children():
		child.queue_free()
	
	# 在GridContainer中添加新图块
	for y in range(ROWS):
		for x in range(COLS):
			var value = grid[y][x]
			var tile = numbers[value].duplicate()
			tile.custom_minimum_size = Vector2(96, 96)  # 设置固定大小
			tile.add_to_group("tiles")
			tile.get_node("Button").pressed.connect(_on_tile_pressed.bind(tile, x, y))
			grid_container.add_child(tile)

func _on_tile_pressed(tile, x, y):
	steps -= 1
	var current_value = grid[y][x]
	
	# 根据当前数字进行加减
	if current_value >= 1 and current_value <= 4:
		grid[y][x] = current_value + 1
	elif current_value >= 5 and current_value <= 9:
		grid[y][x] = current_value - 1
	
	# 更新视觉效果
	update_visual_tiles()
	
	# 检查并处理匹配，包括连锁反应
	check_and_process_matches()

func is_adjacent(x1, y1, x2, y2):
	return abs(x1 - x2) + abs(y1 - y2) == 1

func swap_tiles(x1, y1, x2, y2):
	var temp = grid[y1][x1]
	grid[y1][x1] = grid[y2][x2]
	grid[y2][x2] = temp

func check_matches():
	var matches = []
	var horizontal_matches = check_horizontal_matches()
	var vertical_matches = check_vertical_matches()
	var l_shape_matches = check_l_shape_matches()
	
	# 合并所有匹配结果
	matches.append_array(horizontal_matches)
	matches.append_array(vertical_matches)
	matches.append_array(l_shape_matches)
	
	# 移除重复的匹配位置
	var unique_matches = []
	for match_pos in matches:
		if not match_pos in unique_matches:
			unique_matches.append(match_pos)
	
	return unique_matches

func check_horizontal_matches():
	var matches = []
	for y in range(ROWS):
		var current_value = null
		var current_streak = []
		
		for x in range(COLS):
			if current_value == null:
				current_value = grid[y][x]
				current_streak = [[x,y]]
			elif grid[y][x] == current_value:
				current_streak.append([x,y])
			else:
				if current_streak.size() >= 3:
					matches.append_array(current_streak)
				current_value = grid[y][x]
				current_streak = [[x,y]]
		
		if current_streak.size() >= 3:
			matches.append_array(current_streak)
	return matches

func check_vertical_matches():
	var matches = []
	for x in range(COLS):
		var current_value = null
		var current_streak = []
		
		for y in range(ROWS):
			if current_value == null:
				current_value = grid[y][x]
				current_streak = [[x,y]]
			elif grid[y][x] == current_value:
				current_streak.append([x,y])
			else:
				if current_streak.size() >= 3:
					matches.append_array(current_streak)
				current_value = grid[y][x]
				current_streak = [[x,y]]
		
		if current_streak.size() >= 3:
			matches.append_array(current_streak)
	return matches

func check_l_shape_matches():
	var matches = []
	for y in range(ROWS):
		for x in range(COLS):
			var current = grid[y][x]
			
			# 检查所有可能的L型
			var l_shapes = [
				[[0,0], [1,0], [0,1]],  # 右下L型
				[[0,0], [-1,0], [0,1]], # 左下L型
				[[0,0], [1,0], [0,-1]], # 右上L型
				[[0,0], [-1,0], [0,-1]] # 左上L型
			]
			
			for l_shape in l_shapes:
				var valid = true
				var l_positions = []
				
				for pos in l_shape:
					var check_x = x + pos[0]
					var check_y = y + pos[1]
					
					if check_x < 0 or check_x >= COLS or check_y < 0 or check_y >= ROWS:
						valid = false
						break
					
					if grid[check_y][check_x] != current:
						valid = false
						break
					
					l_positions.append([check_x, check_y])
				
				if valid:
					matches.append_array(l_positions)
	
	return matches

func check_and_process_matches():
	var has_matches = true
	while has_matches:  # 持续检查直到没有新的匹配
		has_matches = process_matches()
		if has_matches:
			refill_grid()
			update_visual_tiles()  # 确保每次填充后更新显示
			current_round += 1
			steps = 3
			await get_tree().create_timer(0.3).timeout  # 添加短暂延迟使动画更流畅

func process_matches():
	var matches = check_matches()
	if matches.size() > 0:
		for pos in matches:
			var x = pos[0]
			var y = pos[1]
			grid[y][x] = 0  # 标记为空
		return true
	return false

func refill_grid():
	# Move tiles down
	for x in range(COLS):
		for y in range(ROWS - 1, -1, -1):
			if grid[y][x] == 0:
				for yy in range(y - 1, -1, -1):
					if grid[yy][x] != 0:
						grid[y][x] = grid[yy][x]
						grid[yy][x] = 0
						break
	
	# Fill empty spaces
	for x in range(COLS):
		for y in range(ROWS):
			if grid[y][x] == 0:
				grid[y][x] = randi() % 9 + 1
	
	# Update visual tiles
	update_visual_tiles()

func update_visual_tiles():
	# 清除现有的图块
	for child in grid_container.get_children():
		child.queue_free()
	setup_tiles()

func _process(delta: float) -> void:
	$UI/TextureProgressBar/Label.text = "%d/%d" % [current_round, total_rounds]
	$UI/Label2.text = str(steps)
	if steps == 0:
		$UI/EndImage.show_lose()
	$UI/TextureProgressBar.value = current_round

func on_losing_pressed():
	setup_tiles()
	steps = 3
	current_round = 0
	
func on_winning_pressed():
	setup_tiles()
	steps = 3
	current_round = 0


func _on_texture_button_pressed() -> void:
	pass # Replace with function body.
