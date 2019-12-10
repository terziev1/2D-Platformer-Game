
extends Area2D

const SPEED = 240
var velocity = Vector2()
var direction = 1
var type = 0
var time = 2
func _ready():
	pass
func set_type(t):
	type = t
func set_projectile_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	
	if time < 2:
		velocity.x = SPEED * delta * direction
		translate(velocity)
		$AnimatedSprite.play("projectile")
	time = time - delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Slash_body_entered(body):
	if "Snake" in body.name:
		body.dead()
	queue_free()

