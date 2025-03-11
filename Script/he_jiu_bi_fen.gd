extends Node2D

@onready var blocks = {
	3:$"Blocks/3",
	21:$"Blocks/21",
	7:$"Blocks/7",
	63:$"Blocks/63",
	24:$"Blocks/24",
	4:$"Blocks/4",
	6:$"Blocks/6",
	2:$"Blocks/2",
	44:$"Blocks/44",
	11:$"Blocks/11",
	12:$"Blocks/12",
	78:$"Blocks/78",
	13:$"Blocks/13",
	49:$"Blocks/49",
	8:$"Blocks/8",
	16:$"Blocks/16",
	80:$"Blocks/80",
	10:$"Blocks/10",
	5:$"Blocks/5",
	40:$"Blocks/40",
	62:$"Blocks/62",
	81:$"Blocks/81",
	9:$"Blocks/9",
	35:$"Blocks/35",
	56:$"Blocks/56",
	28:$"Blocks/28",
	31:$"Blocks/31",
	22:$"Blocks/22",
	14:$"Blocks/14",
	20:$"Blocks/20",
	39:$"Blocks/39",
	27:$"Blocks/27"
	}
	
func number_bubble():
	var number = blocks.keys()
	var random_number = number[randi_range(0 , number.size() - 1)]
	var random_blocks = blocks[random_number]
	# 删除这行，因为不需要为原始块连接信号
	# var random_blocks_button = random_blocks.get_node("Button")
	# random_blocks_button.pressed.connect(decompose.bind(random_blocks,random_number))
	var new_block = random_blocks.duplicate(Node.DUPLICATE_GROUPS)
	$UI/UI/GridContainer.add_child(new_block)
	# 只为新创建的副本连接信号
	var new_button = new_block.get_node("Button")
	var new_number = int(new_button.text)
	new_button.pressed.connect(decompose.bind(new_block,new_number))

func _process(delta: float) -> void:
	if is_all_prime():
		for child in $UI/UI/GridContainer.get_children():
			child.queue_free()
		number_bubble()
		number_bubble()

func _ready() -> void:
	for block in blocks.values():
		var button = block.get_node("Button")
		var number = int(button.text)
		button.pressed.connect(decompose.bind(block,number))
	number_bubble()
	number_bubble()
	
func decompose(block:ColorRect,number:int):
	var factor = []
	if not is_prime(number):
		factor = find_factor(number)
	if factor.size() >= 2:
		var block_1 = blocks[factor[0]].duplicate(Node.DUPLICATE_SIGNALS)
		var block_2 = blocks[factor[1]].duplicate(Node.DUPLICATE_SIGNALS)
		block.queue_free()
		$UI/UI/GridContainer.add_child(block_1)
		$UI/UI/GridContainer.add_child(block_2)
		
		# 只为新创建的方块连接信号
		var button_1 = block_1.get_node("Button")
		var button_2 = block_2.get_node("Button")
		button_1.pressed.connect(decompose.bind(block_1, factor[0]))
		button_2.pressed.connect(decompose.bind(block_2, factor[1]))

func find_factor(number:int):
	if not is_prime(number):
		var factor = []
		for i in range(2,number):
			if number % i == 0:
				factor.append(i)
		var factor_1 = factor.max()
		var factor_2 = number / factor_1
		var result = []
		result.append(factor_1)
		result.append(factor_2)
		return(result)

func is_prime(number: int) -> bool:
	if number <= 1:
		return false
	if number == 2:
		return true
	for i in range(2, number):
		if number % i == 0:
			return false
	return true
	
func is_all_prime() -> bool:
	var grid = $UI/UI/GridContainer
	for child in grid.get_children():
		var number = int(child.get_node("Button").text)
		if not is_prime(number):
			return false
	return true
		
