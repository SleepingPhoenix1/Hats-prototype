extends Node2D

### BLOCK LIST HERE ###
var grass = preload("res://scenes/grass.tscn")
var dirt = preload("res://scenes/dirt.tscn")
var air = preload("res://scenes/air.tscn")



export var tile_WIDTH = 10
export var tile_HEIGHT = 20

export var tile_size = 16

var chunk_coords = Vector2()
var chunk_data = []

func _ready():
	pass

func generate_tile():
	for x in tile_WIDTH:
		for y in tile_HEIGHT:
			var rand = GlobalGen.openSimplexNoise.get_noise_1d(x+tile_WIDTH*chunk_coords.x)
			var rand2 = GlobalGen.openSimplexNoise2.get_noise_1d(x+tile_WIDTH*chunk_coords.x)
			var rand3 = GlobalGen.openSimplexNoise3.get_noise_1d(x+tile_WIDTH*chunk_coords.x)
			rand *=4
			rand += rand2
			rand -= rand3
			if ceil(rand*10) == global_position.y/tile_size + y:
				add_block(grass,x,y)
			elif ceil(rand*10) < global_position.y/ tile_size + y:
				add_block(dirt,x,y)
			#elif ceil(rand*10) > global_position.y/ tile_size + y:
			#	add_block(air,x,y)




func _process(delta):
	var mouse_pos = Vector2(int(get_global_mouse_position().x/ 16), int(get_global_mouse_position().y/ 16))
	
	if Input.is_action_pressed("left_click") and GlobalGen.current_chunk == chunk_coords:
		_on_tilemap_changed()
		add_block(grass,mouse_pos.x, mouse_pos.y)
	if Input.is_action_just_pressed("left_click"):
		save()
		
	elif Input.is_action_pressed("right_click"):
		add_block(air,mouse_pos.x, mouse_pos)
	

func start(_chunk_coords):
	chunk_coords = _chunk_coords
	$Coords.text = str(chunk_coords) 
	
	
	if GlobalGen.loaded_coords.find(_chunk_coords) == -1:
		GlobalGen.add_chunk(chunk_coords)
		generate_tile()
		save()
	else:
		if GlobalGen.retrive_chunk(chunk_coords) != null:
			if has_node("tile_manager"):
				remove_child($tile_manager)
			add_child(GlobalGen.retrive_chunk(chunk_coords).instance())
			#get_node("ColorRect").color = Color(.6,1,0,0.1)
	

func delete_chunk():
	queue_free()


func _on_tilemap_changed():
	save()

func save():
	for i in $tile_manager.get_children():
		i.owner = $tile_manager
	var tile = PackedScene.new()
	tile.pack(get_node("tile_manager"))
	GlobalGen.save_chunk(chunk_coords, tile)

func add_block(block,x,y):
	var block_instance = block.instance()
	block_instance.position.x = x * tile_size
	block_instance.position.y = y * tile_size
	$tile_manager.add_child(block_instance)



func get_mouse_pos():
	var chunk_pos = Vector2()
	chunk_pos.y = int(get_global_mouse_position().y/8)
	chunk_pos.x = int(get_global_mouse_position().x/8)
	if get_global_mouse_position().x < 0:
		chunk_pos.x -= 1
	if get_global_mouse_position().y < 0:
		chunk_pos.y -= 1
	return chunk_pos
