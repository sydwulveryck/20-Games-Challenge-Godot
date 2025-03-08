extends CharacterBody2D

@onready var animation_player : AnimationPlayer = %AnimationPlayer

@export var speed : int = 200
@export var speed_multiplier : float = 1.0

var direction : Vector2 = Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	var collision : KinematicCollision2D = move_and_collide(direction * speed * speed_multiplier * delta)

	if collision:
		var collider : Object = collision.get_collider()
		%ReboundAudioStreamPlayer.play()
		if collider.name == "Paddle":
			direction = _dynamic_bounce(collider)
		else:
			if collider is Brick:
				collider._brick_hit()
			direction = direction.bounce(collision.get_normal())
			direction = direction.normalized()
				
	# velocity = direction * speed * speed_multiplier



func _dynamic_bounce(collider: PhysicsBody2D) -> Vector2:
	var collider_center : Vector2 = collider.position #- collider.size / 2 
	
	return (position - collider_center).normalized()


####################
## NEW BALL DELAY ##
## ################

@export var new_ball_delay : float  = 1.0

func _wait_new_ball(new_ball_delay : float) -> void:
	await get_tree().create_timer(new_ball_delay).timeout

func _reset_ball(new_ball_delay : float) -> void:
	# On montre la balle mais elle ne bouge que x secondes plus tard
	direction = Vector2(0,0)
	position = Vector2(256, 384)
	animation_player.play("new_ball")

	await get_tree().create_timer(new_ball_delay).timeout
	
	direction = Vector2(0,1)
