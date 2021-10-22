extends Spatial

export(float) var alpha

onready var mesh: MeshInstance = $MeshInstance
onready var anim_player: AnimationPlayer = $AnimationPlayer

signal activated
signal deactivated

func _physics_process(_delta) -> void:
	var material = mesh.get_surface_material(0)
	material.set_shader_param("color", Color(1.0, 1.0, 1.0, alpha))

func is_active() -> bool:
	return mesh.get_surface_material(0).get_shader_param("color").a == 1

func activate() -> void:
	if not is_active():
		anim_player.play("activate")
		emit_signal("activated")

func deactivate() -> void:
	if is_active():
		anim_player.play("deactivate")
		emit_signal("deactivated")

func _on_animation_finished(anim_name):
	if anim_name == "activate":
		anim_player.play("point_forward")
