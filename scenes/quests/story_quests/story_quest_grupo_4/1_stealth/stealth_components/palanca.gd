extends Node2D

@export var door: NodePath
@onready var interact_area: InteractArea = $InteractArea
var is_active := false

func _ready():
	# Conectar señales del InteractArea
	$InteractArea.interaction_started.connect(_on_interaction_started)
	$AnimatedSprite2D.frame = 0

func _on_interaction_started(player, from_right):
	if is_active:
		$InteractArea.end_interaction()
		return

	is_active = true

	# Animación opcional
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("default")
		interact_area.disabled = true
		interact_area.interaction_ended.emit()

	# Abrir puerta
	var d = get_node_or_null(door)
	if d:
		d.open()

	# Terminar la interacción
	$InteractArea.end_interaction()
	 # DESACTIVAR LA INTERACCIÓN + ocultar mensaje
