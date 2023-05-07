extends Node2D

@export var tilemap:TileMap = null;

const CLOUD:Array[Vector2i] = [Vector2i(4, 6)];
const SEAWEED:Array[Vector2i] = [Vector2i(6, 3), Vector2i(6, 4), Vector2i(8, 4), Vector2i(8, 5)]

var tilepositions:Array[Vector2] = [];

func _ready() -> void:
	if tilemap != null:
		tilepositions = getpositions(SEAWEED);
		for t in tilepositions:
			spawn(t, "killbox", "small");

func getpositions(tiletype:Array[Vector2i]) -> Array[Vector2]:
	var completetilelist:Array[Vector2i] = [];
	for t in tiletype:
		completetilelist.append_array(tilemap.get_used_cells_by_id(0, 0, t, 0));
	
	var tilelistfinal:Array[Vector2] = [];
	for tile in completetilelist:
		tilelistfinal.push_back(tilemap.map_to_local(tile));
	
	return tilelistfinal;

func spawn(pos:Vector2, entitytype:String, variant:String = ""):
	var newentity = World.entities[entitytype].instantiate();
	newentity.position = pos;
	
	match variant:
		"small":
			newentity.get_node("Area2D").get_node("CollisionShape2D").shape.size = Vector2(6, 6);
	
	add_child(newentity);
