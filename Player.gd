extends KinematicBody2D

const SPEED = 100
const GRAVITY = 20
const JUMP_POWER = -300
const FLOOR = Vector2(0,-1)
const SLASH = preload("res://Slash.tscn")
const SHOOT = preload("res://Shoot.tscn")

var velocity = Vector2()
var on_ground = true
var is_attacking = false
var jump_count = 0
var tmp_type  = 1
func jump():
	if Input.is_action_just_pressed("ui_accept"):
		if jump_count < 2:
			on_ground = false
			velocity.y = JUMP_POWER
			if jump_count > 1:
				$AnimatedSprite.play("jump2")
			else:
				$AnimatedSprite.play("jump")
			jump_count += 1
	if is_on_floor():
		if on_ground == false:
			on_ground = true
			jump_count = 0
	else:
		if on_ground == true:
			on_ground = false
			jump_count = 1
		if  velocity.y <  0 && is_attacking == false && jump_count == 1:
			$AnimatedSprite.play("jump")
		elif velocity.y >  0  && is_attacking == false && jump_count > 1:
			$AnimatedSprite.play("jump2")
		elif velocity.y >  0  && is_attacking == false:
			$AnimatedSprite.play("fall")

func move():
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		if is_attacking == false && on_ground:
			$AnimatedSprite.play("run")

		
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		if is_attacking == false && on_ground == true:
			$AnimatedSprite.play("run")

	else:
		velocity.x = 0
		if on_ground == true && is_attacking == false:
			$AnimatedSprite.play("idle")

			
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

func attack():
	
	if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
		is_attacking = true
		if tmp_type != -1:
			var slash = SLASH.instance()
			$AnimatedSprite.play("attack3")
			get_parent().add_child(slash)
			slash.position = $Position2D.global_position
			if sign($Position2D.position.x) == 1:
				slash.set_projectile_direction(1)
			else:
				slash.set_projectile_direction(-1)
		else:
			var shoot = SHOOT.instance()
			$AnimatedSprite.play("shoot")
			get_parent().add_child(shoot)
			shoot.position = $Position2D.global_position
			if sign($Position2D.position.x) == 1:
				shoot.set_projectile_direction(1)
			else:
				shoot.set_projectile_direction(-1)
		

			
	elif Input.is_action_just_pressed("ui_down"):
		tmp_type *= -1

func _physics_process(delta):
	attack()
	jump()
	move()

func _on_AnimatedSprite_animation_finished():
	is_attacking = false
