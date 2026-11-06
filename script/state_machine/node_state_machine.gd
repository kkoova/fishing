class_name NodeStateMachine
extends Node

@export var initial_node_state: NodeState

var node_states: Dictionary = {}
var current_node_state: NodeState
var current_node_state_name: String = ""


func _ready() -> void:
	_register_states()

	if not initial_node_state:
		push_error("NodeStateMachine: Initial state is not assigned.")
		return

	if not node_states.has(initial_node_state.name.to_lower()):
		push_error(
			"NodeStateMachine: Initial state '%s' is not registered."
			% initial_node_state.name
		)
		return

	_change_state(initial_node_state)


func _process(delta: float) -> void:
	if is_instance_valid(current_node_state):
		current_node_state._on_process(delta)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(current_node_state):
		return

	current_node_state._on_physics_process(delta)
	current_node_state._on_next_transitions()


func _register_states() -> void:
	node_states.clear()

	for child in get_children():
		if not child is NodeState:
			continue

		var state_name: String = child.name.to_lower()

		if node_states.has(state_name):
			push_error(
				"NodeStateMachine: Duplicate state name '%s'."
				% child.name
			)
			continue

		node_states[state_name] = child
		child.transition.connect(transition_to)


func transition_to(state_name: String) -> void:
	var normalized_name := state_name.to_lower()

	if not node_states.has(normalized_name):
		push_warning(
			"NodeStateMachine: State '%s' does not exist."
			% state_name
		)
		return

	var new_state: NodeState = node_states[normalized_name]

	if new_state == current_node_state:
		return

	_change_state(new_state)


func _change_state(new_state: NodeState) -> void:
	if is_instance_valid(current_node_state):
		current_node_state._on_exit()

	current_node_state = new_state
	current_node_state_name = new_state.name.to_lower()

	current_node_state._on_enter()

	print("Current State: ", current_node_state_name)
