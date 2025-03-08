extends CharacterBody2D

@onready var speed : int = 8

var direction : int
var new_velocity : Vector2 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(_event: InputEvent) -> void:
	direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	# Calculer la vélocité ici permet d'avoir un mouvement à "cran", avec un effet arcade sympa
	# et moins glissant à jouer
	velocity = Vector2(direction, 0) * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	position = position + velocity
	position = clamp(position, Vector2(16, 600), Vector2(592,600))

	move_and_slide()
