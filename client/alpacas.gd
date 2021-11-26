# This code was copied from the websocket_chat demo code provided by Godot
# under its MIT license terms. See godot.LICENSE.txt for the full license text.
# Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.
# Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).

# Modifications for the ALPACASclient project are BSD 3-Clause:
# Copyright (c) 2021, Michael J. Freidel
# See the LICENSE file for the full license text.

extends Node

# Initialize signals
signal alpacas_open
signal alpacas_closed
signal alpacas_received(inputfunc, args, kwargs)

# Get the Node for writing output
onready var _log_dest = get_parent().get_node("Panel/VBoxContainer/RichTextLabel")

# Create WebSocketClient object
var _wsclient = WebSocketClient.new()

# Write mode is *always* text
var _write_mode = WebSocketPeer.WRITE_MODE_TEXT

func _init():
	# Account for all signals from basic WebsocketClient
	_wsclient.connect("connection_established", self, "_client_connected")
	_wsclient.connect("data_received", self, "_client_received")
	_wsclient.connect("connection_error", self, "_client_disconnected")
	_wsclient.connect("connection_closed", self, "_client_disconnected")
	_wsclient.connect("server_close_request", self, "_client_close_request")


func _process(_delta):
	# Poll regularly, unless disconnected.
	if _wsclient.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return
	_wsclient.poll()


func _exit_tree():
	# Disconnect on close. Standard WebSocket Code 1001: Going Away
	_wsclient.disconnect_from_host(1001, "Going away.")


func _client_connected(protocol):
	#
	# Called by "connection_established" signal
	#
	
	# Emit the open signal.
	emit_signal("alpacas_open")
	
	# Display some output
	print("ALPACAS -- Connection established.")
	Utils._log(_log_dest, "Connection established!")
	
	# Ensure the write mode is text on connect
	_wsclient.get_peer(1).set_write_mode(_write_mode)


func _client_received(_p_id = 1):
	#
	# Called by "data_received" signal
	#
	print("ALPACAS -- Receiving packet...")
	
	# Get packet data
	var packet = _wsclient.get_peer(1).get_packet()
	var packet_data = Utils.decode_evennia(packet.get_string_from_utf8())
	
	emit_signal("alpacas_received", packet_data[0], packet_data[1], packet_data[2])


func _client_disconnected(clean=true):
	#
	# Called by "connection_error" and "connection_closed" signals
	#
	
	# Emit the closed signal.
	emit_signal("alpacas_closed")
	
	# Display some output
	Utils._log(_log_dest, "Client just disconnected. Was clean: %s" % clean)
	print("Connection closed.")


func _client_close_request(code, reason):
	#
	# Called by "server_close_request" signal
	#
	Utils._log(_log_dest, "Close code: %d, reason: %s" % [code, reason])


func connect_to_server(address, port):
	# Connect based on address and port.
	print("ALPACAS -- Connecting...")
	var host = "ws://%s:%s" % [address, port]
	
	# Specifying a sub-protocol doesn't seem to work properly.
	# Leaving it blank (for now)
	var protocols = PoolStringArray()
	return _wsclient.connect_to_url(host, protocols)


func send_data(data_utf):
	print("ALPACAS -- Sending data...")
#	_wsclient.get_peer(1).set_write_mode(_write_mode)
	_wsclient.get_peer(1).put_packet(data_utf)


func disconnect_from_host():
	_wsclient.disconnect_from_host(1000, "Bye bye!")
