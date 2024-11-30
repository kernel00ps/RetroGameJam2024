extends Node

@export var obstacle_scene : PackedScene
@export var pickup_energy_scene: PackedScene

const OBSTACLE_DELAY: int = 100
const OBSTACLE_RANGE: int = 200

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 1
var viewport_size: Vector2
var viewport_width: float
var viewport_height: float
var ground_height : int

var obstacle_list: Node2D
var pickup_energy_list: Node2D

func _ready() -> void:
	obstacle_list = get_node("Obstacles")
	pickup_energy_list = get_node("PickUpEnergies")
	viewport_size = get_viewport().get_visible_rect().size
	viewport_width = viewport_size.x
	viewport_height = viewport_size.y
	new_game()
	
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	
func _input(event):
	if(!game_over && Input.is_key_pressed(KEY_SPACE)):
		if(!game_running):
			start_game()
					
func start_game():
	game_running = true

func generate_obstacles() -> void:
	remove_offscreen_obstacles()
	
	var obstacle: Obstacle = obstacle_scene.instantiate()
	obstacle.position.x = viewport_width + OBSTACLE_DELAY
	obstacle.position.y = randi_range(-OBSTACLE_RANGE, OBSTACLE_RANGE)
	obstacle.hit_obstable.connect(player_hit_obstacle)
	obstacle_list.add_child(obstacle)
	 
func remove_offscreen_obstacles() -> void:
	for obstacle in obstacle_list.get_children():
		if obstacle.position.x < -OBSTACLE_DELAY:
			obstacle.queue_free()
	
func generate_pickup_energy() -> void:
	remove_offscreen_pickups()
	
	var pickup_energy: PickupEnergy = pickup_energy_scene.instantiate()
	pickup_energy.position.x = viewport_width + OBSTACLE_DELAY
	pickup_energy.position.y = randi_range(-OBSTACLE_RANGE, OBSTACLE_RANGE)
	pickup_energy.picked_up.connect(player_picked_up_energy)
	pickup_energy_list.add_child(pickup_energy)

func remove_offscreen_pickups() -> void:
	for pickup in pickup_energy_list.get_children():
		if pickup.position.x < -OBSTACLE_DELAY:
			pickup.queue_free()

func _on_obstacle_timer_timeout() -> void:
	generate_obstacles()
	pass

func player_hit_obstacle() -> void:
	pass

func player_picked_up_energy() -> void:
	print("Signal recieved in player")
	Globals.fuel_modifier = Globals.PICKUP_VALUE

func _on_energy_timer_timeout() -> void:
	generate_pickup_energy()
	print("ener")
