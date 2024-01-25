#SudokuGenerator.gd
extends Node

var grid_size = 9
var puzzle_folder = "user://SudokuPuzzles"
var puzzle_files = ["Easy.json", "Medium.json", "Hard.json", "Impossible.json"]
var SudokuSolver = preload("res://Sudoku/Scripts/SudokuSolver/SudokuSolver.gd").new()
var num_expected_puzzles = 5

func _ready():
	var missing_puzzles = {}
	randomize()

	# Check if the puzzle folder exists
	var dir = Directory.new()
	if not dir.dir_exists(puzzle_folder):
		dir.make_dir(puzzle_folder)

	# Check each puzzle file for missing puzzles
	for file_name in puzzle_files:
		var file_path = "%s/%s" % [puzzle_folder, file_name]
		print(file_path)
		
		var file = File.new()
		if not file.file_exists(file_path) or file.open(file_path, File.READ) != OK:
			# Create only two puzzles if file is missing or can't be opened
			missing_puzzles[file_name] = 2
		else:
			var num_puzzles = check_saved_puzzles(file_name)
			file.close()
			if num_puzzles < num_expected_puzzles:
				if num_puzzles == 0:
					# Create only two puzzles if file is empty
					missing_puzzles[file_name] = 2
				else:
					# Fill up to 5 puzzles if the file already contains some puzzles
					missing_puzzles[file_name] = num_expected_puzzles - num_puzzles

	# Check if any puzzles are missing and create them if necessary
	if missing_puzzles.empty():
		print("All files have 5 puzzles")
	else:
		print("Missing puzzles:")
		for file_name in missing_puzzles:
			var missing_count = missing_puzzles[file_name]
			print("%s: %d puzzles" % [file_name, missing_count])
			create_sudoku_puzzles(file_name, missing_count)

func create_sudoku_puzzles(file_name, number_to_create):
	var file_path = "%s/%s" % [puzzle_folder, file_name]
	var puzzles = []

	# Read existing puzzles from the file
	var file = File.new()
	if file.file_exists(file_path) and file.open(file_path, File.READ) == OK:
		var json_text = file.get_as_text()
		file.close()
		if json_text != "":
			puzzles = parse_json(json_text)

	# Add new puzzles up to the specified number
	var existing_count = puzzles.size()
	for i in range(number_to_create):
		var filled_grid = generate_filled_grid(file_name)
		puzzles.append(filled_grid)

	# Write the updated puzzles back to the file
	if file.open(file_path, File.WRITE) == OK:
		var json_string = to_json(puzzles)
		file.store_string(json_string)
		file.close()
	else:
		print("Failed to open file for writing: " + file_path)

func check_saved_puzzles(file_name):
	# Check and return the number of puzzles in the specified JSON file
	var file_path = "%s/%s" % [puzzle_folder, file_name]
	var file = File.new()
	if file.file_exists(file_path):
		if file.open(file_path, File.READ) == OK:
			var data = file.get_as_text()
			file.close()
			var puzzles = parse_json(data)
			if typeof(puzzles) == TYPE_ARRAY:
				return puzzles.size()
	return 0

func generate_filled_grid(file_name):
	var grid = []
	for i in range(grid_size):
		var row = []
		for j in range(grid_size):
			row.append(0)
		grid.append(row)

	if fill_grid(grid):
		grid = generate_puzzle(grid, file_name)
		return grid
	return []

func fill_grid(grid):
	var nums = range(1, grid_size + 1)
	for row in range(grid_size):
		for col in range(grid_size):
			if grid[row][col] == 0:
				nums.shuffle()
				for num in nums:
					if is_safe(grid, row, col, num):
						grid[row][col] = num
						if fill_grid(grid):
							return true
						grid[row][col] = 0
				return false
	return true

func is_safe(grid, row, col, num):
	# Check if 'num' is not in the given row
	for x in range(grid_size):
		if grid[row][x] == num:
			return false

	# Check if 'num' is not in the given column
	for x in range(grid_size):
		if grid[x][col] == num:
			return false

	# Check if 'num' is not in the current 3x3 box
	var startRow = row - row % 3
	var startCol = col - col % 3
	for i in range(3):
		for j in range(3):
			if grid[i + startRow][j + startCol] == num:
				return false

	return true

# This function generates a puzzle
func generate_puzzle(grid, file_name):
	randomize()
	var difficulty = file_name.split(".json")[0]
	var num_cells_to_remove = get_cells_to_remove_based_on_difficulty(difficulty)
	var batch_size = 5

	var puzzle = grid.duplicate()
	var removed_cells = 0
	var current_batch = []

	# Decide which strategy to use
	var strategy = randi() % 5  # 0: Random, 1: Block-based, 2: Row-based, 3: Diagonal, 4: Patterns

	# Create a list of all cell coordinates
	var all_cells = []
	for row in range(grid_size):
		for col in range(grid_size):
			all_cells.append({"row": row, "col": col})

	# Apply the chosen strategy to the cell list
	if strategy == 0:  # Random
		all_cells.shuffle()
	elif strategy == 1:  # Block-based
		all_cells.sort_custom(self, "block_based_sort")
	elif strategy == 2:  # Row-based
		all_cells.sort_custom(self, "row_based_sort")
	elif strategy == 3:  # Diagonal-based
		all_cells.sort_custom(self, "diagonal_based_sort")
	elif strategy == 4:  # Patterns like X, cross, etc.
		all_cells.sort_custom(self, "pattern_based_sort")

	all_cells.shuffle()

	while removed_cells < num_cells_to_remove:
		current_batch.clear()
		
		for i in range(batch_size):
			if removed_cells >= num_cells_to_remove:
				break
			var random_index = randi() % all_cells.size()
			var cell = all_cells[random_index]
			all_cells.remove(random_index)  # Remove selected cell from the pool

			var row = cell["row"]
			var col = cell["col"]
			if puzzle[row][col] != 0:
				current_batch.append({"row": row, "col": col, "value": puzzle[row][col]})
				puzzle[row][col] = 0
				removed_cells += 1

		# Check if the puzzle is still solvable
		var tmp_puzzle = puzzle.duplicate(true)
		if not SudokuSolver.solve_sudoku(tmp_puzzle, difficulty):
			# Restore the cells from the current batch
			for cell in current_batch:
				puzzle[cell["row"]][cell["col"]] = cell["value"]
			removed_cells -= current_batch.size()

	return puzzle

func get_cells_to_remove_based_on_difficulty(difficulty):
	match difficulty:
		"Easy":
			return 20
		"Medium":
			return 40
		"Hard":
			return 60
		_:
			return 30
		"Impossible":
			return 64

# Block-based sort
func block_based_sort(a, b):
	var block_a = (a["row"] / 3) * 3 + a["col"] / 3
	var block_b = (b["row"] / 3) * 3 + b["col"] / 3
	return block_a < block_b

# Row-based sort
func row_based_sort(a, b):
	return a["row"] < b["row"]

# Diagonal-based sort
func diagonal_based_sort(a, b):
	var dist_a = abs(a["row"] - a["col"])
	var dist_b = abs(b["row"] - b["col"])
	return dist_a < dist_b

# Pattern-based sort (e.g., X pattern)
func pattern_based_sort(a, b):
	var is_a_on_diag = a["row"] == a["col"] or a["row"] == grid_size - 1 - a["col"]
	var is_b_on_diag = b["row"] == b["col"] or b["row"] == grid_size - 1 - b["col"]
	if is_a_on_diag and is_b_on_diag:
		return 0
	elif is_a_on_diag:
		return -1
	elif is_b_on_diag:
		return 1
	else:
		return 0
