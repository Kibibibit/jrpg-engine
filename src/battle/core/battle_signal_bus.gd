extends Node
class_name BattleSignalBus

## New signals

@warning_ignore("unused_signal")
signal actor_created(actor: BattleActor)

@warning_ignore("unused_signal")
signal all_actors_entered_battle()

@warning_ignore("unused_signal")
signal turn_order_changed()

@warning_ignore("unused_signal")
signal request_next_turn()

@warning_ignore("unused_signal")
signal request_animation(character: CharacterState, animation_name: StringName, eventful: bool)

@warning_ignore("unused_signal")
signal on_animation_event(character: CharacterState)

@warning_ignore("unused_signal")
signal request_player_character_turn(character: CharacterState)

@warning_ignore("unused_signal")
signal request_ai_character_turn(character: CharacterState)

@warning_ignore("unused_signal")
signal on_skill_selected(character: CharacterState, skill: Skill, targets: Array[CharacterState])

@warning_ignore("unused_signal")
signal request_execute_skill(user: CharacterState, skill: Skill, targets: Array[CharacterState])

@warning_ignore("unused_signal")
signal request_pass(user: CharacterState)

@warning_ignore("unused_signal")
signal request_character_pre_turn(character: CharacterState)

@warning_ignore("unused_signal")
signal on_character_pre_turn_complete(character: CharacterState)

@warning_ignore("unused_signal")
signal request_character_post_turn(character: CharacterState)

@warning_ignore("unused_signal")
signal on_character_post_turn_complete(character: CharacterState)

@warning_ignore("unused_signal")
signal request_apply_ailment_post_effect(target: CharacterState, post_effect: AilmentPostEffect)

@warning_ignore("unused_signal")
signal on_hit(user: CharacterState, target: CharacterState, hit: Hit)

@warning_ignore("unused_signal")
signal on_death(user: CharacterState)

@warning_ignore("unused_signal")
signal on_heal(user: CharacterState, target: CharacterState, amount: int)

@warning_ignore("unused_signal")
signal on_apply_ailment(target: CharacterState, succeeded: bool)

@warning_ignore("unused_signal")
signal on_reflect(user: CharacterState, target: CharacterState)

@warning_ignore("unused_signal")
signal all_skill_instances_finished()
