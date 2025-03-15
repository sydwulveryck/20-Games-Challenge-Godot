extends Node

###########
## NODES ##
###########

@onready var grid : TileMapLayer = $GridTileMapLayer
@onready var symbols : TileMapLayer = $SymbolsTileMapLayer
@onready var preview : TileMapLayer = $PreviewTileMapLayer

@onready var menu : PackedScene = preload("res://menu.tscn")

#################
## GAME STATES ##
## ##############

enum GAME_STATE {
	RUNNING,
	PAUSED,
	OVER		
}

var game_state : GAME_STATE = GAME_STATE.RUNNING

#################
## MATCH MODES ##
## ##############

enum MATCH_MODE {
	PVP,
	PVAI,
}

var match_mode : MATCH_MODE

###################
## SYMBOLS LOGIC ##
## ################

enum SYMBOL {
		CROSS,
		CIRCLE,
		NONE
}

func _symbol_to_sprite_coord(symbol : SYMBOL) -> Vector2:
	var coords : Vector2
	
	match symbol:
		SYMBOL.NONE:
			coords = Vector2(0,1)
		SYMBOL.CROSS:
			coords = Vector2(1,1)
		SYMBOL.CIRCLE:
			coords = Vector2(2,1)
	
	return coords

################
## TURN LOGIC ##
## #############

signal new_turn

var turn : int = 0
var turn_symbol : SYMBOL

func _on_new_turn() -> void:
	if _check_for_winner():
		# _game_over()
		print("game over")
	else:
		turn = turn + 1
		if turn % 2 == 0:
			turn_symbol = SYMBOL.CROSS
		else:
			turn_symbol = SYMBOL.CIRCLE

		print("Turn " + str(turn) + ": " + str(turn_symbol))

################
## GRID LOGIC ##
## #############

var grid_size = Vector2(3,3)
var grid_array : Array[Array]

func _init_grid_array(array : Array[Array]) -> Array[Array]:
	for row in grid_size.x:
		array.append([])
		for col in grid_size.y:
			array[row].append(SYMBOL.NONE)

	return array

func _reset_grid() -> void:
	_init_grid_array(grid_array)
	symbols.clear()

func _check_for_winner() -> bool:
	# TODO WIN CONDITION
	return false

###################
## TODO AI LOGIC ##
## ################

###############
## BUILT-INS ##
## ############

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_array = _init_grid_array(grid_array)
	new_turn.connect(_on_new_turn)


func _input(event: InputEvent) -> void:
	var mouse_pos : Vector2 = grid.get_local_mouse_position()
	var local_mouse_pos : Vector2i = grid.local_to_map(mouse_pos)

	preview.clear()
	if grid_array[local_mouse_pos.x][local_mouse_pos.y] == SYMBOL.NONE:
		preview.set_cell(local_mouse_pos, 0, _symbol_to_sprite_coord(turn_symbol))

	if event is InputEventMouseButton and event.pressed:
		if grid_array[local_mouse_pos.x][local_mouse_pos.y] == SYMBOL.NONE:
			symbols.set_cell(local_mouse_pos, 0, _symbol_to_sprite_coord(turn_symbol))
			grid_array[local_mouse_pos.x][local_mouse_pos.y] = turn_symbol

			emit_signal("new_turn")

