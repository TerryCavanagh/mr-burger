extends CharacterBody2D

@onready var Sprite = $AnimatedSprite2D;
@onready var camera:Camera2D = get_node("Camera2D");

@onready var Main = get_parent();
@onready var Game = Main.get_node("Game");

var room:Vector2i;

const SPEED = 90;
const JUMP_VELOCITY = -160
const GRAVITY = 22
const MAXFALLSPEED = 160;

var jumped:bool = false;

var movingdirection:int = 0;
var facingdirection:int = 1;

func _physics_process(_delta):
	var onfloor:bool = is_on_floor();
	
	if onfloor:
		jumped = false;
	else:
		velocity.y += GRAVITY
		if velocity.y > MAXFALLSPEED:
			velocity.y = MAXFALLSPEED;
	
	# Handle Jump.
	if Input.is_action_just_pressed("confirm") and onfloor:
		velocity.y = JUMP_VELOCITY
		jumped = true;
		onfloor = false;
		movingdirection = facingdirection;
	
	var pressleft:bool = Input.is_action_pressed("left");
	var pressright:bool = Input.is_action_pressed("right");
	
	if onfloor:
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
		if jumped:
			movingdirection = facingdirection;
		else:
			movingdirection = 0;
		
	if movingdirection != 0:
		velocity.x = movingdirection * SPEED
	else:
		velocity.x = 0
		
	#Animation
	if !onfloor:
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
	updatecamera();

func updatecamera():
	var newroom:Vector2i = position;
	@warning_ignore("integer_division")
	newroom.x = int(floor((int(position.x) - (int(position.x) % 160)) / 160));
	@warning_ignore("integer_division")
	newroom.y = int(floor((int(position.y) - (int(position.y) % 90)) / 90));
	
	if(newroom != room):
		room = newroom;
		changeroom();
	
	camera.limit_left = int(room.x) * 160;
	camera.limit_top = int(room.y) * 90;
	camera.limit_right = camera.limit_left + 160;
	camera.limit_bottom = camera.limit_top + 90;
	
func changeroom():
	print("changed to room " + str(room))

func collectcoin():
	Game.score += 100;
	Game.updateUI();

func collectdot():
	Game.score += 10;
	Game.updateUI();
