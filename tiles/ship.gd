extends Sprite2D

func ship_generation(num: int):
	frame = num
	rotation_degrees = randi_range(0, 3) * 90
