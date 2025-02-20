extends Label

var start_time = 0
var total_time = 0
var timer_running = false
var used_time

func clear():
	text = "0.00"
	timer_running = false
	
func start():
	timer_running = true
	start_time = Time.get_ticks_msec()
	
func finish():
	timer_running = false

func _process(delta: float) -> void:
	if timer_running:
		var current_time = Time.get_ticks_msec()
		used_time = (current_time - start_time) / 1000.0
		text = "%.1f" % used_time
		
