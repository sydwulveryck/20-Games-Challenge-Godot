class_name Ball extends CharacterBody2D

const BALL_SCENE : PackedScene = preload("res://ball.tscn")

@export_group("Local variables")

@export var width : int = 25
@export var height : int = 25

@export var speed : int = 300

const RAYCAST_LENGTH = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# colliding up or down, just invert vertical movement 
	if $RayCast2DDown.is_colliding() or $RayCast2DUp.is_colliding():
		velocity = velocity * Vector2(1, -1)

	# if $RayCast2DRight.is_colliding() or $RayCast2DLeft.is_colliding():
	if $RayCast2DRight.is_colliding():
		velocity = (position - $RayCast2DRight.get_collider().center_position).normalized() * speed
	if $RayCast2DLeft.is_colliding():
		velocity = (position - $RayCast2DLeft.get_collider().center_position).normalized() * speed
	move_and_slide()

func _build_ball(shape : Vector2) -> void:
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

	poly.position = poly.position - shape / 2
	collision.position = collision.position - shape / 2

	add_child(poly)
	add_child(collision)

static func _random_ball_unit_velocity() -> Vector2:
	var vel_x = randf_range(0.1, 1)
	var vel_y = randf_range(-1, 1)
	
	return Vector2(vel_x, vel_y).normalized()

static func _new_ball(shape : Vector2, speed : int, start_velocity : Vector2) -> Ball:
	var new_ball = BALL_SCENE.instantiate()
	new_ball._build_ball(shape)
	new_ball.speed = speed
	new_ball.velocity = start_velocity * new_ball.speed

	return new_ball
