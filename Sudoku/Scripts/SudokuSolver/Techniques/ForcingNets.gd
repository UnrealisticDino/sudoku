#ForcingNets.gd
extends Node

# Function to solve Sudoku using the Forcing Nets technique
func solve(candidates: Array) -> Array:
	#print("Forcing Nets")
	var check = candidates.duplicate(true)

	# Apply Forcing Nets technique
	for row in range(9):
		for col in range(9):
			if candidates[row][col].size() > 1:
				forcing_nets(candidates, row, col)

	if check != candidates:
		print("Forcing Nets used")
	return candidates

# Forcing Nets technique for a single cell
func forcing_nets(candidates: Array, row: int, col: int):
	var cell_candidates = candidates[row][col]
	var net_results = []

	for candidate in cell_candidates:
		# Start a new branch of the net for each candidate
		var temp_candidates = candidates.duplicate(true)
		temp_candidates[row][col] = [candidate]
		var implications = follow_implications(temp_candidates)

		# Collect results of each branch
		net_results.append(implications)

	# Analyze the net results to find consistent solutions
	analyze_net_results(candidates, net_results)

func follow_implications(temp_candidates: Array) -> Array:
	# Implement the logic to follow the implications of assigning a candidate
	# Similar to Forcing Chains but with potential branching at multiple points
	# Return the state of the grid after following all implications
	return temp_candidates

func analyze_net_results(candidates: Array, net_results: Array):
	# Check if any cell has a consistent solution across all branches of the net
	for row in range(9):
		for col in range(9):
			var consistent_value = find_consistent_value(net_results, row, col)
			if consistent_value != -1:
				candidates[row][col] = [consistent_value]

func find_consistent_value(net_results: Array, row: int, col: int) -> int:
	# Determine if there's a value that appears in the same cell across all branches
	var first_branch_value = net_results[0][row][col]
	for branch in net_results:
		if branch[row][col] != first_branch_value:
			return -1  # Inconsistent results
	return first_branch_value
