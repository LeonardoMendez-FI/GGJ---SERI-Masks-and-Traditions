extends Area3D
class_name ItemClass

signal taked_object(object: ItemClass)

@onready var effects: AudioStreamPlayer3D = $Effects
@onready var collision: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	# Deshabilitar colisión inicialmente (se activará después de la animación)
	collision.disabled = true
	
	# Conectar señal de body entered
	body_entered.connect(_on_body_entered)


func _disable() -> void:
	hide()
	set_deferred("monitoring", false)


func kill() -> void:
	collision.disabled = true
	taked_object.emit(self)
	if effects and effects.stream:
		effects.play()
		await effects.finished
	else:
		# Si no hay sonido, esperar un momento breve
		await get_tree().create_timer(0.1).timeout
		
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		_disable()
		kill()


# Asegurar que se limpien recursos
func _exit_tree() -> void:
	if body_entered.is_connected(_on_body_entered):
		body_entered.disconnect(_on_body_entered)
