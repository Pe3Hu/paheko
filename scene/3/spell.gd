extends MarginContainer


@onready var generation = $VBox/Energy/Generation
@onready var cost = $VBox/Energy/Cost
@onready var aspects = $VBox/Aspects

var sacrifice = null


func set_attributes(input_: Dictionary) -> void:
	sacrifice = input_.sacrifice
	
	for subtype in Global.dict.aspect.energy:
		var input = {}
		input.spell = self
		input.type = "energy"
		input.subtype = subtype
		input.value = 0
		var aspect = get(input.subtype)
		aspect.set_attributes(input)
		aspect.hide_icons()
	
	init_aspects(input_.description)


func init_aspects(description_: Dictionary) -> void:
	for type in description_:
		for subtype in description_[type]:
			var input = {}
			input.spell = self
			input.type = type
			input.subtype = subtype
			input.value = description_[type][subtype]
			var aspect = null
			
			if !Global.dict.aspect.energy.has(input.subtype):
				aspect = Global.scene.aspect.instantiate()
				aspects.add_child(aspect)
				aspect.set_attributes(input)
			else:
				aspect = get(input.subtype)
				aspect.stack.set_number(description_[type][subtype])
				aspect.show_icons()

