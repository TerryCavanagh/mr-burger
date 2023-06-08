extends Node2D

var Sprite = null;
@export var image:String = "slime";

func _ready():
	Sprite = get_node("Animations/" + image);
	Sprite.visible = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func stopenemy():
	pass
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.killplayer();
		stopenemy();
		await get_tree().create_timer(1.0).timeout
		queue_free();
