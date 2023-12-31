extends MarginContainer


@onready var available = $VBox/Cards/Available
@onready var discharged = $VBox/Cards/Discharged
@onready var broken = $VBox/Cards/Broken
@onready var hand = $VBox/Cards/Hand
@onready var sacrifices = $VBox/Sacrifices

var gambler = null


func set_attributes(input_: Dictionary) -> void:
	gambler = input_.gambler
	input_.gameboard = self
	
	init_starter_kit_cards()
	available.set_attributes(input_)
	discharged.set_attributes(input_)
	broken.set_attributes(input_)
	hand.set_attributes(input_)
	
	#next_turn()


func init_starter_kit_cards() -> void:
	for rank in Global.arr.rank:
		for suit in Global.arr.suit:
			var input = {}
			input.rank = rank
			input.suit = suit
		
			var card = Global.scene.card.instantiate()
			available.cards.add_child(card)
			card.set_attributes(input)
			card.gameboard = self
			card.area = available
			#print([card.get_index(), suit, rank])
	
	#print("___")
	#reshuffle_available()


func reshuffle_available() -> void:
	var cards = []
	
	while available.cards.get_child_count() > 0:
		var card = pull_random_card()
		cards.append(card)
	
	cards.shuffle()
	
	for card in cards:
		available.cards.add_child(card)


func pull_random_card() -> Variant:
	var cards = available.cards
	
	if cards.get_child_count() > 0:
		var card = cards.get_children().pick_random()
		cards.remove_child(card)
		return card
	
	print("error: empty available")
	return null


func pull_indexed_card(index_: int) -> Variant:
	var cards = available.cards
	
	if cards.get_child_count() > 0:
		for card in cards.get_children():
			#print(card.get_index_number(), " ", index_)
			if card.get_index_number() == index_:
				cards.remove_child(card)
				return card
	else:
		print("error: empty available")
	
		
	print("error: no card with index: ", index_)
	return null


func recharge_card() -> void:
	var options = []
	options.append_array(discharged.cards.get_children())
	
	if options.is_empty():
		for card in available.cards.get_children():
			if card.charge.current < card.charge.limit:
				options.append(card)
	
	if !options.is_empty():
		var card = options.pick_random()
		card.recharge()


func overload_card() -> void:
	var options = []
	options.append_array(available.cards.get_children())
	
	if !options.is_empty():
		var card = options.pick_random()
		card.overload()


func repair_card() -> void:
	var options = []
	
	options.append_array(broken.cards.get_children())
	
	if options.is_empty():
		for card in available.cards.get_children():
			if card.toughness.current < card.toughness.limit:
				options.append(card)
	
	if !options.is_empty():
		var card = options.pick_random()
		card.recharge()


func breakage_card() -> void:
	var options = []
	options.append_array(available.cards.get_children())
	
	if !options.is_empty():
		var card = options.pick_random()
		card.overload()


func next_turn() -> void:
	#reset_resources()
	
	hand.refill()
	#hand.apply()


func repair_all_cards() -> void:
	var spares = 0
	var cards = []
	cards.append_array(available.cards.get_children())
	cards.append_array(discharged.cards.get_children())
	cards.append_array(broken.cards.get_children())
	
	for card in cards:
		while card.toughness.current < card.toughness.limit: 
			card.repair()
			spares += 1
	
	print("spares: ", spares)


func recharge_all_cards() -> void:
	var energy = 0
	var cards = []
	cards.append_array(available.cards.get_children())
	cards.append_array(discharged.cards.get_children())
	
	for card in cards:
		while card.charge.current < card.charge.limit: 
			card.recharge()
			energy += 1
	
	print("energy: ", energy)


func resort_available() -> void:
	var datas = []
	
	while available.cards.get_child_count() > 0:
		var card = pull_random_card()
		var data = {}
		data.card = card
		data.index = card.get_index_number()
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.index < b.index)
	
	for data in datas:
		available.cards.add_child(data.card)
