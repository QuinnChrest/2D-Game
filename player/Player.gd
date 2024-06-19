extends CharacterBody2D
signal hit

const GRAVITY = 1000.0
const WALK_SPEED = 100
const VERTICAL = -325

var screen_size # Size of the game window.

var attack_complete = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
	elif Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	else:
		velocity.x = 0
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = VERTICAL
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") && attack_complete:
		$AnimatedSprite2D.animation = "Attack"
		attack_complete = false
	elif attack_complete:
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "Walk"
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = "Idle"
	
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	hide()
	hit.emit()
	$AnimatedSprite2D.stop()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

func _on_animated_sprite_2d_animation_finished():
	if($AnimatedSprite2D.animation == "Attack"):
		attack_complete = true
		$AnimatedSprite2D.animation = "Idle"
