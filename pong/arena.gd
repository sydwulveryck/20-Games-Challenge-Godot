extends Control

###############
## VARIABLES ##
###############

@export_group("Ball settings")

@export var ball_speed : int = 800
@export var ball_width : int = 25
@export var ball_height : int = 25

var ball : Ball
var ball_shape : Vector2 = Vector2(ball_width, ball_height)

var arena_size : Vector2 = DisplayServer.window_get_size()

var score_left : int = 0
var score_right : int = 0


###############
## BUILT-INS ##
###############

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_walls()
	
	# SETUP PADDLES #
	$PaddleLeft.paddle_side = "LEFT"
	$PaddleRight.paddle_side = "RIGHT"

	$Ball.velocity = Ball._random_ball_unit_velocity() * ball_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_reset_game()

###########
## UTILS ##
###########

func _create_walls() -> void:
	# CREATE WALLS #
	var top_wall = StaticBody2D.new()
	var bottom_wall = StaticBody2D.new()
	var top_wall_collision = CollisionPolygon2D.new()
	var bottom_wall_collision = CollisionPolygon2D.new()
	
	var top_wall_points : PackedVector2Array = ([
		Vector2(0, 0),
		Vector2(arena_size.x, 0),
		Vector2(arena_size.x, -30),
		Vector2(0, -30)
	])

	var bottom_wall_points : PackedVector2Array = ([
		Vector2(0, arena_size.y),
		Vector2(arena_size.x, arena_size.y),
		Vector2(arena_size.x, arena_size.y + 30),
		Vector2(0, arena_size.y + 30)
	])

	top_wall_collision.set_polygon(top_wall_points)
	top_wall.add_child(top_wall_collision)
	add_child(top_wall)

	bottom_wall_collision.set_polygon(bottom_wall_points)
	bottom_wall.add_child(bottom_wall_collision)
	add_child(bottom_wall)

func _point_scored():
	print("goal")

	$HBoxArena/LeftGameUI/VBoxScoreRight/ScoreTextRight.text = "[center]" + str(score_right) + "[/center]"
	$HBoxArena/RightGameUI/VBoxScoreRight/ScoreTextRight.text = "[center]" + str(score_left) + "[/center]"

	$Ball.position = arena_size / 2

func _reset_game():
	score_left = 0
	score_right = 0
	_point_scored()

##############
## SIGNAlS ##
## ##########

func _on_goal_right_body_entered(object: PhysicsBody2D):
	score_right = score_right + 1
	_point_scored()
	
func _on_goal_left_body_entered(object: ):
	score_left = score_left + 1
	_point_scored()

