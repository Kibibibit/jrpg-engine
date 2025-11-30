extends Ailment
class_name AilmentBurn

func get_post_effect() -> AilmentPostEffect:
	var result := AilmentPostEffect.new()
	result.amount = 2
	result.flat_amount = false
	## TODO: Make this burn particle effect
	result.particle_effect_id = &"ParticleEffectBurn"
	return result
