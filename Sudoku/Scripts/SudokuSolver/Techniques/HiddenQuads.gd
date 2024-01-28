#HiddenQuads.gd
extends Node

# This function applies the Hidden Quads technique to the Sudoku candidates
func solve(candidates):
	#print("HiddenQuads")
	#var check = candidates.duplicate(true)

	# Apply Hidden Quads technique for each row, column, and box
	for i in range(9):
		apply_hidden_quads(candidates, get_row(i))
		apply_hidden_quads(candidates, get_column(i))
		apply_hidden_quads(candidates, get_box(i))

#	if check != candidates:
#		print("HiddenQuads used")
	return candidates

func apply_hidden_quads(candidates, unit):
	var progress = false
	var candidate_positions = {}

	# Populate candidate positions
	for cell in unit:
		for num in candidates[cell.x][cell.y]:
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
					cell_set = remove_duplicates(cell_set)

					if cell_set.size() == 4:
						# Hidden quad found, now remove other candidates
						if clean_up_hidden_quad(candidates, cell_set, num_set):
							progress = true

	return progress

func clean_up_hidden_quad(candidates, cell_set, num_set):
	var changed = false
	for cell in cell_set:
		var cell_candidates = candidates[cell.x][cell.y].duplicate()
		for num in cell_candidates:
			if not num in num_set:
				candidates[cell.x][cell.y].erase(num)
				changed = true
	return changed

func get_row(row_number):
	var row = []
	for col in range(9):
		row.append(Vector2(row_number, col))
	return row

func get_column(col_number):
	var column = []
	for row in range(9):
		column.append(Vector2(row, col_number))
	return column

func get_box(box_number):
	var box = []
	var start_row = (box_number / 3) * 3
	var start_col = (box_number % 3) * 3
	for i in range(3):
		for j in range(3):
			box.append(Vector2(start_row + i, start_col + j))
	return box

# Utility function to remove duplicates from an array of Vector2
func remove_duplicates(arr):
	var unique = []
	for item in arr:
		if not unique.has(item):
			unique.append(item)
	return unique
