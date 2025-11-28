extends SkillResult
class_name SkillResultNothing

func _init(p_user: CharacterState) -> void:
	user = p_user

func apply(_skill_context: SkillContext) -> void:
	## TODO: Some kind of animation or pause or something
	pass
