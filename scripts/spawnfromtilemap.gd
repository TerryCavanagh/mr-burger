extends Node2D

@export var tilemap:TileMap = null;

const CLOUD:Array[Vector2i] = [Vector2i(4, 6)];
const SEAWEED:Array[Vector2i] = [Vector2i(6, 3), Vector2i(6, 4), Vector2i(8, 4), Vector2i(8, 5)]

const STAR:Array[Vector2i] = [Vector2i(1, 10)];
const DOT:Array[Vector2i] = [Vector2i(2, 10)];
const DOT_HIGH:Array[Vector2i] = [Vector2i(3, 10)];

const BACKGROUND:Array[Vector2i] = [Vector2i(0, 0), Vector2i(5, 0), Vector2i(7, 0), Vector2i(2, 3), Vector2i(6, 6), Vector2i(9, 6), Vector2i(9, 7)];

func _ready() -> void:
	if tilemap != null:
		spawnall(getpositions(SEAWEED), "killbox", ["small"]);
		spawnall(getpositions(STAR), "coin", ["fixbackground"]);
		spawnall(getpositions(DOT), "dot", ["fixbackground"]);
		spawnall(getpositions(DOT_HIGH), "dot", ["fixbackground", "high"]);
	
	tilemap.force_update(0);

func getpositions(tiletype:Array[Vector2i]) -> Array[Vector2]:
	var completetilelist:Array[Vector2i] = [];
	for t in tiletype:
		completetilelist.append_array(tilemap.get_used_cells_by_id(0, 0, t, 0));
	
	var tilelistfinal:Array[Vector2] = [];
	for tile in completetilelist:
		tilelistfinal.push_back(tilemap.map_to_local(tile));
	
	return tilelistfinal;

func spawnall(positions:Array[Vector2], entitytype:String, variant:Array[String] = []):
	for t in positions:
		spawn(t, entitytype, variant);

func spawn(pos:Vector2, entitytype:String, variant:Array[String] = []):
	var newentity = World.entities[entitytype].instantiate();
	newentity.position = pos;
	
	for v in variant:
		match v:
			"small":
				newentity.get_node("Area2D").get_node("CollisionShape2D").shape.size = Vector2(6, 6);
			"high":
				newentity.position.y -= 8;
			"fixbackground":
				@warning_ignore("narrowing_conversion")
				var column:int = (pos.x / 16);
				@warning_ignore("narrowing_conversion")
				var row:int = (pos.y / 16)
				var background:Vector2i = Vector2i(0, 0);
				
				var i:int = 0;
				var tilemap_width:int = tilemap.get_used_rect().size.x;
				while i < tilemap_width:
					var tile = tilemap.get_cell_atlas_coords(0, Vector2i(i, row));
					if BACKGROUND.has(tile):
						background = tile;
						i = tilemap_width;
					i += 1;
				
				tilemap.set_cell(0, Vector2i(column, row), 0, background, 0);
	
	add_child(newentity);
