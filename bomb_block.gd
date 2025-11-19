extends TileMapLayer

@export var target_tile: Vector2i;
@export var delay_frames := 3;

var tiles_to_destroy: Array[Vector2i] = [];
var adjacent_tiles: Array[Vector2i] = [];

var delay_timer := 0;

var is_exploding := false;

func _physics_process(_delta) -> void:
	if delay_timer > 0:
		delay_timer -= 1;
		if delay_timer <= 0:
			delay_timer = delay_frames;
			explode_tiles();
	
	if Input.is_action_just_pressed("ui_accept") and !is_exploding:
		is_exploding = true;
		tiles_to_destroy.append(target_tile);
		delay_timer = delay_frames;
		explode_tiles();

func explode_tiles() -> void:
	if tiles_to_destroy.is_empty():
		queue_free();
		return
	
	for tile in tiles_to_destroy:
		erase_cell(tile);
		for neighbor in get_surrounding_cells(tile):
			if neighbor not in adjacent_tiles:
				adjacent_tiles.append(neighbor);
	tiles_to_destroy.clear();
	tiles_to_destroy.append_array(adjacent_tiles);
	adjacent_tiles.clear();
