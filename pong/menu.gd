extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var game_state : int = 0
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		game_state = game_state + 1
		print(game_state % 2)
	
	if game_state % 2 == 0:
		get_tree().paused = false
	else:
		get_tree().paused = true

