# NakedQuads.gd
extends Node

# This function applies the Naked Quads technique to the Sudoku grid
func solve(iteration_grid):
	print("NakedQuads")

	# Apply Naked Quads technique for each row, column, and box
	for i in range(9):
		apply_naked_quads(iteration_grid, get_row(iteration_grid, i))
		apply_naked_quads(iteration_grid, get_column(iteration_grid, i))
		apply_naked_quads(iteration_grid, get_box(iteration_grid, i))

	return iteration_grid

func apply_naked_quads(grid, unit):
	var progress = false

	# Create a list to hold candidate sets for each cell
	var candidate_sets = []
	for cell in unit:
		if typeof(grid[cell.x][cell.y]) == TYPE_ARRAY:
			candidate_sets.append({
				"cell": cell,
				"candidates": grid[cell.x][cell.y]
			})

	# Look for naked quads
	for i in range(candidate_sets.size()):
		for j in range(i + 1, candidate_sets.size()):
			for k in range(j + 1, candidate_sets.size()):
				for l in range(k + 1, candidate_sets.size()):
					var quad = [candidate_sets[i], candidate_sets[j], candidate_sets[k], candidate_sets[l]]
					var combined_candidates = []
					for element in quad:
						combined_candidates += element.candidates
					combined_candidates = combined_candidates.duplicate(true)

					if combined_candidates.size() == 4:
						# We have found a naked quad, now eliminate these candidates from other cells
						if eliminate_candidates_from_others(combined_candidates, candidate_sets, quad):
							progress = true

	return progress

func eliminate_candidates_from_others(naked_quad_candidates, candidate_sets, naked_quad):
	var changed = false
	for element in candidate_sets:
		var is_in_quad = false
		for quad_element in naked_quad:
			if element == quad_element:
				is_in_quad = true
				break

		if not is_in_quad:
			var cell_candidates = element.candidates
			for candidate in naked_quad_candidates:
				if candidate in cell_candidates:
					cell_candidates.erase(candidate)
					changed = true
	return changed

# Implement the helper functions
func get_row(grid, row_number):
	var row = []
	for col in range(9):
		row.append(Vector2(row_number, col))
	return row

func get_column(grid, col_number):
	var column = []
	for row in range(9):
		column.append(Vector2(row, col_number))
	return column

func get_box(grid, box_number):
	var box = []
	var start_row = (box_number / 3) * 3
	var start_col = (box_number % 3) * 3
	for i in range(3):
		for j in range(3):
			box.append(Vector2(start_row + i, start_col + j))
	return box

func is_naked_quad(quad):
	var all_candidates = []
	for cell in quad:
		all_candidates += cell  # Assuming cell is a list of candidates
	return len(all_candidates.duplicate(true)) == 4

func eliminate_candidates(naked_quad, unit):
	var quad_candidates = []
	for cell in naked_quad:
		quad_candidates += cell
	quad_candidates = quad_candidates.duplicate(true)

	for cell in unit:
		# Check if the cell is not part of the naked_quad
		var is_in_quad = false
		for quad_cell in naked_quad:
			if quad_cell == cell:
				is_in_quad = true
				break

		if not is_in_quad:
			# If the cell is not in the naked_quad, eliminate the candidates
			for num in quad_candidates:
				if num in cell:
					cell.erase(num)
