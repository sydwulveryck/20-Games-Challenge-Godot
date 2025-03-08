extends CharacterBody2D

#### EXPORTED CONTROLS ####

# @export_group("Controls")

# @export var control_up: String 
# @export var control_down : String 

#### EXPORTED VARIABLES ####

@export_group("Variables")

@export_enum("LEFT","RIGHT","UNDEFINED") var paddle_side : String = "UNDEFINED"

@export var width : int = 30
@export var height : int = 100

@export var speed : int = 700

#### LOCAL VARIABLES ####

var shape : Vector2 = Vector2(width, height)
var direction : float
var center_position : Vector2

# #### CHILDREN ####
# @onready var collision = $CollisionShape2D
# @onready var polygon = $Polygon2D

#### BUILT-INS ####

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_build_paddle(shape)

func _input(_event) -> void:
	direction = int(Input.is_action_pressed(paddle_side + "_down")) - int(Input.is_action_pressed(paddle_side + "_up"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y = clamp(position.y, 0, DisplayServer.window_get_size().y - height)
	center_position = Vector2(position.x + width / 2, position.y + height / 2)
	
	velocity.y = speed * direction

	move_and_slide()

func _build_paddle(shape : Vector2) -> void:
	var poly = Polygon2D.new()
	var collision = CollisionPolygon2D.new()
	var points = PackedVector2Array([
		Vector2(0, 0),
		Vector2(shape.x, 0),
		Vector2(shape.x, shape.y),
		Vector2(0, shape.y),
	]) 

	poly.set_polygon(points)
	collision.set_polygon(points)

	add_child(poly)
	add_child(collision)
