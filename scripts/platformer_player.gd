extends CharacterBody2D

@onready var Sprite = $AnimatedSprite2D;
@onready var camera:Camera2D = get_node("Camera2D");

@onready var Main = get_parent();
@onready var Game = Main.get_node("Game");

const SPEED = 90;
const JUMP_VELOCITY = -160
const GRAVITY = 22
const MAXFALLSPEED = 160;
const WATERFALLSPEED = 60;
const LADDERSPEED = 50;
const SWIMMINGSPEED = 60;

const ROOMWIDTH = 160;
const ROOMHEIGHT = 80;

const ROOMFADETIME = 0.0;
const ROOMFADETIME_AFTERDEATH = 0.5;

var jumped:bool = false;

var touchingladder = false;
var movingdirection:int = 0;
var facingdirection:int = 1;
var initialy:float;

var state:String = "NORMAL";
var deathtimer:float = 0.0;
var fadeintime:float = 0.0;
var treadmillforce:float = 0.0;
var treadmills:Array = [];

var waterzones:Array = [];
var swimming:bool = false;
var inwater:bool = false;

var camerazones:Array = [];

var grabbedrope:bool = false;
var rope:Node2D = null;

var checkpoint:Vector2;

func _ready():
	movetofirstcheckpoint();
	state = "NORMAL";
	deathtimer = 0.0;
	fadeintime = 0.25;
	
func movetofirstcheckpoint():
	var checkpoints = get_tree().get_nodes_in_group("checkpoints");
	
	checkpoint = position; #fallback
	if checkpoints != null:
		if checkpoints.size() > 0:
			checkpoint = checkpoints[0].position;
			position = checkpoint;
	
	
func _physics_process(delta):
	if state == "REVIVE":
		deathtimer -= delta;
		if deathtimer <= 0:
			deathtimer = 0;
			state = "NORMAL";
			Game.cuttowhite();
	elif state == "NORMAL":
		if fadeintime > 0:
			fadeintime -= delta;
			if fadeintime <= 0:
				fadeintime = 0;
				Game.cuttowhite();
		
		var onfloor:bool = is_on_floor();
		checkinwater();
		
		swimming = false;
		
		if inwater:
			swimming = true;
			@warning_ignore("integer_division")
			velocity.y += GRAVITY / 3;
			
			if velocity.y > WATERFALLSPEED:
				velocity.y = WATERFALLSPEED;
		elif onfloor:
			jumped = false;
			velocity.y = 0;
		elif touchingladder:
			jumped = false;
			velocity.y = 0;
		elif grabbedrope:
			jumped = false;
			velocity.y = 0;
		else:
			velocity.y += GRAVITY
			if velocity.y > MAXFALLSPEED:
				velocity.y = MAXFALLSPEED;
		
		var pressleft:bool = Input.is_action_pressed("left");
		var pressright:bool = Input.is_action_pressed("right");
		var pressup:bool  = Input.is_action_pressed("up");
		var pressdown:bool = Input.is_action_pressed("down");
		var pressedjump:bool = Input.is_action_just_pressed("confirm");
		
		if BuildConfig.LEVELSKIP:
			if pressdown and pressup:
				victory();
		
		if Game.preventmovement:
			pressleft = false;
			pressright = false;
			pressup = false;
			pressdown = false;
			pressedjump = false;
			
		
		# Handle Jump
		if pressedjump:
			if (onfloor || touchingladder || grabbedrope) && !swimming:
				velocity.y = JUMP_VELOCITY
				initialy = position.y;
				jumped = true;
				onfloor = false;
				touchingladder = false;
				releaserope();
				movingdirection = facingdirection;
			elif swimming:
				@warning_ignore("integer_division")
				velocity.y = JUMP_VELOCITY / 2
				initialy = position.y;
				jumped = true;
				onfloor = false;
				touchingladder = false;
				releaserope();
				movingdirection = facingdirection;
				
		
		if !jumped && (touchingladder || grabbedrope):
			if pressup:
				velocity.y = -LADDERSPEED;
			elif pressdown:
				velocity.y = LADDERSPEED;
		
		if onfloor or touchingladder or grabbedrope or swimming:
			if pressleft and pressright:
				movingdirection = 0;
			elif pressleft:
				movingdirection = -1;
				facingdirection = -1;
			elif pressright:
				movingdirection = 1;
				facingdirection = 1;
			else:
				movingdirection = 0;
		else:
			#If you didn't jump, fall straight down
			if jumped and initialy > position.y:
				movingdirection = facingdirection;
			else:
				movingdirection = 0;
			
		if movingdirection != 0:
			velocity.x = movingdirection * SPEED
		else:
			velocity.x = 0
		
		updatetreadmillforces();
		if treadmillforce && onfloor:
			velocity.x += treadmillforce;
			
		#Animation
		if swimming and !onfloor:
			if facingdirection < 0:
				Sprite.play("swimming_left");
			else:
				Sprite.play("swimming_right");
		elif touchingladder || grabbedrope:
			if velocity.y:
				if facingdirection < 0:
					Sprite.play("climbing_left");
				else:
					Sprite.play("climbing_right");
			else:
				if facingdirection < 0:
					Sprite.play("idle_climbing_left");
				else:
					Sprite.play("idle_climbing_right");
		elif !onfloor:
			if facingdirection < 0:
				Sprite.play("jump_left");
			else:
				Sprite.play("jump_right");
		else:
			if movingdirection == 0:
				if facingdirection < 0:
					Sprite.play("idle_left");
				elif facingdirection > 0:
					Sprite.play("idle_right");
			else:
				if facingdirection < 0:
					Sprite.play("left");
				elif facingdirection > 0:
					Sprite.play("right");
		
		move_and_slide();
	elif state == "DEATH":
		deathtimer -= delta;
		if deathtimer <= 0:
			deathtimer = 0;
			revive();

func movecamera(zone:Rect2):
	if(zone.position.x != camera.limit_left or zone.position.y != camera.limit_top):
		if ROOMFADETIME > 0.0:
			Game.cuttoblack();
			fadeintime = ROOMFADETIME;
		camera.limit_left = int(zone.position.x);
		camera.limit_top = int(zone.position.y);
		camera.limit_right = int(zone.position.x + zone.size.x);
		camera.limit_bottom = int(zone.position.y + zone.size.y);

func addcamerazone(zone):
	if !camerazones.has(zone):
		camerazones.push_back(zone);
	
	if camerazones.size() > 0:
		movecamera(camerazones[camerazones.size() - 1])

func removecamerazone(zone):
	if camerazones.has(zone):
		camerazones.erase(zone);
	
	if camerazones.size() > 0:
		movecamera(camerazones[camerazones.size() - 1])

func collectcoin():
	GameGlobal.score += 100;
	Game.updateUI();

func collectkey():
	GameGlobal.keys += 1;
	Game.updateUI();

func collectdot():
	GameGlobal.score += 10;
	Game.updateUI();
	
func killplayer():
	if state == "NORMAL":
		state = "DEATH";
		deathtimer = 1;
		
		if facingdirection < 0:
			Sprite.play("death_left");
		elif facingdirection > 0:
			Sprite.play("death_right");

func revive():
	Game.cuttoblack();
	
	GameGlobal.lives -= 1;
	Game.updateUI();
	
	if GameGlobal.lives <= 0:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/Gameover.tscn");
	else:
		Game.revive();
		position = checkpoint;
		movingdirection = 0;
		facingdirection = 1;
		initialy = position.y;
		velocity.x = 0; 
		velocity.y = 0
		Sprite.play("idle_right");
		jumped = true;
		state = "REVIVE";
		deathtimer = ROOMFADETIME_AFTERDEATH;

func activatecheckpoint(pos):
	checkpoint = pos;

func updatetreadmillforces():
	if treadmills.size() > 0:
		treadmillforce = treadmills[treadmills.size() - 1].force * treadmills[treadmills.size() - 1].direction;
		return;
		
	treadmillforce = 0;
	
func addtreadmill(treadmill):
	if !treadmills.has(treadmill):
		treadmills.push_back(treadmill);
	
func removetreadmill(treadmill):
	if treadmills.has(treadmill):
		treadmills.erase(treadmill);

func addwaterzone(waterzone):
	if !waterzones.has(waterzone):
		waterzones.push_back(waterzone);
	
func removewaterzone(waterzone):
	if waterzones.has(waterzone):
		waterzones.erase(waterzone);

func checkinwater():
	if waterzones.size() > 0:
		inwater = true;
		return;
		
	inwater = false;

func grabrope(_rope):
	grabbedrope = true;
	rope = _rope
	
func releaserope():
	grabbedrope = false;
	rope = null

func victory():
	Game.cuttoblack();
	
	await get_tree().create_timer(0.5).timeout
	
	#print("level just finished was " + World.nextstage)
	if World.nextstage == "delivery":
		World.generateburger();
		World.decaywall();
		World.placewall();
		
		World.placerandomstage();
		World.placerandomstage();
	elif World.nextstage == "burger":
		if GameGlobal.ordernumber > 1:
			World.generatedelivery();
			World.decaywall();
			World.placewall();
		
			World.placerandomstage();
			World.placerandomstage();
		
	get_tree().change_scene_to_file("res://scenes/level_select.tscn");
	
	#Game.loadlevel("forest", "stage1");
	#Game.loadlevel("delivery", "stage1");
	#movetofirstcheckpoint();
	#state = "NORMAL";
	#deathtimer = 0.0;
	#await get_tree().create_timer(0.1).timeout
	#Game.cuttowhite();
