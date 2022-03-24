extends Node2D




export var tile_WIDTH :int = 10
export var tile_HEIGHT :int = 20

export var tile_size : int = 16

var chunk_coords : Vector2 = Vector2()
var chunk_data = []

func _ready():
	randomize()
	

func generate_tile():
	randomize()
	for x in tile_WIDTH:
		for y in tile_HEIGHT:
			var rand = GlobalGen.openSimplexNoise.get_noise_1d(x+tile_WIDTH*chunk_coords.x)
			var rand2 = GlobalGen.openSimplexNoise2.get_noise_1d(x+tile_WIDTH*chunk_coords.x)
			var rand3 = GlobalGen.openSimplexNoise3.get_noise_1d(x+tile_WIDTH*chunk_coords.x)
			rand *=4
			rand3 *=2
			rand += rand2
			rand -= rand3
			if ceil(rand*10) == global_position.y/tile_size + y:
				$tile_manager/TileMap.set_cell(x,y,0)
				var tree_fen : int = round(rand_range(0,12))
				if tree_fen == 1:
					GenFeature.generate_tree_stem(get_parent(),$tile_manager/TileMap, chunk_coords, x,y-1, 12)
			elif ceil(rand*10) < global_position.y/ tile_size + y:
				$tile_manager/TileMap.set_cell(x,y,1)
			#elif ceil(rand*10) > global_position.y/ tile_size + y:
			#	add_block(air,x,y)




func _process(delta):
	var mouse_pos = get_global_mouse_position()/8
	mouse_pos.x -= tile_WIDTH * chunk_coords.x
	mouse_pos.y -= tile_HEIGHT * chunk_coords.y
	
	if Input.is_action_pressed("left_click") and get_mouse_chunk() == chunk_coords:
		save()
		$tile_manager/TileMap.set_cellv(mouse_pos,2)
	elif Input.is_action_pressed("right_click")  and get_mouse_chunk() == chunk_coords:
		$tile_manager/TileMap.set_cellv(mouse_pos,-1)
		save()
		
	

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
				$tile_manager.free()
			add_child(GlobalGen.retrive_chunk(chunk_coords).instance())
			get_node("ColorRect").color = Color(.6,1,0,0.1)
	

func delete_chunk():
	queue_free()




func save():
	for i in $tile_manager.get_children():
		i.owner = $tile_manager
	var tile = PackedScene.new()
	tile.pack(get_node("tile_manager"))
	GlobalGen.save_chunk(chunk_coords, tile)



### OUTPUTS COORDS OF A CHUNK MOUSE IN ###
func get_mouse_chunk():
	var chunk_pos = Vector2()
	chunk_pos.y = int(get_global_mouse_position().y/ (tile_HEIGHT*tile_size))
	chunk_pos.x = int(get_global_mouse_position().x/ (tile_WIDTH*tile_size))
	if get_global_mouse_position().x < 0:
		chunk_pos.x -= 1
	if get_global_mouse_position().y < 0:
		chunk_pos.y -= 1
	return chunk_pos


func generate_tree(tile_generator, x,y, height):
	GenFeature.generate_tree_stem(tile_generator,$tile_manager/TileMap, chunk_coords, x,y,height)

func find_chunk(coords):
	for i in get_parent().get_children():
		if i.chunk_coords == coords:
			return i
