extends Node

#
# cmdgen.gd - Generates Evennia commands based on interacting with the rendered scene.
#

# Main signal for sending a commnd.
signal send_generated_command(cmd_string)

func _send_generated_command(cmd_complete):
	emit_signal("send_generated_command", cmd_complete)
