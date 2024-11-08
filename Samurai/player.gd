extends Area2D

signal hit

@export var speed = 400
var screen_size
var is_hurt = false

var Bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "idle"
	hide()
	$HurtTimer.connect("timeout", Callable(self, "_on_hurt_timeout"))
	$BulletTimer.connect("timeout", Callable(self, "on_bullet_timer_timeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_hurt:
		return # Stop movement and animation changes while hurt
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	elif velocity.length() == 0 and $AnimatedSprite2D.animation != "hurt" and 		$AnimatedSprite2D.animation != "attack":
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "idle"
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when a body enters the collision area of the player
func _on_body_entered(body):
	if not is_hurt:
		is_hurt = true
		$AnimatedSprite2D.animation = "hurt"
		$AnimatedSprite2D.play()
		$HurtTimer.start() # Start the timer for the hurt duration
		print("Touched")

func _on_hurt_timeout():
	is_hurt = false
	$AnimatedSprite2D.animation = "idle" # Go back to idle animation after hurt
	$AnimatedSprite2D.play()


func _on_body_exited(body):
	if not is_hurt:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "walk"

func on_bullet_timer_timeout():
	var bullet_right = Bullet.instantiate()
	bullet_right.position = position + Vector2(10,50)
	bullet_right.direction = 1
	get_parent().add_child(bullet_right)
	
	var bullet_left = Bullet.instantiate()
	bullet_left.position = position - Vector2(10,50)
	bullet_left.direction = -1
	get_parent().add_child(bullet_left)
