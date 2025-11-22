extends Node3D
class_name BattleActorParent


## Creates and manages battle actors in the scene. Determines turn order and tells actors
## When to go


@export var signal_bus: BattleSignalBus = null
# @export var actor_controller: ActorController = null
@export var battle_context: BattleContext = null

var _player_formation: Formation = null
var _enemy_formation: Formation = null

var _awaiting_actors: Array[BattleActor] = []


func add_formations(player_formation: Formation, enemy_formation: Formation) -> void:
	_player_formation = player_formation
	add_child(_player_formation)
	_enemy_formation = enemy_formation
	_enemy_formation.rotation_degrees.y += 180
	add_child(_enemy_formation)

func create_actors(player_characters: Array[CharacterState], enemy_characters: Array[CharacterState]) -> void:
	for char_state in player_characters:
		_create_actor(char_state, Team.PLAYER)
	for char_state in enemy_characters:
		_create_actor(char_state, Team.ENEMY)

func _create_actor(character_state: CharacterState, team: Team.Type) -> void:
	var actor: BattleActor = BattleActor.from_state(character_state)
	inject_actor_dependencies(actor)
	_awaiting_actors.append(actor)
	actor.entered_battle.connect(_on_actor_entered_battle.bind(actor))
	battle_context.register_actor(actor, team)
	if (battle_context.get_character_team(character_state) == Team.PLAYER):
		_player_formation.add_actor(actor)
	else:
		_enemy_formation.add_actor(actor)
	
	signal_bus.actor_created.emit(actor)

func _on_actor_entered_battle(actor: BattleActor) -> void:
	_awaiting_actors.erase(actor)
	if _awaiting_actors.is_empty():
		signal_bus.all_actors_entered_battle.emit()


func inject_actor_dependencies(actor: BattleActor) -> void:
	actor.signal_bus = signal_bus
	# actor.actor_controller = actor_controller
	actor.battle_context = battle_context
