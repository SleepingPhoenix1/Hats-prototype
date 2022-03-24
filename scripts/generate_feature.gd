extends Node


func generate_tree_stem(tile_generator : Node2D, tilemap : TileMap ,chunk_coords : Vector2, x : int,y : int, _height : int):
	var height : int = _height
	var tiles_left : int = 0
	var chunk_above_current = find_chunk(Vector2(chunk_coords.x,chunk_coords.y-1), chunk_coords, tile_generator)
	for i in range(height):
		if y-i+1 >0:
			tilemap.set_cell(x,y-i, 2)
			tiles_left +=1
		else:
			if chunk_above_current:
				chunk_above_current.generate_tree(tile_generator, x,y+8-tiles_left, height-tiles_left)
				chunk_above_current.save()


func generate_tree_leaves(tile_generator, tilemap,chunk_coords, x,y, _width):
	var tiles_left_l : int = 0
	var tiles_left_r : int = 0
	
	var chunk_to_left = find_chunk(Vector2(chunk_coords.x-1,chunk_coords.y), chunk_coords, tile_generator)
	var chunk_to_right = find_chunk(Vector2(chunk_coords.x+1,chunk_coords.y), chunk_coords, tile_generator)
	
	for i in range(_width):
		if x-i >0:
			tilemap.set_cell(x-1,y, 3)
			tilemap.set_cell(x-2,y, 3)
			tiles_left_l += 1
		else:
			if chunk_to_left:
				chunk_to_left.generate_tree(tilemap, chunk_coords, x+16-tiles_left_l,y, _width-tiles_left_l)
				chunk_to_left.save()


func find_chunk(coords, chunk_coords, tile_generator):
	for i in tile_generator.get_children():
		if i.chunk_coords == coords:
			return i
