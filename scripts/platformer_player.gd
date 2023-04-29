extends CharacterBody2D

@onready var Sprite = $AnimatedSprite2D;

const SPEED = 80;
const JUMP_VELOCITY = -160
const GRAVITY = 22

var coyotetime:float = 0;
var coyotelimit:float = 2;

var movingdirection:int = 0;
var facingdirection:int = 1;

func _physics_process(_delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY
		coyotetime -= 1;
	else:
		coyotetime = coyotelimit;
		
	var onfloor:bool = (is_on_floor() or coyotetime >= 0);
	
	# Handle Jump.
	if Input.is_action_just_pressed("confirm") and onfloor:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var pressleft:bool = Input.is_action_pressed("left");
	var pressright:bool = Input.is_action_pressed("right");
	
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
		
	if movingdirection != 0:
		velocity.x = movingdirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
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
		
	move_and_slide()
