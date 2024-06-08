extends CharacterBody2D
signal hit

const GRAVITY = 400.0
const WALK_SPEED = 100
const VERTICAL = -200

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

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
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "Idle"
		
	

func _on_body_entered(body):
	hide()
	hit.emit()
	$AnimatedSprite2D.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
