extends MarginContainer

@onready var essence = $VBox/Essence

var hand = null
var cards = []


func set_attributes(input_: Dictionary) -> void:
	hand = input_.hand
	cards = input_.cards
	
	var input = {}
	input.proprietor = self
	input.resource = "essence"
	input.stack = calc_essence_stack()
	essence.set_attributes(input)


func calc_essence_stack() -> int:
	var stack = 0
	
	for card in cards:
		stack += card.get_rank()
	
	return stack


func switch_visible() -> void:
	visible = !visible
	
	for card in cards:
		card.bg.visible = !visible

