extends Node

var score_left : int = 0
var score_right : int = 0

#### FUNCS ####

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
