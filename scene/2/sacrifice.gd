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
	var description = {}
	var datas = []
	
	var data = {}
	data.type = "energy"
	data.subtype = "generation"
	data.value = 10
	datas.append(data)
	
	data = {}
	data.type = "damage"
	data.subtype = "cohesion"
	data.value = 9
	datas.append(data)
	
	data = {}
	data.type = "damage"
	data.subtype = "single"
	data.value = 16
	datas.append(data)
	
	for data_ in datas:
		if !description.has(data_.type):
			description[data_.type] = {}
		
		description[data_.type][data_.subtype] = data_.value
	
	return description
