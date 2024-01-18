# HiddenQuads.gd
extends Node

# This function applies the Hidden Quads technique to the Sudoku grid
func solve(iteration_grid):
	print("HiddenQuads")

	# Apply Hidden Quads technique for each row, column, and box
	for i in range(9):
		apply_hidden_quads(iteration_grid, get_row(iteration_grid, i))
		apply_hidden_quads(iteration_grid, get_column(iteration_grid, i))
		apply_hidden_quads(iteration_grid, get_box(iteration_grid, i))

	return iteration_grid

func apply_hidden_quads(grid, unit):
	var progress = false
	var candidate_positions = {}

	# Populate candidate positions
	for i in range(unit.size()):
		var cell = unit[i]
		if typeof(grid[cell.x][cell.y]) == TYPE_ARRAY:
			for num in grid[cell.x][cell.y]:
				if not candidate_positions.has(num):
					candidate_positions[num] = []
				candidate_positions[num].append(cell)

	# Look for hidden quads
	var numbers = candidate_positions.keys()
	for i in range(numbers.size()):
		for j in range(i + 1, numbers.size()):
			for k in range(j + 1, numbers.size()):
				for l in range(k + 1, numbers.size()):
					var num_set = [numbers[i], numbers[j], numbers[k], numbers[l]]
					var cell_set = []
					for num in num_set:
						cell_set += candidate_positions[num]
					cell_set = cell_set.duplicate(true)

					if cell_set.size() == 4:
						# Hidden quad found, now remove other candidates
						if clean_up_hidden_quad(grid, cell_set, num_set):
							progress = true

	return progress

func clean_up_hidden_quad(grid, cell_set, num_set):
	var changed = false
	for cell in cell_set:
		var candidates = grid[cell.x][cell.y]
		for num in candidates:
			if not num_set.has(num):
				candidates.erase(num)
				changed = true
	return changed

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
