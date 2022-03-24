extends Node



var loaded_coords = []
var data_in_chunk = []
var saved_chunks = []

var openSimplexNoise = OpenSimplexNoise.new()
var openSimplexNoise2 = OpenSimplexNoise.new()
var openSimplexNoise3 = OpenSimplexNoise.new()



func _ready():
	Engine.target_fps = 60
	
	
	randomize()
	openSimplexNoise.seed = 2
	openSimplexNoise.octaves = 3
	openSimplexNoise.period = 64
	openSimplexNoise.persistence = .6
	
	openSimplexNoise2.seed = 1
	openSimplexNoise2.octaves = 3
	openSimplexNoise2.period = 64
	openSimplexNoise2.persistence = .5
	
	openSimplexNoise2.seed = 5
	openSimplexNoise2.octaves = 3
	openSimplexNoise2.period = 32
	openSimplexNoise2.persistence = .7



func add_chunk(coords):
	loaded_coords.append(coords)
	data_in_chunk.append([])
	saved_chunks.append([])



func save_chunk(coords, chunk):
	saved_chunks[loaded_coords.find(coords)] = chunk

func save_data(data,coords):
	data_in_chunk[loaded_coords.find(coords)] = data

func retrive_data(coords):
	var data = data_in_chunk[loaded_coords.find(coords)]
	return data

func retrive_chunk(coords):
	var chunk = saved_chunks[loaded_coords.find(coords)]
	return chunk


