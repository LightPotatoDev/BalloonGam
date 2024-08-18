extends TileMap

const cloud_particle = preload("res://scenes/effects/CloudParticle.tscn")
const dir = [
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.UP
]

func _ready():
	for pos in get_used_cells(0):
		var neighbor_exists = check_neighbors(pos)
		print(pos,neighbor_exists)
		for i in range(4):
			if neighbor_exists[i] == false:
				var c = cloud_particle.instantiate()
				c.position = pos * 32 + dir[i] * 16 + Vector2i.ONE * 16
				c.rotation = deg_to_rad(90 * i + 90)
				add_child(c)

func check_neighbors(pos: Vector2) -> Array:
	var res:Array = []
	for neighbor_pos in get_surrounding_cells(pos):
		res.append(get_cell_atlas_coords(0, neighbor_pos) == Vector2i(0,0))
	return res
