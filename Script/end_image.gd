extends CanvasLayer


func show_win():
	$Win.visible = true

func show_lose():
	$Lose.visible = true

func initialize():
	$Win.visible = false
	$Lose.visible = false

func _on_lose_button_pressed() -> void:
	$Lose.visible = false

func _on_win_button_pressed() -> void:
	$Win.visible = false
