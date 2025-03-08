class_name Brick
extends StaticBody2D

const scene = preload("res://brick.tscn")

signal _brick_destroyed

@export var size : Vector2 = Vector2(28, 14)

###########
## COLOR ##
###########

var color : Color :
	set = _set_color,
	get = _get_color

func _set_color(value : Color) -> void:
	if color != value:
		color = value
	modulate = color


func _get_color() -> Color:
	return color

############
## HEALTH ##
## #########

var health : int :
	set = _set_health,
	get = _get_health

func _set_health(value : int) -> void:
	if health != value:
		health = value
#		print("Brick " + str(get_instance_id()) + " health updated : " + str(health))

func _get_health() -> int:
	return health

############
## SPRITE ##
## #########

func _new_brick_sprite() -> Sprite2D:
	var texture : Resource = load("res://brick.png")
	var sprite : Sprite2D = Sprite2D.new()
	sprite.texture = texture
	sprite.position = size / 2 
	# sprite.modulate = color
	return sprite

###############
## COLLISION ##
## ############

func _new_brick_collision() -> CollisionShape2D:
	var collision_shape : CollisionShape2D = CollisionShape2D.new()
	
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(size.x, size.y)

	collision_shape.position = size / 2

	return collision_shape

#################
## CONSTRUCTOR ##
## ##############

static func _new_brick(position : Vector2, color : Color, health : int) -> Brick:
	var new_brick : Brick = scene.instantiate()

	new_brick.position = position
	new_brick.color = color
	new_brick.modulate = color
	new_brick.health = health

	return new_brick

###############
## BUILT-INS ##
## ############

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# var brick_poly : Polygon2D = _new_brick_poly()
	var brick_sprite : Sprite2D = _new_brick_sprite()
	var brick_collision : CollisionShape2D = _new_brick_collision()

	# add_child(brick_poly)
	add_child(brick_sprite)
	add_child(brick_collision)

################
## BRICK HIT ##
## ############


func _brick_hit() -> void:
	if health != 0:
		_set_health(health - 1)
	if health == 1:
		modulate.a = 0.5
	else:
		emit_signal("_brick_destroyed")
		self.queue_free()
