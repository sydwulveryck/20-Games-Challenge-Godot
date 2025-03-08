extends Node2D

@onready var ball : CharacterBody2D = %Ball
@onready var paddle : CharacterBody2D = %Paddle
@onready var animation_player : AnimationPlayer = %AnimationPlayer

var bricks : Array[Array]

############
## BRICKS ##
## #########

var COLORS : Dictionary = {
	"Red" : Color.html("ff5252"),
	"Orange" : Color.html("f5b54e"),
	"Yellow" : Color.html("eef52a"),
	"Green": Color.html("49a81d"),
}

@export var brick_score : int = 15
@export var bricks_per_line : int = 15

func _create_bricks_array() -> void:
	for i in 8:
		bricks.append([])
		for j in bricks_per_line:
			bricks[i].append([])

func _create_bricks() -> Array[Array]:
	for i in 8:
		var color : Color
		match i :
			6, 7:
				color = COLORS["Green"]
			4, 5:
				color = COLORS["Yellow"]
			2, 3:
				color = COLORS["Orange"]
			0, 1:
				color = COLORS["Red"]
			
		bricks.append([])
		for j in bricks_per_line:
			bricks[i][j] = Brick._new_brick(
								Vector2(j*32 + 15, 160 + 16 * i),
								color,
								2
			)
			bricks[i][j]._brick_destroyed.connect(_brick_destroyed)

	return bricks

func _destroy_all_bricks() -> void:
	for line in bricks:
		for brick : Brick in line:
			if is_instance_valid(brick):
				brick.disconnect("brick_destroyed", _brick_destroyed)
				brick.queue_free()
				
	var _bricks : Array[Array]

func _brick_destroyed() -> void:
	_set_score(score + brick_score)


###################
## STATE MACHINE ##
## ###############

enum STATE {
		INTRO,
		RUNNING,
		PAUSED,
		OVER,
		UNDEFINED
}

signal _state_changed

@export var state : STATE = STATE.INTRO :
	set = _set_state,
	get = _get_state

func _set_state(value : STATE) -> bool:
	if state != value:
		state = value
		emit_signal("_state_changed")
		return true
	return false

func _get_state() -> STATE:
	return state

func _on_state_changed() -> void:
	print("State changed : " + STATE.keys()[state])
	match state:
		STATE.INTRO:
			_game_intro()
		STATE.RUNNING:
			_game_running()
		STATE.PAUSED:
			_game_paused()
		STATE.OVER:
			_game_over()

###################
## STATES LOGIC ##
##################

func _game_intro() -> void:
	%TitleScreen.visible = true
	%ActionStoppedVeil.visible = true 
	%ResumeText.visible = true

	%TitleScreen.top_level = true

	# pauser le moteur physique pour la balle et le paddle suffit
	ball.set_physics_process(false)
	paddle.set_physics_process(false)

func _game_running() -> void:
	%ActionStoppedVeil.visible = false
	%GamePausedText.visible = false
	%GameOverText.visible = false
	%HighScores.visible = false
	%ResumeText.visible = false 

	if !ball.is_physics_processing() or !paddle.is_physics_processing():
		# relancer le moteur physique pour la balle et le paddle suffit
		ball.set_physics_process(true)
		paddle.set_physics_process(true)

func _game_paused() -> void:
	%ActionStoppedVeil.visible = true 
	%GamePausedText.visible = true
	%ResumeText.visible = true

	%HighScores.visible = false

	# pauser le moteur physique pour la balle et le paddle suffit
	ball.set_physics_process(false)
	paddle.set_physics_process(false)
	

func _game_over() -> void:
	# immobile en dehors du cadre, c'est crade mais efficace
	ball.position = Vector2(1000,1000)
	ball.direction = Vector2(0, 0)

	var highscores : Array = _read_highscore_file(save_file_path)
	highscores = _new_highscores(highscores, score)
	_write_highscore_file(save_file_path, highscores)

	_set_highscores_text(highscores)

	animation_player.play("game_over_text_fade_in") 
	animation_player.play("game_over_instructions_fade_in") 
	
	%GameOverText.visible = true
	%HighScores.visible = true
	%ActionStoppedVeil.visible = true
	%ResumeText.visible = true

##############################
#### LIVES FUNCTIONNALITY ####
## ###########################

@export var starting_lives : int = 3
var lives : int = starting_lives :
	set = _set_life,
	get = _get_life

func _set_life(value : int) -> void:
	if value > -1:
		lives = value
		_set_lives_text(lives)
	if value == 0:
		_set_state(STATE.OVER)

func _get_life() -> int:
	return lives
		
@onready var lives_text : RichTextLabel = $UI/LivesText

func _set_lives_text(lives : int) -> void:
	lives_text.text = str(lives)

###############################
#### SCORES FUNCTIONNALITY ####
## ############################

@export var starting_score : int = 000
var score : int = starting_score :
	set = _set_score,
	get = _get_score

func _set_score(value : int) -> void:
	print("Score changed : " + str(score))
	if score != value && score > -1:
		if score < value:
			%ScoreAudioStreamPlayer.play()
		score = value
		_set_speed_multiplier(score)
		_set_score_text(value)

func _get_score() -> int:
	return score

@onready var score_text : RichTextLabel = $UI/ScoreText

func _set_score_text(value : int) -> void:
	var formatted_value : String = "[right]" + "%03d" % value + "[/right]"
	print("Score text Label changed : " + formatted_value)
	if score_text.text != formatted_value:
		score_text.text = formatted_value

func _set_speed_multiplier(value : float) -> void:
	print("Speed multiplier changed : " + str(ball.speed_multiplier))
	if ball.speed_multiplier != value:
		ball.speed_multiplier = 1.0 + float(score) / 150

################
## HIGH SCORE ##
## #############

# pas besoin de checker si le score est plus haut que x éléments de la liste
# méthode bourrine : on ajouter un 6e score, on sort et on vire l'index le plus bas
# (hihi je suis fiere de ca)

var save_file_path : String = "user://highscores.dat"
var highscores : Array[int] = _read_highscore_file(save_file_path)
var default_highscores : Array[int] = [0, 100, 300, 400, 1000]
	
func _new_highscores(highscores : Array, new_score : int) -> Array:
	highscores.append(new_score)
	highscores.sort()
	print(highscores)
	highscores.remove_at(0)
	print(highscores)

	return highscores

func _create_highscore_file(path : String) -> void:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)	
	for i in 5:
		file.store_line(str(default_highscores[i]))

func _read_highscore_file(path : String) -> Array:
	var scores : Array
	if FileAccess.file_exists(save_file_path):
		var file : FileAccess = FileAccess.open(path, FileAccess.READ)
		for line : String in file.get_line():
			scores.append(int(line))
	else:
		_create_highscore_file(save_file_path)

	if scores.size() != 5:
		# Highscores par défaut
		return default_highscores

	return scores

func _write_highscore_file(path : String, scores : Array) -> void:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	for score : int in scores:
		file.store_line(str(score))

func _set_highscores_text(highscores : Array) -> void:
	%HighScores.text = "\n"
	%HighScores.text += "[center]HIGHSCORES[/center]"
	%HighScores.text += "\n\n\n\n"
	%HighScores.text += "1. "
	%HighScores.text += str(highscores[4])
	%HighScores.text += "\n\n"
	%HighScores.text += "2. "
	%HighScores.text += str(highscores[3])
	%HighScores.text += "\n\n"
	%HighScores.text += "3. "
	%HighScores.text += str(highscores[2])
	%HighScores.text += "\n\n"
	%HighScores.text += "4. "
	%HighScores.text += str(highscores[1])
	%HighScores.text += "\n\n"
	%HighScores.text += "5. "
	%HighScores.text += str(highscores[0])

###################
#### BUILT-INS ####
## ################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_state(STATE.INTRO)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_handle_cancel()

#################
#### SIGNALS ####
## ##############

func _on_out_of_bounds_body_entered(_collider : CollisionObject2D) -> void:
	_set_life(lives - 1)
	print("Lives left : " + str(lives))
	if lives > 0:
		ball._reset_ball(ball.new_ball_delay)
	else:
		_set_state(STATE.OVER)

#################
## INPUT LOGIC ##
## ##############

func _handle_cancel() -> void:
	match state:
		STATE.INTRO:
			_create_bricks_array()
			var lines : Array[Array] = _create_bricks()

			# Container for Y-Sorting bricks (showing them under veil of menu)
			for line in lines:
				for brick : Brick in line:
					$BricksContainer.add_child(brick)
	
			# Wait for scene tree to fully load 
			# await get_tree().root.ready
			connect("_state_changed", _on_state_changed)
			# ball._reset_ball(ball.new_ball_delay)
			_set_state(STATE.RUNNING)
			%TitleScreen.queue_free()
			ball._reset_ball(ball.new_ball_delay)
		STATE.RUNNING:
			_set_state(STATE.PAUSED)
		STATE.PAUSED:
			_set_state(STATE.RUNNING)
		STATE.OVER:
			_reset_game()
			_set_state(STATE.RUNNING)

func _reset_game() -> void:
	_set_life(starting_lives)
	_set_score(starting_score)	

	_destroy_all_bricks()
	bricks = _create_bricks()

	for line in bricks:
		for brick : Brick in line:
			$BricksContainer.add_child(brick)

	paddle.position = Vector2(256, 600)
	ball._reset_ball(ball.new_ball_delay)
