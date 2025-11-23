extends Node
class_name BattleSignalBus

## New signals

@warning_ignore("unused_signal")
signal actor_created(actor: BattleActor)

@warning_ignore("unused_signal")
signal all_actors_entered_battle()

@warning_ignore("unused_signal")
signal request_next_turn()

@warning_ignore("unused_signal")
signal request_eventful_animation(character: CharacterState, animation_name: StringName)

@warning_ignore("unused_signal")
signal on_eventful_animation_event(character: CharacterState)

@warning_ignore("unused_signal")
signal request_player_character_turn(character: CharacterState)

@warning_ignore("unused_signal")
signal request_ai_character_turn(character: CharacterState)

@warning_ignore("unused_signal")
signal on_skill_selected(character: CharacterState, skill: Skill, targets: Array[CharacterState])

@warning_ignore("unused_signal")
signal request_execute_skill(user: CharacterState, skill: Skill, targets: Array[CharacterState])

@warning_ignore("unused_signal")
signal on_hit(user: CharacterState, target: CharacterState, hit: Hit)

@warning_ignore("unused_signal")
signal on_death(user: CharacterState)

@warning_ignore("unused_signal")
signal on_heal(user: CharacterState, target: CharacterState, amount: int)

@warning_ignore("unused_signal")
signal on_reflect(user: CharacterState, target: CharacterState)

## Old signals, may get reused

@warning_ignore("unused_signal")
signal create_skill_instance(user: CharacterState, skill: Skill, targets: Array[CharacterState])

@warning_ignore("unused_signal")
signal all_skill_instances_finished()
