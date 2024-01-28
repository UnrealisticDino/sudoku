#YWingStyle.gd
extends Node

# Function to solve Sudoku using the Y-Wing Style technique
func solve(candidates: Array) -> Array:
	#print("Y-Wing Style")
	var check = candidates.duplicate(true)

	# Apply Y-Wing Style technique
	for pivot_index in range(81):
		y_wing_style(candidates, pivot_index)

	if check != candidates:
		print("Y-Wing Style used")
	return candidates

# Y-Wing Style technique for a single cell as pivot
func y_wing_style(candidates: Array, pivot_index: int):
	var pivot_row = pivot_index / 9
	var pivot_col = pivot_index % 9
	var pivot_candidates = candidates[pivot_row][pivot_col]

	# The pivot should have exactly two candidates
	if pivot_candidates.size() != 2:
		return

	# Find wing cells that share one candidate with the pivot
	var wings = find_wing_cells(candidates, pivot_row, pivot_col, pivot_candidates)

	# Check for Y-Wing Style pattern and eliminate candidates
	for wing1 in wings:
		for wing2 in wings:
			if wing1 == wing2:
				continue
			check_and_eliminate_y_wing_style(candidates, pivot_candidates, wing1, wing2)

func find_wing_cells(candidates: Array, pivot_row: int, pivot_col: int, pivot_candidates: Array) -> Array:
	var wings = []
	# Logic to find wing cells that share one candidate with the pivot
	# Iterate through the grid to find such cells
	return wings

func check_and_eliminate_y_wing_style(candidates: Array, pivot_candidates: Array, wing1: Dictionary, wing2: Dictionary):
	# Check if wing1 and wing2 together contain all three candidates
	# If so, eliminate the shared candidate from cells seen by both wings
