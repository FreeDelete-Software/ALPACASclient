# This code was copied from the websocket_chat demo code provided by Godot
# under its MIT license terms. See godot.LICENSE.txt for the full license text.
# Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.
# Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).

# Modifications for the ALPACASclient project are BSD 3-Clause:
# Copyright (c) 2021, Michael J. Freidel
# See the LICENSE file for the full license text.

extends Node

onready var _log_dest = get_parent().get_node("Panel/VBoxContainer/RichTextLabel")

var _client = WebSocketClient.new()

# ALPACAS
# Set default write mode to text with no Godot multiplayer API
var _write_mode = WebSocketPeer.WRITE_MODE_TEXT
var _use_multiplayer = false
# ALPACAS

var last_connected_client = 1

# ALPACAS
func _init():
	# Account for all signals from basic WebsocketClient, but no multiplayer API
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_disconnected")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")
# ALPACAS

func _client_close_request(code, reason):
	Utils._log(_log_dest, "Close code: %d, reason: %s" % [code, reason])


func _exit_tree():
	_client.disconnect_from_host(1001, "Bye bye!")


func _process(_delta):
	if _client.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return

	_client.poll()


func _client_connected(protocol):
	Utils._log(_log_dest, "Client just connected with protocol: %s" % protocol)
	_client.get_peer(1).set_write_mode(_write_mode)


func _client_disconnected(clean=true):
	Utils._log(_log_dest, "Client just disconnected. Was clean: %s" % clean)

# ALPACAS -- Simplify data_receive processing
func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	Utils._log(_log_dest, "Received data: %s" % [packet.get_string_from_utf8()])
# ALPACAS

# ALPACAS
# Change connection function to take an address and port instead of URL.
func connect_to_server(address, port):
	var host = "ws://" + address + ":" + port
	var multiplayer = false
	var protocols = PoolStringArray()
	return _client.connect_to_url(host, protocols, multiplayer)
# ALPACAS

func disconnect_from_host():
	_client.disconnect_from_host(1000, "Bye bye!")


func send_data(data):
	
	_client.get_peer(1).set_write_mode(_write_mode)

	# ALPACAS - Only need the non-multiplayer for Evennia
	_client.get_peer(1).put_packet(data.to_utf8())
	# ALPACAS


func set_write_mode(mode):
	_write_mode = mode
