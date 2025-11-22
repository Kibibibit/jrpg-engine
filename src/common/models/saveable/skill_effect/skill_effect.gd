@abstract
extends Resource
class_name SkillEffect


@abstract
func get_results(user: CharacterState, targets: Array[CharacterState]) -> Array[SkillResult]

@abstract
func can_use(user: CharacterState, possible_targets: Array[CharacterState]) -> bool
