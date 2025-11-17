# SPDX-License-Identifier: MPL-2.0
class_name Cinematic
extends Node2D

signal cinematic_finished

@export var dialogue: DialogueResource
@export var animation_player: AnimationPlayer
@export_file("*.tscn") var next_scene: String
@export var spawn_point_path: String

# Opcionales (solo para escenas con intro)
@export var player_path: NodePath
@export var enemy_path: NodePath
@export var entry_animation := "Intro"
@export var enemy_speed := 900.0

var player : Node
var enemy : Node


func _ready() -> void:
	# Solo cargamos player/enemy si realmente existen en esta escena
	if player_path and has_node(player_path):
		player = get_node(player_path)

	if enemy_path and has_node(enemy_path):
		enemy = get_node(enemy_path)

	# Mostrar diálogo si existe
	if dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, "", [self])
		await DialogueManager.dialogue_ended

	# Si hay enemigo y player, entonces es una escena con cinemática
	if enemy and player:
		await _enemy_attack()

	# Cuando ya acabó la cinemática (o solo diálogo)
	cinematic_finished.emit()

	# Cambio de escena si está configurado
	if next_scene:
		SceneSwitcher.change_to_file_with_transition(
			next_scene,
			spawn_point_path,
			Transition.Effect.FADE,
			Transition.Effect.FADE
		)


func _enemy_attack() -> void:
	# Si por alguna razón faltara algo → no hacer nada
	if enemy == null or player == null:
		return

	enemy.position.x = -200
	enemy.position.y = player.position.y

	var tween := create_tween()
	tween.tween_property(enemy, "position", player.position + Vector2(-80, 0), 0.2)
	await tween.finished
