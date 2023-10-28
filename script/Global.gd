extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.element = ["aqua", "wind", "fire", "earth"]
	#arr.rank = [1, 2, 3, 4, 5, 6]#, 7, 8, 9]
	#arr.suit = ["aqua", "wind", "fire", "earth"]
	arr.rank = [1, 2, 3, 4]#, 5, 6]
	arr.suit = ["aqua", "wind", "fire", "earth"]
	arr.combination = ["duplet", "duplet_on_duplet", "triplet", "straight", "flush", "triplet_on_duplet", "quartet", "straight_on_flush", "roayl_flush", "quintet"]
	arr.kit = ["order", "unity", "harmony", "chaos"]


func init_num() -> void:
	num.index = {}
	num.index.card = 0
	
	num.altar = {}
	num.altar.r = 96


func init_dict() -> void:
	init_neighbor()
	init_card()
	init_spell()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_card() -> void:
	dict.card = {}
	dict.aspect = {}
	dict.aspect.energy = ["generation", "cost"]
	dict.aspect.damage = ["cohesion", "single", "blast", "wave"]
	dict.aspect.barrier = ["single", "wave"]
	dict.aspect.token = ["renovation", "battery"]
	
	dict.weight = {}
	dict.weight.attack = {}
	dict.weight.attack.energy = {}
	dict.weight.attack.energy.generation = 1.0/5
	dict.weight.attack.energy.cost = -1.0/5
	dict.weight.attack.damage = {}
	dict.weight.attack.damage.cohesion = 1.0/3
	dict.weight.attack.damage.single = 1.0/4
	dict.weight.attack.damage.blast = 1.0/2
	dict.weight.attack.damage.wave  = 1
	
	dict.weight.defense = {}
	dict.weight.defense.energy = {}
	dict.weight.defense.energy.generation = 1.0/6
	dict.weight.defense.energy.cost = -1.0/6
	dict.weight.defense.barrier = {}
	dict.weight.defense.barrier.single = 1.0/4
	dict.weight.defense.barrier.wave  = 1
	dict.weight.defense.buff = {}
	dict.weight.defense.buff.renovation = 2
	dict.weight.defense.buff.battery  = 3


func init_spell() -> void:
	dict.spell = {}
	
	dict.point = {}
	dict.point.least = {}
	dict.point.least.blast = 4
	dict.point.least.wave = 3
	dict.point.least.renovation = 2
	dict.point.least.battery = 3
	
	dict.tag = {}
	dict.tag.targets = {}
	dict.tag.targets.single = 1
	dict.tag.targets.blast = 2
	dict.tag.targets.wave = 4
	
	dict.kit = {}
	dict.kit.count = {}
	dict.kit.count.points = {}
	
	for _i in range(2, 6, 1):
		var n = pow(_i+1, 2)
		dict.kit.count.points[_i] = n
	
	dict.inception = {}
	dict.inception.generation = 5
	dict.inception.cost = 2
	
	dict.inception.cohesion = 9
	dict.inception.single = 7
	dict.inception.blast = 5
	dict.inception.wave  = 3
	
	dict.inception.renovation = 4
	dict.inception.battery  = 2


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.sketch = load("res://scene/0/sketch.tscn")
	
	scene.gambler = load("res://scene/1/gambler.tscn")
	
	scene.card = load("res://scene/2/card.tscn")
	#scene.resource = load("res://scene/2/resource.tscn")
	scene.sacrifice = load("res://scene/2/sacrifice.tscn")
	
	scene.spell = load("res://scene/3/spell.tscn")
	scene.aspect = load("res://scene/3/aspect.tscn")
	
	scene.pillar = load("res://scene/4/pillar.tscn")
	
	
	pass


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(32, 32)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	vec.size.suit = Vector2(32, 32)
	vec.size.aspect = Vector2(40, 40)
	vec.size.pillar = Vector2(64, 64)
	vec.size.altar = Vector2.ONE * num.altar.r * 2 + vec.size.pillar
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	color.indicator = {}
	
	color.card = {}
	color.card.selected = Color.from_hsv(160 / h, 0.6, 0.7)
	color.card.unselected = Color.from_hsv(0 / h, 0.4, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
