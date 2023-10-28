extends MarginContainer

@onready var essence = $VBox/Essence
@onready var spells = $VBox/Spells

var gambler = null
var kit = null
var cards = []


func set_attributes(input_: Dictionary) -> void:
	gambler = input_.gambler
	kit = input_.kit
	cards = input_.cards
	
	var input = {}
	input.proprietor = self
	input.type = "resource"
	input.subtype = "essence"
	input.value = calc_essence_stack()
	essence.set_attributes(input)


func calc_essence_stack() -> int:
	var stack = 0
	
	for card in cards:
		stack += card.get_rank()
	
	return stack


func switch_visible() -> void:
	visible = !visible
	
	for card in cards:
		card.set_selected(visible)


func init_spells() -> void:
	var n = 1
	var descriptions = []
	
	while n > descriptions.size():
		var description = get_rand_description(descriptions)
		descriptions.append(description)
	
	for description in descriptions:
		var input = {}
		input.sacrifice = self
		input.description = description

		var spell = Global.scene.spell.instantiate()
		spells.add_child(spell)
		spell.set_attributes(input)


func get_rand_description(descriptions_: Array) -> Dictionary:
	var description = init_aspect_tags()
	fill_aspect_points(description)
	return description


func init_aspect_tags() -> Dictionary:
	var description = {}
	var tags = {}
	tags.damage = {}
	tags.energy = {}
	var datas = []
	
	for tag in Global.dict.aspect.damage:
		if tag != "cohesion":
			tags.damage[tag] = Global.dict.inception[tag]
	
	for tag in Global.dict.aspect.energy:
		tags.energy[tag] = Global.dict.inception[tag]
	
	var data = {}
	data.type = "energy"
	data.subtype = Global.get_random_key(tags.energy)
	data.value = 0
	datas.append(data)
	
	data = {}
	data.type = "damage"
	data.subtype = "cohesion"
	data.value = 0
	datas.append(data)
	
	data = {}
	data.type = "damage"
	data.subtype = Global.get_random_key(tags.damage)
	data.value = 0
	datas.append(data)
	
	for data_ in datas:
		if !description.has(data_.type):
			description[data_.type] = {}
	
		if Global.dict.point.least.has(data_.subtype):
			data_.value = Global.dict.point.least[data_.subtype]
		
		description[data_.type][data_.subtype] = data_.value
	
	return description


func fill_aspect_points(description_: Dictionary) -> void:
	var points = {}
	points.current = 0
	points.limit = Global.dict.kit.count.points[cards.size()]
	
	for type in description_:
		for subtype in description_[type]:
			points.current += description_[type][subtype]
	
	while points.current < points.limit:
		points.current += 1
