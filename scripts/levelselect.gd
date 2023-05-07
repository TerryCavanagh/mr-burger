extends Node2D

@onready var UI = get_node("UI");
@onready var levelgrid = [
	UI.get_node("x0y0"), UI.get_node("x1y0"), UI.get_node("x2y0"), UI.get_node("x3y0"), 
	UI.get_node("x0y1"), UI.get_node("x1y1"), UI.get_node("x2y1"), UI.get_node("x3y1"),  
	UI.get_node("x0y2"), UI.get_node("x1y2"), UI.get_node("x2y2"), UI.get_node("x3y2"), 
	UI.get_node("x0y3"), UI.get_node("x1y3"), UI.get_node("x2y3"), UI.get_node("x3y3")
]
@onready var cursor = UI.get_node("cursor");
@onready var playerimage = UI.get_node("playerimage");
@onready var movingarrow = UI.get_node("movingarrow");
@onready var FadeLayer = UI.get_node("FadeLayer");
var movingdirection:String = "none";
var movevector:Vector2;

const GRIDXOFFSET:int = 50;
const GRIDYOFFSET:int = 15;
const GRIDSPACING:int = 20;

var state:String = "select";
var timer:float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	settolevelgrid();
	movecursor(World.playerposition);
	movingdirection = "none";
	
	if World.placementstage.size() > 0:
		cursor.visible = false;
		state = "placement";
		timer = 2.0;
	else:
		state = "select"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pressleft:bool = Input.is_action_pressed("left");
	var pressright:bool = Input.is_action_pressed("right");
	var pressup:bool = Input.is_action_pressed("up");
	var pressdown:bool = Input.is_action_pressed("down");
	var pressedjump:bool = Input.is_action_just_pressed("confirm");
	
	match state:
		"placement":
			timer -= delta;
			if timer <= 0:
				timer = 0;
				var i:int = 0;
				while i < World.placementstage.size():
					World.levelgrid[gridindex(World.placementposition[i])] = World.placementstage[i];
					levelgrid[gridindex(World.placementposition[i])].play(World.placementstage[i]);
					i += 1;
				
				World.clearplacements();
				state = "select";
			else:
				var i:int = 0;
				while i < World.placementstage.size():
					if Timers.timer_1_4_frame == 0:
						levelgrid[gridindex(World.placementposition[i])].play("clear");
					else:
						levelgrid[gridindex(World.placementposition[i])].play(World.placementstage[i]);
					i += 1;
		"startlevel_wait":
			if timer > 0:
				timer -= delta;
				if timer <= 0:
					timer = 0;
					FadeLayer.visible = true;
					
					var stagetype:String = World.levelgrid[gridindex(World.cursorposition)];
					levelgrid[gridindex(World.playerposition)].play("clear");
					
					if movevector.x < 0:
						World.playerposition.x -= 1;
					elif movevector.x > 0:
						World.playerposition.x += 1;
					
					if movevector.y < 0:
						World.playerposition.y -= 1;
					elif movevector.y > 0:
						World.playerposition.y += 1;
					
					levelgrid[gridindex(World.playerposition)].play("clear");
					startlevel(stagetype);
					state = "startlevel";
		"moveplayer":
			playerimage.position += movevector;
			timer -= 1;
			
			if timer < 0:
				state = "startlevel_wait";
				timer = 0.5;
		"moveplayer_clear":
			playerimage.position += movevector;
			timer -= 1;
			
			if timer < 0:
				if movevector.x < 0:
					World.playerposition.x -= 1;
				elif movevector.x > 0:
					World.playerposition.x += 1;
				
				if movevector.y < 0:
					World.playerposition.y -= 1;
				elif movevector.y > 0:
					World.playerposition.y += 1;
				
				levelgrid[gridindex(World.playerposition)].play("clear");
				
				state = "select";
		"selectedclear":
			state = "moveplayer_clear";
			match movingdirection:
				"up":
					movevector = Vector2i(0, -2);
				"down":
					movevector = Vector2i(0, 2);
				"left":
					movevector = Vector2i(-2, 0);
				"right":
					movevector = Vector2i(2, 0);
			timer = 9;
			
			World.levelgrid[gridindex(World.playerposition)] = "clear";
			levelgrid[gridindex(World.playerposition)].play("clear");
			playerimage.position = getscreenpositionfromgrid(World.playerposition);
			playerimage.visible = true;
			cursor.visible = true;
			movingdirection = "none";
		"selected":
			cursor.visible = true;
			
			if timer > 0:
				timer -= delta;
				if timer <= 0:
					state = "moveplayer";
					match movingdirection:
						"up":
							movevector = Vector2i(0, -2);
						"down":
							movevector = Vector2i(0, 2);
						"left":
							movevector = Vector2i(-2, 0);
						"right":
							movevector = Vector2i(2, 0);
					timer = 9;
					
					World.levelgrid[gridindex(World.playerposition)] = "clear";
					levelgrid[gridindex(World.playerposition)].play("clear");
					playerimage.position = getscreenpositionfromgrid(World.playerposition);
					playerimage.visible = true;
					cursor.visible = true;
		"select":
			var attempt:bool = true;
			if pressup:
				if World.stageat(World.playerposition + Vector2i(0, -1)) != "wall":
					movecursor(World.playerposition + Vector2i(0, -1));
					movingdirection = "up";
				else:
					attempt = false;
			if pressdown:
				if World.stageat(World.playerposition + Vector2i(0, 1)) != "wall":
					movecursor(World.playerposition + Vector2i(0, 1));
					movingdirection = "down";
				else:
					attempt = false;
			if pressleft:
				if World.stageat(World.playerposition + Vector2i(-1, 0)) != "wall":
					movecursor(World.playerposition + Vector2i(-1, 0));
					movingdirection = "left";
				else:
					attempt = false;
			if pressright:
				if World.stageat(World.playerposition + Vector2i(1, 0)) != "wall":
					movecursor(World.playerposition + Vector2i(1, 0));
					movingdirection = "right";
				else:
					attempt = false;
			
			if !attempt:
				movecursor(World.playerposition);
				movingdirection = "none";
				
			if pressedjump:
				if World.cursorposition != World.playerposition:
					if World.levelgrid[gridindex(World.cursorposition)] == "clear":
						state = "selectedclear";
					else:
						state = "selected";
						timer = 0.2;
	
	updatemovingdirection();
	
func updatemovingdirection():
	match movingdirection:
		"none":
			movingarrow.visible = false;
		"up":
			movingarrow.position = cursor.position + Vector2(0, 14);
			movingarrow.play(movingdirection);
			movingarrow.visible = true;
		"down":
			movingarrow.position = cursor.position + Vector2(0, -14);
			movingarrow.play(movingdirection);
			movingarrow.visible = true;
		"left":
			movingarrow.position = cursor.position + Vector2(11, 0);
			movingarrow.play(movingdirection);
			movingarrow.visible = true;
		"right":
			movingarrow.position = cursor.position + Vector2(-11, 0);
			movingarrow.play(movingdirection);
			movingarrow.visible = true;
			

func settolevelgrid():
	var j:int = 0;
	while j < World.HEIGHT:
		var i:int = 0;
		while i < World.WIDTH:
			levelgrid[i + (j * World.WIDTH)].position = Vector2(GRIDXOFFSET + (GRIDSPACING * i), GRIDYOFFSET + (GRIDSPACING * j));
			levelgrid[i + (j * World.WIDTH)].play(World.levelgrid[i + (j * World.WIDTH)]);
			i += 1;
		j += 1;
	
	levelgrid[gridindex(World.playerposition)].play("player");

func getscreenpositionfromgrid(gridpos:Vector2i) -> Vector2:
	return Vector2(GRIDXOFFSET + (gridpos.x * GRIDSPACING), GRIDYOFFSET + (gridpos.y * GRIDSPACING));

func movecursor(gridpos:Vector2i):
	World.cursorposition = gridpos;
	cursor.visible = true;
	cursor.position = getscreenpositionfromgrid(gridpos);

func startlevel(stagetype):
	World.nextstage = stagetype;
	World.nextlevel = "stage1";
	get_tree().change_scene_to_file("res://scenes/Platformer.tscn");

func gridindex(v:Vector2i) -> int:
	return v.x + (v.y * World.WIDTH);
