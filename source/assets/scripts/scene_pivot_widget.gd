extends Area

onready var material_1: Material = $MeshInstance.get_surface_material(0)
onready var material_2: Material = $MeshInstance.get_surface_material(1)
onready var timer: Timer = $Timer

var brightness: float = 0.6
var alpha: float = 1

func _process(_delta) -> void:
	if not timer.is_stopped():
		alpha = 1 - timer.time_left
	material_1.set_shader_param("brightness", brightness)
	material_2.set_shader_param("brightness", brightness)
	material_1.set_shader_param("alpha", alpha)
	material_2.set_shader_param("alpha", alpha)

func _on_Timer_timeout() -> void:
	$CollisionShape.disabled = false

func activate() -> void:
	if not self.visible:
		timer.start()
		self.visible = true
