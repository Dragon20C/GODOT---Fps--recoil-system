extends Spatial

var mouse_sensitivity = 0.06
var focus = true
var damage = 60
var recoil = false
var shoot = false
var recoil_amount = 1.5
var bullets = 0
var ROF = 0.15
var recoil_speed = 20

onready var camera = $Head/Camera
onready var famas = $Head/Hand/Famas/AnimationPlayer
onready var recoilmark = preload("res://RecoilMark.tscn")
onready var ray = $Head/Camera/RayCast
onready var firing_label = get_node("../UI/Control/FireLabel")
onready var Y_axis = get_node("../UI/Control/Y_axis")
onready var rate_of_fire = get_node("../UI/Control/Rate_of_fire")
onready var bullets_shot = get_node("../UI/Control/Bullets_shot")
onready var recoil_speedL = get_node("../UI/Control/Recoil_speed")
onready var recoil_amountL = get_node("../UI/Control/Recoil_amount")

func _input(event):
		if event is InputEventMouseMotion:
			rotation_degrees.y  -= event.relative.x * mouse_sensitivity
			$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x - event.relative.y * mouse_sensitivity, -90,90)
		
func _process(delta):
	firing_label.set_text("firing : " + str(shoot))
	Y_axis.set_text("Y_Axis : " + str($Head.rotation_degrees.x))
	rate_of_fire.set_text("Rate_of_fire : " + str(ROF))
	bullets_shot.set_text("Bullets_shot : " + str(bullets))
	recoil_speedL.set_text("Recoil_speed : " + str(recoil_speed))
	recoil_amountL.set_text("Recoil_amount : " + str(recoil_amount))
	
	print(rand_range(-5,5))
	
	if Input.is_action_just_pressed("ui_cancel"):
		focus = !focus
		get_tree().quit()
	if !focus:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("Clear"):
		bullets = 0
func _physics_process(delta):
	
	if Input.is_action_pressed("Aim"):
		$Head/Hand.transform.origin = $Head/Hand.transform.origin.linear_interpolate(Vector3(0,-0.509,-1.027),12 * delta)
		camera.fov = lerp(camera.fov, 80, 5 * delta)
	else:
		$Head/Hand.transform.origin = $Head/Hand.transform.origin.linear_interpolate(Vector3(0.971,-0.79,-1.027),12 * delta)
		camera.fov = lerp(camera.fov, 100, 5 * delta)
	if Input.is_action_pressed("Click") and !shoot:		
		shoot = true
		recoil = true
		bullets += 1
		famas.seek(0,true)
		famas.play("Firing")
		var instanced_mark = recoilmark.instance()
		if ray.is_colliding():
			ray.get_collider().add_child(instanced_mark)
			instanced_mark.global_transform.origin = ray.get_collision_point()
		yield(get_tree().create_timer(ROF), "timeout")
		shoot = false
		recoil = false
	if recoil:
		$Head.rotation_degrees.x = lerp($Head.rotation_degrees.x,$Head.rotation_degrees.x + recoil_amount, recoil_speed * delta)
		
