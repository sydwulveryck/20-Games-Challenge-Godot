extends TileMapLayer

##########
## DATA ##
## #######

const DEAD = Vector2i(0, 0)
const ALIVE = Vector2i(1, 0)
const NOT_HOVERED = Vector2i(2, 0)
const HOVERED = Vector2i(3, 0)

@export var width : int = 100
@export var height : int = 100

@export var cell_width : int = 16
@export var cell_height : int = 16

var size : Vector2 = Vector2(width, height)
var cell_size : Vector2 = Vector2(cell_width, cell_height)

var generation_duration : float = 0.1

####################
## UNIVERSE LOGIC ##
####################

var universe: Array[Array]

signal universe_changed

func _create_empty_universe(universe_size : Vector2) -> Array[Array]:
	var grid : Array[Array]
	for row in universe_size.x:
		grid.append([])
		for column in universe_size.y:
			grid[row].append(0)
			# grid[row].append([0, 0, 0, 0, 0, 0, 0, 1].pick_random())

	return grid

func _render_universe(universe_array : Array[Array]) -> void:
	clear()
	print("universe tilemap cleared")
	for row in size.x:
		for column in size.y:
			var cell = universe_array[row][column]
			var grid_pos = Vector2i(row, column) # - Vector2i(size/2)
			var atlas_coord = ALIVE if universe_array[row][column] == 1 else DEAD
			set_cell(grid_pos, 0, atlas_coord)
			notify_runtime_tile_data_update()  # Critical for runtime changes [8]

func _new_universe(current_universe : Array[Array]) -> Array[Array]:
	var new_universe : Array[Array] = _create_empty_universe(size)

	for row in size.x:
		for column in size.y:
			var alive_neighbours : int = 0

			if row >= size.x || column >= size.y:
				continue
			
			if row > 0:
				alive_neighbours = alive_neighbours + universe[row - 1][column] 
			if row < size.x - 1:
				alive_neighbours = alive_neighbours + universe[row + 1][column] 

			if column > 0:
				alive_neighbours = alive_neighbours + universe[row][column - 1] 
			if column < size.y - 1:
				alive_neighbours = alive_neighbours + universe[row][column + 1] 

			if row > 0 and column > 0:
				alive_neighbours = alive_neighbours + universe[row - 1][column - 1]
			if row < size.x - 1 and column < size.y - 1:
				alive_neighbours = alive_neighbours + universe[row + 1][column + 1]

			if row > 0 and column < size.y - 1:
				alive_neighbours = alive_neighbours + universe[row - 1][column + 1]
			if row < size.x - 1 and column > 0:
				alive_neighbours = alive_neighbours + universe[row + 1][column - 1]
				
			if current_universe[row][column] == 1 and alive_neighbours < 2:
				new_universe[row][column] = 0
			if current_universe[row][column] == 1 and (alive_neighbours == 2 or alive_neighbours == 3):
				new_universe[row][column] = 1
			if current_universe[row][column] == 1 and alive_neighbours > 3:	
				new_universe[row][column] = 0
			if current_universe[row][column] == 0 and alive_neighbours == 3:
				new_universe[row][column] = 1
									
	return new_universe

func _on_universe_changed():
	print("universe changed")
	_render_universe(universe)

var generation_count : int = 0

func _on_generation_ended():
	print("Generation " + str(generation_count) + "elapsed")
	generation_count = generation_count + 1

	universe = _new_universe(universe)
	emit_signal("universe_changed")

	$GenerationTimer.wait_time = generation_duration

###############
## BUILT-INS ##
## ############

func _ready() -> void:
	state = GAME_STATE.INPUT
	
	universe_changed.connect(_on_universe_changed)
	universe = _create_empty_universe(size)
	emit_signal("universe_changed")

	$GenerationTimer.wait_time = generation_duration
	$GenerationTimer.timeout.connect(_on_generation_ended)
	

##################
## Player INPUT ##
## ###############

enum GAME_STATE {
		AUTOMATA,
		INPUT
}

var state : GAME_STATE = GAME_STATE.INPUT

var mouse_pos : Vector2
var mouse_grid_pos : Vector2i

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_start()
			
	if Input.is_action_just_pressed("ui_accept"):
		_stop()
		
	if state == GAME_STATE.INPUT:
		if Input.get_last_mouse_screen_velocity() != Vector2.ZERO:
			mouse_pos = get_local_mouse_position()
			mouse_grid_pos = local_to_map(mouse_pos.snapped(Vector2.ONE))

			var hovered_cell : Vector2i

			if hovered_cell != mouse_grid_pos:
				hovered_cell = mouse_grid_pos
				# print("Hovering : [" + str(hovered_cell.x) + ", " + str(hovered_cell.y) + "]")
		
			$MouseIndicator.clear()
			$MouseIndicator.set_cell(mouse_grid_pos, 0, HOVERED)

		if event is InputEventMouseButton and event.pressed:
			# Add position validation first
			var grid_pos = Vector2i(mouse_grid_pos)
			if grid_pos.x >= 0 and grid_pos.x < size.x and grid_pos.y >= 0 and grid_pos.y < size.y:
				universe[grid_pos.x][grid_pos.y] = 1 - universe[grid_pos.x][grid_pos.y]
				_render_universe(universe)  # Immediate update
				update_internals()  # Force redraw [8]
				print("Clicked at:", mouse_grid_pos, "State:", universe[mouse_grid_pos.x][mouse_grid_pos.y])

func _physics_process(delta: float) -> void:
	var direction : Vector2

	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if direction != Vector2.ZERO:
		position = position + cell_size * direction

#################
## INPUT LOGIC ##
## ##############

func _start() -> void:
	print("Game Start")
	state = GAME_STATE.AUTOMATA
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$MouseIndicator.clear()
	$GenerationTimer.start()

func _stop() -> void:
	# process_mode = ProcessMode.PROCESS_MODE_DISABLED
	# Stopper les générations mais permettre User Input
	state = GAME_STATE.INPUT
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _reset() -> void:
	universe = _create_empty_universe(size)
	emit_signal("universe_changed")

	_stop()
