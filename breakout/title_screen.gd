extends Node2D

var COLORS : Dictionary = {
	"Red" : Color.html("ff5252"),
	"Orange" : Color.html("f5b54e"),
	"Yellow" : Color.html("eef52a"),
	"Green": Color.html("49a81d"),
	"Gray": Color.html("333333"),
}

@onready var grid : Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# # B
	# for i in 8:
	# 	add_child(Brick._new_brick(Vector2(0, i * 16), COLORS["Red"], 2))
		
	# add_child(Brick._new_brick(Vector2(32, 0), COLORS["Red"], 2))
	# add_child(Brick._new_brick(Vector2(32, 3 * 16), COLORS["Red"], 2))
	# add_child(Brick._new_brick(Vector2(32, 7 * 16), COLORS["Red"], 2))
	
	# add_child(Brick._new_brick(Vector2(64, 1* 16), COLORS["Red"], 2))
	# add_child(Brick._new_brick(Vector2(64, 2 * 16), COLORS["Red"], 2))
	# add_child(Brick._new_brick(Vector2(64, 4 * 16), COLORS["Red"], 2))
	# add_child(Brick._new_brick(Vector2(64, 5 * 16), COLORS["Red"], 2))
	# add_child(Brick._new_brick(Vector2(64, 6 * 16), COLORS["Red"], 2))

	# # R
	# for i in 8:
	# 	add_child(Brick._new_brick(Vector2(32 * 4, i * 16), COLORS["Orange"], 2))

	# L'idée c'est une rangée de 8 rows de briques qui remplissent l'écran,
	# elles sont touts noires/grises foncées sauf celles qui forment le mot
	# "BREAKOUT", qui sont colorées comme les briques cassables

	await get_tree().create_timer(1).timeout
		
	for i in 17:
		grid.append([])
		for j in 48:
			grid[i].append(
				Brick._new_brick(
					Vector2(31 * i, 16 * j),
				 	COLORS["Gray"],
				 	2
				)
			)
			add_child(grid[i][j])

	# B
	
	grid[1][9]._set_color(COLORS["Red"])
	grid[1][10]._set_color(COLORS["Red"])
	grid[1][11]._set_color(COLORS["Red"])
	grid[1][12]._set_color(COLORS["Red"])
	grid[1][13]._set_color(COLORS["Red"])
	grid[1][14]._set_color(COLORS["Red"])

	grid[2][9]._set_color(COLORS["Red"])
	grid[2][11]._set_color(COLORS["Red"])
	grid[2][14]._set_color(COLORS["Red"])
	

	grid[3][10]._set_color(COLORS["Red"])
	grid[3][12]._set_color(COLORS["Red"])
	grid[3][13]._set_color(COLORS["Red"])
	
	# R
	
	grid[4][9]._set_color(COLORS["Orange"])
	grid[4][10]._set_color(COLORS["Orange"])
	grid[4][11]._set_color(COLORS["Orange"])
	grid[4][12]._set_color(COLORS["Orange"])
	grid[4][13]._set_color(COLORS["Orange"])
	grid[4][14]._set_color(COLORS["Orange"])

	grid[5][9]._set_color(COLORS["Orange"])
	grid[5][12]._set_color(COLORS["Orange"])

	
	grid[6][10]._set_color(COLORS["Orange"])
	grid[6][11]._set_color(COLORS["Orange"])
	grid[6][13]._set_color(COLORS["Orange"])
	grid[6][14]._set_color(COLORS["Orange"])

	
	# E
	
	grid[7][9]._set_color(COLORS["Yellow"])
	grid[7][10]._set_color(COLORS["Yellow"])
	grid[7][11]._set_color(COLORS["Yellow"])
	grid[7][12]._set_color(COLORS["Yellow"])
	grid[7][13]._set_color(COLORS["Yellow"])
	grid[7][14]._set_color(COLORS["Yellow"])
	
	grid[8][9]._set_color(COLORS["Yellow"])
	grid[8][11]._set_color(COLORS["Yellow"])
	grid[8][14]._set_color(COLORS["Yellow"])
	
	grid[9][9]._set_color(COLORS["Yellow"])
	grid[9][14]._set_color(COLORS["Yellow"])

	# A

	grid[10][10]._set_color(COLORS["Green"])
	grid[10][11]._set_color(COLORS["Green"])
	grid[10][12]._set_color(COLORS["Green"])
	grid[10][13]._set_color(COLORS["Green"])
	grid[10][14]._set_color(COLORS["Green"])

	grid[11][9]._set_color(COLORS["Green"])
	grid[11][11]._set_color(COLORS["Green"])
	
	grid[12][10]._set_color(COLORS["Green"])
	grid[12][11]._set_color(COLORS["Green"])
	grid[12][12]._set_color(COLORS["Green"])
	grid[12][13]._set_color(COLORS["Green"])
	grid[12][14]._set_color(COLORS["Green"])

	# K
	grid[13][9]._set_color(COLORS["Red"])
	grid[13][10]._set_color(COLORS["Red"])
	grid[13][11]._set_color(COLORS["Red"])
	grid[13][12]._set_color(COLORS["Red"])
	grid[13][13]._set_color(COLORS["Red"])
	grid[13][14]._set_color(COLORS["Red"])

	
	grid[14][11]._set_color(COLORS["Red"])

	grid[15][9]._set_color(COLORS["Red"])
	grid[15][10]._set_color(COLORS["Red"])
	grid[15][12]._set_color(COLORS["Red"])
	grid[15][13]._set_color(COLORS["Red"])
	grid[15][14]._set_color(COLORS["Red"])

	# O

	grid[4][17]._set_color(COLORS["Red"])
	grid[4][18]._set_color(COLORS["Red"])
	grid[4][19]._set_color(COLORS["Red"])
	grid[4][20]._set_color(COLORS["Red"])

	grid[5][16]._set_color(COLORS["Red"])
	grid[5][21]._set_color(COLORS["Red"])
	
	grid[6][17]._set_color(COLORS["Red"])
	grid[6][18]._set_color(COLORS["Red"])
	grid[6][19]._set_color(COLORS["Red"])
	grid[6][20]._set_color(COLORS["Red"])

	# U
	grid[7][16]._set_color(COLORS["Orange"])
	grid[7][17]._set_color(COLORS["Orange"])
	grid[7][18]._set_color(COLORS["Orange"])
	grid[7][19]._set_color(COLORS["Orange"])
	grid[7][20]._set_color(COLORS["Orange"])

	grid[8][21]._set_color(COLORS["Orange"])

	grid[9][16]._set_color(COLORS["Orange"])
	grid[9][17]._set_color(COLORS["Orange"])
	grid[9][18]._set_color(COLORS["Orange"])
	grid[9][19]._set_color(COLORS["Orange"])
	grid[9][20]._set_color(COLORS["Orange"])

	# T
	grid[10][16]._set_color(COLORS["Green"])

	grid[11][16]._set_color(COLORS["Green"])
	grid[11][17]._set_color(COLORS["Green"])
	grid[11][18]._set_color(COLORS["Green"])
	grid[11][19]._set_color(COLORS["Green"])
	grid[11][20]._set_color(COLORS["Green"])
	grid[11][21]._set_color(COLORS["Green"])

	grid[12][16]._set_color(COLORS["Green"])

	var i : int = 0
	while i < 17 * 48 * 2:
		var random_brick : Vector2 = Vector2(randi() % 17, randi() % 48)
		if is_instance_valid(grid[random_brick.x][random_brick.y]): # and get_tree():
			grid[random_brick.x][random_brick.y]._brick_hit()
			await get_tree().create_timer(0.1).timeout
			i = i + 1
		

	
