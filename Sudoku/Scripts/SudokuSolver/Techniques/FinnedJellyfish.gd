#FinnedJellyfish.gd
extends Node

# Function to solve Sudoku using the Finned Jellyfish technique
func solve(candidates: Array) -> Array:
	#print("Finned Jellyfish")
	var check = candidates.duplicate(true)

	# Apply Finned Jellyfish technique for each number
	for num in range(1, 10):
		finned_jellyfish(candidates, num)

	if check != candidates:
		print("Finned Jellyfish used")
	return candidates

# Finned Jellyfish technique for a single number
func finned_jellyfish(candidates: Array, num: int):
	# Check for Finned Jellyfish in rows and columns
	for is_row in [true, false]:
		check_finned_jellyfish_lines(candidates, num, is_row)

func check_finned_jellyfish_lines(candidates: Array, num: int, is_row: bool):
	var lines_with_num = []
	for line in range(9):
		var positions = find_candidate_positions(candidates, num, line, is_row)
		if positions.size() >= 2 and positions.size() <= 5: # 2-5 candidates per line for Jellyfish
			lines_with_num.append({"line": line, "positions": positions})

	# Check combinations of four lines for Jellyfish pattern
	for i in range(lines_with_num.size()):
		for j in range(i + 1, lines_with_num.size()):
			for k in range(j + 1, lines_with_num.size()):
				for l in range(k + 1, lines_with_num.size()):
					var lines = [lines_with_num[i], lines_with_num[j], lines_with_num[k], lines_with_num[l]]
					check_finned_jellyfish_pattern(candidates, num, lines, is_row)

func check_finned_jellyfish_pattern(candidates: Array, num: int, lines: Array, is_row: bool):
	var positions_map = {}
	var fins = []
	for line_info in lines:
		for pos in line_info["positions"]:
			var key = is_row if pos.y else pos.x
			positions_map[key] = (positions_map.get(key) or []) + [pos]
	
	# Check if the positions form a Jellyfish pattern with a fin
	for key in positions_map.keys():
		if positions_map[key].size() > 4: # More than 4 cells in a column/row indicates a fin
			fins += positions_map[key]
			positions_map.erase(key)

	if positions_map.size() == 4 and fins.size() > 0: # Jellyfish with fins
		eliminate_candidates_using_finned_jellyfish(candidates, num, positions_map, fins, is_row)

func find_candidate_positions(candidates: Array, num: int, line: int, is_row: bool) -> Array:
	var positions = []
	for i in range(9):
		if (is_row and num in candidates[line][i]) or (not is_row and num in candidates[i][line]):
			positions.append(Vector2(line, i))
	return positions

func eliminate_candidates_using_finned_jellyfish(candidates: Array, num: int, positions_map: Dictionary, fins: Array, is_row: bool):
	var fin_boxes = []
	for fin in fins:
		var box = int(fin.x / 3) * 3 + int(fin.y / 3)
		if fin_boxes.find(box) == -1:
			fin_boxes.append(box)

	for row in range(9):
		for col in range(9):
			if candidates[row][col].find(num) == -1:
				continue
			var box = int(row / 3) * 3 + int(col / 3)
			if fin_boxes.find(box) != -1:
				if is_row and positions_map.has(col) and row != fins[0].x:
					candidates[row][col].erase(num)
				if not is_row and positions_map.has(row) and col != fins[0].y:
					candidates[row][col].erase(num)
