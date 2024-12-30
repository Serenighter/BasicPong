extends Node2D

"""
kod jest up-to-date,
z funkcjami position i global_position
odpowiadającymi za sczytywanie i wczytywanie
pozycji elementu
"""
# Deklaracja zmiennych globalnych dla klasy
var screen_size
var ball_speed = 90 # Szybkość piłki
var direction = Vector2(-1, 0) # Kierunek piłki
const PAD_SPEED = 150
var pad_size


func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)


func _process(delta):
	var ball_pos = get_node("ball").position  
	var left_rect = Rect2(get_node("left").global_position - pad_size / 2, pad_size)
	var right_rect = Rect2(get_node("right").global_position - pad_size / 2, pad_size)
	ball_pos += direction * ball_speed * delta

	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y

	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		ball_speed *= 1.1
		direction.y = randf() * 2.0 - 1
		direction = direction.normalized()

	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size * 0.5
		ball_speed = 80
		direction = Vector2(-1, 0)

	get_node("ball").position = ball_pos

	# poruszanie się lewej platformy
	var left_pos = get_node("left").global_position

	if (left_pos.y > 0 and Input.is_action_pressed("left_move_UP")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_DOWN")):
		left_pos.y += PAD_SPEED * delta

	get_node("left").global_position = left_pos

	# poruszanie się prawej platformy
	var right_pos = get_node("right").global_position

	if (right_pos.y > 0 and Input.is_action_pressed("right_move_UP")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_DOWN")):
		right_pos.y += PAD_SPEED * delta

	get_node("right").global_position = right_pos
