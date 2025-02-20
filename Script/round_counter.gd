extends TextureRect
var current_text = [] 
var current_round: int
var total_rounds: int

func _ready() -> void:
	pass # Replace with function body.

func set_round(set_total_rounds):
	total_rounds = set_total_rounds

func update():
	current_round += 1
	
func clear():
	current_round = 0

func _process(delta: float) -> void:
	current_text = "%d/%d" % [current_round, total_rounds]
	$Label.text = current_text
