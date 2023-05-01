extends Node

var timer_1_2:float = 0.0;
var timer_1_2_frame:int = 0;

var timer_1_4:float = 0.0;
var timer_1_4_frame:int = 0;

func _process(delta):
	timer_1_2 = timer_1_2 - delta;
	if timer_1_2 <= 0:
		timer_1_2 += 0.5;
		timer_1_2_frame = (timer_1_2_frame + 1) % 2;
		
	timer_1_4 = timer_1_4 - delta;
	if timer_1_4 <= 0:
		timer_1_4 += 0.25;
		timer_1_4_frame = (timer_1_4_frame + 1) % 2;
