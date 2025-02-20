extends Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,61):
		var button = Button.new()
		button.text = str(i)
		add_child(button)
