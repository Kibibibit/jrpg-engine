extends GLTFDocumentExtension

const ActorSkinScript: Script = preload("uid://dtbr13uauwxef")


func _import_post(state: GLTFState, root: Node) -> Error:
	if (state.json.has("scenes")):
		for scene in state.json["scenes"]:
			if (scene.has("extras") and scene["extras"].has("import_type")):
				var import_type: String = scene["extras"]["import_type"]
				if (import_type == "ActorSkin"):
					return _actor_skin_import(state, root)
	return Error.OK
	
func _actor_skin_import(state: GLTFState, root: Node) -> Error:
	root.set_script(ActorSkinScript)

	if not root is ActorSkin:
		push_error("Failed to set ActorSkin script on root node")
		return Error.ERR_SCRIPT_FAILED
	
	var animation_player: AnimationPlayer = null
	for child in root.get_children():
		if child is AnimationPlayer:
			animation_player = child
			break
	
	_get_actor_target_points(root)
	root.animation_player = animation_player

	var animation_json_data = state.json['animations']
	for anim_json in animation_json_data:
		if (not anim_json.has("name")):
			push_error("Animation in %s file missing name" % state.filename)
			return Error.ERR_INVALID_DATA

		var anim_name: String = anim_json['name']
		var animation := animation_player.get_animation(anim_name)

		if not animation:
			push_error("AnimationPlayer missing animation %s from %s file" % [anim_name, state.filename])
			return Error.ERR_INVALID_DATA

		if anim_json.has("extras") and anim_json["extras"].has("event_frame"):
			var event_frame: int = str(anim_json["extras"]["event_frame"]).to_int()
			var method_track: int = animation.add_track(Animation.TYPE_METHOD)
			animation.track_set_path(method_track, NodePath("%s/.."% animation_player.name))
			var method_key: int = animation.track_insert_key(
				method_track,
				animation.step * event_frame,
				{
					"method": "_on_event_frame",
					"args": []
				}
			)
	return Error.OK


func _get_actor_target_points(root: ActorSkin) -> void:
	var to_check: Array[Node3D] = []
	var checked: Array[Node3D] = []

	for child in root.get_children():
		if child is Node3D:
			to_check.append(child)
	
	while not to_check.is_empty():
		var current: Node3D = to_check.pop_front()
		checked.append(current)
		
		match current.name:
			"AboveHead":
				root.above_head = current
			"CenterOfMass":
				root.center_of_mass = current
			"Weapon.L":
				root.weapon_left = current
			"Weapon.R":
				root.weapon_right = current
			_:
				pass
		
		for child in current.get_children():
			if child is Node3D and not checked.has(child):
				to_check.append(child)
