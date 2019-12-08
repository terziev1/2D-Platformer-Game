extends KinematicBody2D
const SPEED = 20
const GRAVITY = 20
const FLOOR = Vector2(0,-1)

var v = Vector2()
var d = 1
var is_dead = false

func _physics_process(delta):
	if is_dead == false:
		v.x = SPEED * d
		v.y += GRAVITY
		$AnimatedSprite.play("move")
	
		v = move_and_slide(v, FLOOR)
		
		if d == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		if is_on_wall():
			d = d * -1
			$RayCast2D.position.x  *= -1
		
		if $RayCast2D.is_colliding() == false:
			d = d * -1
			$RayCast2D.position.x  *= -1
		
func dead():
	is_dead = true
	v = Vector2()
	v.y = 300
	hide()
	queue_free()