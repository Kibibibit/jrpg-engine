@tool
extends EditorPlugin

const CustomGltfExtension = preload("uid://c0t6uy4nfw3yp")


var extension: CustomGltfExtension

func _enter_tree() -> void:
	extension = CustomGltfExtension.new()
	GLTFDocument.register_gltf_document_extension(extension)
	
func _exit_tree() -> void:
	if (extension != null):
		GLTFDocument.unregister_gltf_document_extension(extension)
	extension = null
