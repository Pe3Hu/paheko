extends MarginContainer


@onready var index = $VBox/Index
@onready var couple = $VBox/Couple
@onready var chargeIcon = $VBox/Charge/Icon
@onready var chargeValue = $VBox/Charge/Value
@onready var toughnessIcon = $VBox/Toughness/Icon
@onready var toughnessValue = $VBox/Toughness/Value
@onready var bg = $BG

var area = null
var gameboard = null
var charge = {}
var toughness = {}


func set_attributes(input_: Dictionary) -> void:
	#var description = Global.dict.card.index[input_.index]
	index.text = str(Global.num.index.card)
	Global.num.index.card += 1
	charge.limit = 1
	charge.current = charge.limit
	toughness.limit = 1
	toughness.current = toughness.limit
	
	set_icons(input_)
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func set_icons(input_: Dictionary) -> void:
	var input = {}
	input.type = "number"
	input.subtype = charge.current
	chargeValue.set_attributes(input)
	
	input.subtype = toughness.current
	toughnessValue.set_attributes(input)

	input.type = "suit"
	
	input.type = "resource"
	input.subtype = "energy"
	chargeIcon.set_attributes(input)
	
	input.subtype = "spares"
	toughnessIcon.set_attributes(input)
	
	input.proprietor = self
	input.type = "suit"
	input.subtype = input_.suit
	input.value = input_.rank
	couple.set_attributes(input)


func get_suit() -> String:
	return couple.title.subtype


func get_rank() -> int:
	return couple.stack.get_number()


func get_index_number() -> int:
	return int(index.text)


func set_selected(selected_: bool) -> void:
	var style = bg.get("theme_override_styles/panel")
	
	match selected_:
		true:
			style.bg_color = Global.color.card.selected
			pass
		false:
			style.bg_color = Global.color.card.unselected
