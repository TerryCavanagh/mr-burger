extends Node2D

@export var tilemap:TileMap = null;
@export var Enemy1_Parameters:EnemyParameters;
@export var Enemy2_Parameters:EnemyParameters;
@export var Enemy3_Parameters:EnemyParameters;
@export var Enemy4_Parameters:EnemyParameters;
@export var Enemy5_Parameters:EnemyParameters;
@export var Enemy6_Parameters:EnemyParameters;

const CLOUD:Array[Vector2i] = [Vector2i(4, 6)];
const SEAWEED:Array[Vector2i] = [Vector2i(6, 3), Vector2i(6, 4), Vector2i(8, 4), Vector2i(8, 5)]
const SPIKE_UP:Array[Vector2i] = [Vector2i(0, 9)];
const SPIKE_DOWN:Array[Vector2i] = [Vector2i(1, 9)];
const SPIKE_RIGHT:Array[Vector2i] = [Vector2i(2, 9)];
const SPIKE_LEFT:Array[Vector2i] = [Vector2i(3, 9)];
const CAVESPIKE:Array[Vector2i] = [Vector2i(12, 0), Vector2i(14, 2), Vector2i(15, 2), Vector2i(16, 2)];
const LAVA:Array[Vector2i] = [Vector2i(7, 0), Vector2i(4, 1)];

const STAR:Array[Vector2i] = [Vector2i(1, 10)];
const STAR_HIGH:Array[Vector2i] = [Vector2i(9, 10)];
const STAR_LOW:Array[Vector2i] = [Vector2i(8, 10)];
const DOT:Array[Vector2i] = [Vector2i(2, 10)];
const DOOR:Array[Vector2i] = [Vector2i(10, 10)];
const DOT_HIGH:Array[Vector2i] = [Vector2i(3, 10)];
const DOT_LOW:Array[Vector2i] = [Vector2i(7, 10)];
const KEY:Array[Vector2i] = [Vector2i(4, 10)];
const CHECKPOINT:Array[Vector2i] = [Vector2i(5, 10)];
const LADDER:Array[Vector2i] = [Vector2i(4, 9)];
const BLANK:Array[Vector2i] = [Vector2i(0, 10)];
const WATERDRIP:Array[Vector2i] = [Vector2i(6, 10)];

const ENEMY1:Array[Vector2i] = [Vector2i(0, 11)];
const ENEMY2:Array[Vector2i] = [Vector2i(1, 11)];
const ENEMY3:Array[Vector2i] = [Vector2i(2, 11)];
const ENEMY4:Array[Vector2i] = [Vector2i(3, 11)];
const ENEMY5:Array[Vector2i] = [Vector2i(4, 11)];
const ENEMY6:Array[Vector2i] = [Vector2i(5, 11)];

const DISAPPEARINGPLATFORM_GRAY:Array[Vector2i] = [Vector2i(6, 11)];
const DISAPPEARINGPLATFORM_YELLOW:Array[Vector2i] = [Vector2i(7, 11)];
const DISAPPEARINGPLATFORM_PINK:Array[Vector2i] = [Vector2i(8, 11)];
const DISAPPEARINGPLATFORM_GREEN:Array[Vector2i] = [Vector2i(9, 11)];
const DISAPPEARINGPLATFORM_BROWN:Array[Vector2i] = [Vector2i(10, 11)];

const VANISHINGPLATFORM_ON_GRAY:Array[Vector2i] = [Vector2i(11, 10)];
const VANISHINGPLATFORM_ON_YELLOW:Array[Vector2i] = [Vector2i(12, 10)];
const VANISHINGPLATFORM_ON_PINK:Array[Vector2i] = [Vector2i(13, 10)];
const VANISHINGPLATFORM_ON_GREEN:Array[Vector2i] = [Vector2i(14, 10)];
const VANISHINGPLATFORM_ON_BROWN:Array[Vector2i] = [Vector2i(15, 10)];

const VANISHINGPLATFORM_OFF_GRAY:Array[Vector2i] = [Vector2i(11, 11)];
const VANISHINGPLATFORM_OFF_YELLOW:Array[Vector2i] = [Vector2i(12, 11)];
const VANISHINGPLATFORM_OFF_PINK:Array[Vector2i] = [Vector2i(13, 11)];
const VANISHINGPLATFORM_OFF_GREEN:Array[Vector2i] = [Vector2i(14, 11)];
const VANISHINGPLATFORM_OFF_BROWN:Array[Vector2i] = [Vector2i(15, 11)];

const BACKGROUND:Array[Vector2i] = [Vector2i(0, 0), Vector2i(5, 0), Vector2i(2, 3), Vector2i(6, 6), Vector2i(9, 6), Vector2i(9, 7), Vector2i(0, 7), Vector2i(11, 0)];

func _ready() -> void:
	if tilemap != null:
		spawnall(getpositions(SEAWEED), "killbox", ["small"]);
		spawnall(getpositions(LAVA), "killbox", ["large"]);
		spawnall(getpositions(SPIKE_UP), "spikes", ["fixbackground", "up"]);
		spawnall(getpositions(SPIKE_DOWN), "spikes", ["fixbackground", "down"]);
		spawnall(getpositions(SPIKE_LEFT), "spikes", ["fixbackground", "left"]);
		spawnall(getpositions(SPIKE_RIGHT), "spikes", ["fixbackground", "right"]);
		spawnall(getpositions(CAVESPIKE), "killbox", ["small"]);
		spawnall(getpositions(STAR), "coin", ["fixbackground"]);
		spawnall(getpositions(STAR_HIGH), "coin", ["fixbackground", "high"]);
		spawnall(getpositions(STAR_LOW), "coin", ["fixbackground", "low"]);
		spawnall(getpositions(DOT), "dot", ["fixbackground"]);
		spawnall(getpositions(DOOR), "door", ["fixbackground", "fixdoor"]);
		spawnall(getpositions(DOT_HIGH), "dot", ["fixbackground", "high"]);
		spawnall(getpositions(DOT_LOW), "dot", ["fixbackground", "low"]);
		spawnall(getpositions(KEY), "key", ["fixbackground"]);
		spawnall(getpositions(WATERDRIP), "waterdrip", ["fixwaterdrip"]);
		spawnall(getpositions(CHECKPOINT), "checkpoint", ["fixbackground"]);
		spawnall(getpositions(LADDER), "ladder", ["fixbackground", "extend"]);
		spawnall(getpositions(ENEMY1), "simpleenemy", ["fixbackground", "enemy1"]);
		spawnall(getpositions(ENEMY2), "simpleenemy", ["fixbackground", "enemy2"]);
		spawnall(getpositions(ENEMY3), "simpleenemy", ["fixbackground", "enemy3"]);
		spawnall(getpositions(ENEMY4), "simpleenemy", ["fixbackground", "enemy4"]);
		spawnall(getpositions(ENEMY5), "simpleenemy", ["fixbackground", "enemy5"]);
		spawnall(getpositions(ENEMY6), "simpleenemy", ["fixbackground", "enemy6"]);
		spawnall(getpositions(DISAPPEARINGPLATFORM_GRAY), "disappearing_platform", ["fixbackground", "gray"]);
		spawnall(getpositions(DISAPPEARINGPLATFORM_YELLOW), "disappearing_platform", ["fixbackground", "yellow"]);
		spawnall(getpositions(DISAPPEARINGPLATFORM_PINK), "disappearing_platform", ["fixbackground", "pink"]);
		spawnall(getpositions(DISAPPEARINGPLATFORM_GREEN), "disappearing_platform", ["fixbackground", "green"]);
		spawnall(getpositions(DISAPPEARINGPLATFORM_BROWN), "disappearing_platform", ["fixbackground", "brown"]);
		spawnall(getpositions(VANISHINGPLATFORM_ON_GRAY), "vanishing_platform", ["fixbackground", "gray"]);
		spawnall(getpositions(VANISHINGPLATFORM_ON_YELLOW), "vanishing_platform", ["fixbackground", "yellow"]);
		spawnall(getpositions(VANISHINGPLATFORM_ON_PINK), "vanishing_platform", ["fixbackground", "pink"]);
		spawnall(getpositions(VANISHINGPLATFORM_ON_GREEN), "vanishing_platform", ["fixbackground", "green"]);
		spawnall(getpositions(VANISHINGPLATFORM_ON_BROWN), "vanishing_platform", ["fixbackground", "brown"]);
		spawnall(getpositions(VANISHINGPLATFORM_OFF_GRAY), "vanishing_platform", ["fixbackground", "gray", "off"]);
		spawnall(getpositions(VANISHINGPLATFORM_OFF_YELLOW), "vanishing_platform", ["fixbackground", "yellow", "off"]);
		spawnall(getpositions(VANISHINGPLATFORM_OFF_PINK), "vanishing_platform", ["fixbackground", "pink", "off"]);
		spawnall(getpositions(VANISHINGPLATFORM_OFF_GREEN), "vanishing_platform", ["fixbackground", "green", "off"]);
		spawnall(getpositions(VANISHINGPLATFORM_OFF_BROWN), "vanishing_platform", ["fixbackground", "brown", "off"]);
		spawnall(getpositions(BLANK), "", ["fixbackground"]);
		
		tilemap.force_update(0);
	else:
		print("tilemap not attached to level generation script!")

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
	var spawnentity:bool = false;
	var newentity;
	if entitytype != "":
		newentity = World.entities[entitytype].instantiate();
		newentity.position = pos;
		spawnentity = true;
	
	for v in variant:
		match v:
			"up":
				newentity.type = "up";
			"down":
				newentity.type = "down";
			"left":
				newentity.type = "left";
			"right":
				newentity.type = "right";
			"gray":
				newentity.colour = "gray";
			"yellow":
				newentity.colour = "yellow";
			"green":
				newentity.colour = "green";
			"pink":
				newentity.colour = "pink";
			"brown":
				newentity.colour = "brown";
			"on":
				newentity.startingstate = "on";
			"off":
				newentity.startingstate = "off";
			"small":
				newentity.get_node("Area2D").get_node("CollisionShape2D").shape.size = Vector2(6, 6);
			"large":
				newentity.get_node("Area2D").get_node("CollisionShape2D").shape.size = Vector2(16, 16);
			"fixdoor":
				newentity.position.x += 8;
				newentity.position.y += 8;
			"high":
				newentity.position.y -= 8;
			"low":
				newentity.position.y += 8;
			"extend":
				@warning_ignore("narrowing_conversion")
				var xpos:int = (pos.x / 16);
				@warning_ignore("narrowing_conversion")
				var ypos:int = (pos.y / 16);
				
				var height:int = 1;
				
				while tile_isbackground(xpos, ypos + 1) and height < 40:
					height += 1;
					ypos += 1;
				
				newentity.height = height;
			"fixwaterdrip":
				@warning_ignore("narrowing_conversion")
				var column:int = (pos.x / 16);
				@warning_ignore("narrowing_conversion")
				var row:int = (pos.y / 16);
				tile_place(column, row, Vector2i(12, 0));
				
				newentity.position.y += 6;
			"fixbackground":
				@warning_ignore("narrowing_conversion")
				var column:int = (pos.x / 16);
				@warning_ignore("narrowing_conversion")
				var row:int = (pos.y / 16);
				var background:Vector2i = Vector2i(0, 0);
				
				if column <= 0:
					column -= 1;
				
				var i:int = tilemap.get_used_rect().position.x;
				var tilemap_width:int = tilemap.get_used_rect().size.x;
				while i < tilemap_width:
					var tile = tile_at(i, row);
					if BACKGROUND.has(tile):
						background = tile;
					i += 1;
				
				tile_place(column, row, background);
			"enemy1":
				newentity.image = Enemy1_Parameters.sprite;
				newentity.behaviour = Enemy1_Parameters.behaviour;
				newentity.speed = Enemy1_Parameters.speed;
				newentity.movementrange = Enemy1_Parameters.movementrange;
				newentity.waitdelayframes = Enemy1_Parameters.waitdelayframes;
				newentity.offset = Enemy1_Parameters.starting_offset;
				newentity.colour = Enemy1_Parameters.colour;
				
				newentity.position.x += Enemy1_Parameters.xoffset;
				newentity.position.y += Enemy1_Parameters.yoffset;
			"enemy2":
				newentity.image = Enemy2_Parameters.sprite;
				newentity.behaviour = Enemy2_Parameters.behaviour;
				newentity.speed = Enemy2_Parameters.speed;
				newentity.movementrange = Enemy2_Parameters.movementrange;
				newentity.waitdelayframes = Enemy2_Parameters.waitdelayframes;
				newentity.offset = Enemy2_Parameters.starting_offset;
				newentity.colour = Enemy2_Parameters.colour;
				
				newentity.position.x += Enemy2_Parameters.xoffset;
				newentity.position.y += Enemy2_Parameters.yoffset;
			"enemy3":
				newentity.image = Enemy3_Parameters.sprite;
				newentity.behaviour = Enemy3_Parameters.behaviour;
				newentity.speed = Enemy3_Parameters.speed;
				newentity.movementrange = Enemy3_Parameters.movementrange;
				newentity.waitdelayframes = Enemy3_Parameters.waitdelayframes;
				newentity.offset = Enemy3_Parameters.starting_offset;
				newentity.colour = Enemy3_Parameters.colour;
				
				newentity.position.x += Enemy3_Parameters.xoffset;
				newentity.position.y += Enemy3_Parameters.yoffset;
			"enemy4":
				newentity.image = Enemy4_Parameters.sprite;
				newentity.behaviour = Enemy4_Parameters.behaviour;
				newentity.speed = Enemy4_Parameters.speed;
				newentity.movementrange = Enemy4_Parameters.movementrange;
				newentity.waitdelayframes = Enemy4_Parameters.waitdelayframes;
				newentity.offset = Enemy4_Parameters.starting_offset;
				newentity.colour = Enemy4_Parameters.colour;
				
				newentity.position.x += Enemy4_Parameters.xoffset;
				newentity.position.y += Enemy4_Parameters.yoffset;
			"enemy5":
				newentity.image = Enemy5_Parameters.sprite;
				newentity.behaviour = Enemy5_Parameters.behaviour;
				newentity.speed = Enemy5_Parameters.speed;
				newentity.movementrange = Enemy5_Parameters.movementrange;
				newentity.waitdelayframes = Enemy5_Parameters.waitdelayframes;
				newentity.offset = Enemy5_Parameters.starting_offset;
				newentity.colour = Enemy5_Parameters.colour;
				
				newentity.position.x += Enemy5_Parameters.xoffset;
				newentity.position.y += Enemy5_Parameters.yoffset;
			"enemy6":
				newentity.image = Enemy6_Parameters.sprite;
				newentity.behaviour = Enemy6_Parameters.behaviour;
				newentity.speed = Enemy6_Parameters.speed;
				newentity.movementrange = Enemy6_Parameters.movementrange;
				newentity.waitdelayframes = Enemy6_Parameters.waitdelayframes;
				newentity.offset = Enemy6_Parameters.starting_offset;
				newentity.colour = Enemy6_Parameters.colour;
				
				newentity.position.x += Enemy6_Parameters.xoffset;
				newentity.position.y += Enemy6_Parameters.yoffset;
	
	if spawnentity:
		add_child(newentity);

func tile_isbackground(x:int, y:int) -> bool:
	var tile:Vector2i = tile_at(x, y);
	if BACKGROUND.has(tile):
		return true;
	
	return false;

func tile_at(x:int, y:int) -> Vector2i:
	return tilemap.get_cell_atlas_coords(0, Vector2i(x, y));
	
func tile_place(x:int, y:int, t:Vector2i):
	tilemap.set_cell(0, Vector2i(x, y), 0, t, 0);
