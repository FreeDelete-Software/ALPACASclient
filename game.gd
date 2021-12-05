extends Control

onready var _popup_toggle_button = $MessagesToggler
onready var _messages_popup = $Messages

func _ready():
	_popup_toggle_button.pressed = true


func _on_MessagesToggler_toggled( pressed ):
	if pressed:
		_messages_popup.popup()


func _on_popup_hide():
	_popup_toggle_button.pressed = false
