extends KinematicBody2D

const SPEED = 80
const GRAVITY = 20
const JUMP_POWER = -300
const FLOOR = Vector2(0,-1)
const SLASH = preload("res://Slash.tscn")

var velocity = Vector2()
var on_ground = false
var is_attacking = false

var jump_count = 0

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		if is_attacking == false:
			velocity.x = SPEED
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("run")
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		
	elif Input.is_action_pressed("ui_left"):
		if is_attacking == false:
			velocity.x = -SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
	else:
		velocity.x = 0
		if on_ground == true && is_attacking == false:
			$AnimatedSprite.play("idle")
	
	
	if Input.is_action_just_pressed("ui_accept"):
		if jump_count < 2:
			jump_count += 1
			velocity.y = JUMP_POWER
			on_ground = false
			$AnimatedSprite.play("jump")
			
		#if on_ground:
		#	velocity.y = JUMP_POWER
		#	$AnimatedSprite.play("jump")

		
	if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
		is_attacking = true
		$AnimatedSprite.play("attack")
		var slash = SLASH.instance()
		if sign($Position2D.position.x) == 1:
			slash.set_projectile_direction(1)
		else:
			slash.set_projectile_direction(-1)
			
		get_parent().add_child(slash)
		slash.position = $Position2D.global_position
		
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		if on_ground == false:
			on_ground = true
			jump_count = 0
	else:
		if on_ground == true:
			on_ground = false
			jump_count = 1
	
	velocity = move_and_slide(velocity, FLOOR)

func _on_AnimatedSprite_animation_finished():
	is_attacking = false
