extends Node

signal fade_in_finished
signal fade_out_finished

func fade_in(custom_speed: float = 1) -> void:
	$AnimationPlayer.play("fade_in", -1, custom_speed)

func fade_out(custom_speed: float = 1) -> void:
	print("entra")
	$AnimationPlayer.play("fade_out", -1, custom_speed)

func _on_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			emit_signal("fade_in_finished")
		"fade_out":
			emit_signal("fade_out_finished")
