extends Node3D

@export var signal_bus: BattleSignalBus
@export var battle_actor_parent: BattleActorParent

const CHAR_TEMPLATE_TEST_KNIGHT = preload("uid://7shyl1f1bsl8")
const CHAR_TEMPLATE_TEST_CLERIC = preload("uid://d4catqutnh062")
const CHAR_TEMPLATE_TEST_MAGE = preload("uid://dug65flahi15d")
const CHAR_TEMPLATE_TEST_ROGUE = preload("uid://b5ny0x0krff5k")

const CHAR_TEMPLATE_TEST_DRAGON = preload("uid://db8t4d6h6vcpg")
const CHAR_TEMPLATE_TEST_GOBLIN = preload("uid://cnh7qqxoe4dee")
const CHAR_TEMPLATE_TEST_GOLEM = preload("uid://crv27bbjptr4j")
const CHAR_TEMPLATE_TEST_WRAITH = preload("uid://u3gp4un2ewuw")

var test_formation_scene: PackedScene = preload("uid://dacrhvys5oaud")

## Starts the scene

func _ready() -> void:
	## TODO: Run cleanup before starting new command
	signal_bus.all_skill_instances_finished.connect(_do_turn)
	start_battle()

func start_battle() -> void:

	## TODO: Get test characters and formations from outside
	
	var player_formation: Formation = test_formation_scene.instantiate()
	var enemy_formation: Formation = test_formation_scene.instantiate()
	
	battle_actor_parent.add_formations(player_formation, enemy_formation)

	var player_characters: Array[CharacterState] = [
		CharacterState.from_template(CHAR_TEMPLATE_TEST_KNIGHT),
		CharacterState.from_template(CHAR_TEMPLATE_TEST_CLERIC),
		CharacterState.from_template(CHAR_TEMPLATE_TEST_MAGE),
		CharacterState.from_template(CHAR_TEMPLATE_TEST_ROGUE),
	]
	var enemy_characters: Array[CharacterState] = [
		CharacterState.from_template(CHAR_TEMPLATE_TEST_DRAGON),
		CharacterState.from_template(CHAR_TEMPLATE_TEST_GOBLIN),
		CharacterState.from_template(CHAR_TEMPLATE_TEST_GOLEM),
		CharacterState.from_template(CHAR_TEMPLATE_TEST_WRAITH),
	]


	battle_actor_parent.create_actors(player_characters, enemy_characters)

	await signal_bus.all_actors_entered_battle

	_do_turn()

	## TODO: Await game end command

func _do_turn() -> void:
	## TODO: Pre/Post turn character stuff
	signal_bus.request_next_turn.emit()
