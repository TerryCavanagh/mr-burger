extends Node2D

@export var ropelength:int = 48;

#number between 0-36000
@export var angle:int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#angle = int(floor((angle + (delta * 1000)))) % 36000;
	queue_redraw()
	
func _draw():
	@warning_ignore("integer_division")
	var dirx = cos((angle / 100) * (PI / 180)) * ropelength;
	@warning_ignore("integer_division")
	var diry = sin((angle / 100) * (PI / 180)) * ropelength;
	
	draw_line(Vector2(0, 0), Vector2(dirx, diry), Palette.WHITE, 2, false);

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.grabrope(self);

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.releaserope();
