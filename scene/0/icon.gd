extends MarginContainer


@onready var number = $Number
@onready var tr = $TextureRect

var type = null
var subtype = null


func set_attributes(input_: Dictionary) -> void:
	type  = input_.type
	subtype  = input_.subtype
	
	set_font_size(16)
	custom_minimum_size = Vector2(Global.vec.size.letter)
	var path = "res://asset/png/icon/"
	var types = ["suit", "resource", "damage", "energy", "token"]
	
	if types.has(type):
		custom_minimum_size = Vector2(Global.vec.size.icon)
		path += type + "/" + subtype + ".png"
		tr.texture = load(path)
	
	match type:
		"number":
			custom_minimum_size = Vector2(Global.vec.size.number)
			tr.visible = false
			number.visible = true
			set_number(subtype)
		"blank":
			custom_minimum_size = Vector2(Global.vec.size.number)


func get_number() -> int:
	return subtype


func change_number(value_) -> void:
	subtype += value_
	var value = subtype + 0
	
	match typeof(value_):
		TYPE_INT:
			var suffix = ""
			
			while value >= 1000:
				value /= 1000
				suffix = Global.dict.thousand[suffix]
			
			number.text = str(value) + suffix
		TYPE_FLOAT:
			value = snapped(value, 0.01)
			number.text = str(value)


func set_number(value_) -> void:
	subtype = value_
	var value = subtype + 0
	
	match typeof(value_):
		TYPE_INT:
			var suffix = ""
			
			while value >= 1000:
				value /= 1000
				suffix = Global.dict.thousand[suffix]
			
			number.text = str(value) + suffix
		TYPE_FLOAT:
			value = snapped(value, 0.01)
			number.text = str(value)


func set_font_size(font_size_: int) -> void:
	number.set("theme_override_font_sizes/font_size", font_size_)


func add_tab_to_number() -> void:
	number.text = str("
" + str(subtype))
