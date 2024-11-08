extends Area2D

var speed = 500
var direction = 1

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * speed * delta
	
	if direction == -1:
		$Fireball.flip_h = true
	
	if abs(position.x) > 2000: 
		queue_free()
