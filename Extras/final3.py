import pygame
import random
import logging

logging.basicConfig(
    level=logging.INFO,
    filename='app_logs.log',  # Specify the filename for the log file
    filemode='w',  # 'w' for write mode, creates a new file each time
    format='%(asctime)s - %(levelname)s - %(message)s'
)
# Initialize Pygame
pygame.init()

# Set up the display
WIDTH, HEIGHT = 540, 540
WINDOW = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Sudoku Maker")

# Colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GRAY = (200, 200, 200)
BLUE = (0, 0, 255)

# Fonts
FONT_SMALL = pygame.font.SysFont(None, 30)
FONT_LARGE = pygame.font.SysFont(None, 60)

# Game clock
clock = pygame.time.Clock()

# Create log file
log_file = "sudoku_logs.txt"
open(log_file, "a").close()  # Create the log file if it doesn't exist

def get_possible_numbers(puzzle, row, col):
    row_nums = set(puzzle[row])
    col_nums = set(puzzle[i][col] for i in range(9))

    box_start_row, box_start_col = row - row % 3, col - col % 3
    box_nums = set(puzzle[i][j] for i in range(box_start_row, box_start_row + 3) for j in range(box_start_col, box_start_col + 3))

    used_nums = row_nums | col_nums | box_nums
    possible_nums = set(range(1, 10)) - used_nums

    return possible_nums


def generate_sudoku():
    puzzle = [[0] * 9 for _ in range(9)]
    solve_sudoku(puzzle)
    if not is_valid_sudoku(puzzle):
        with open(log_file, "a") as f:
            f.write(str(puzzle) + "\n")
    return puzzle

def solve_sudoku(puzzle):
    row, col = find_empty_cell(puzzle)
    if row == -1 and col == -1:
        # Save valid Sudoku layouts
        with open(log_file, "a") as f:
            f.write(str(puzzle) + "\n")
        
        return True

    numbers = get_numbers(puzzle, row, col)
    random.shuffle(numbers)
    for num in numbers:
        if is_valid_placement(puzzle, row, col, num):
            puzzle[row][col] = num
            
            # Check if the display is still open
            if pygame.display.get_init():
                pygame.event.pump()
                draw_puzzle(puzzle)
            
            if solve_sudoku(puzzle):
                return True
            puzzle[row][col] = 0

    return False


def get_numbers(puzzle, row, col):
    possible_numbers = get_possible_numbers(puzzle, row, col)
    
    valid_numbers = []
    for num in possible_numbers:
        if is_valid_for_king_knight_adjacent(puzzle, row, col, num):
            valid_numbers.append(num)
            
    return valid_numbers

def is_valid_for_king_knight_adjacent(puzzle, row, col, num):
    # Check knight moves
    knight_moves = [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]
    for move in knight_moves:
        r = row + move[0]
        c = col + move[1]
        if is_valid_cell(r, c) and puzzle[r][c] == num:
            return False
    
    # Check king moves
    king_moves = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    for move in king_moves:
        r = row + move[0]
        c = col + move[1]
        if is_valid_cell(r, c) and puzzle[r][c] == num:
            return False

    # Check adjacent cells
    adjacent_moves = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    for move in adjacent_moves:
        r = row + move[0]
        c = col + move[1]
        if is_valid_cell(r, c):
            adjacent_num = puzzle[r][c]
            if adjacent_num != 0 and abs(num - adjacent_num) == 1:
                return False

    return True

def is_valid_placement(puzzle, row, col, num):
    return is_valid_for_king_knight_adjacent(puzzle, row, col, num)


def is_valid_cell(row, col):
    return 0 <= row < 9 and 0 <= col < 9

def find_empty_cell(puzzle):
    for row in range(9):
        for col in range(9):
            if puzzle[row][col] == 0:
                return row, col
    return -1, -1

def is_valid_sudoku(puzzle):
    for row in range(9):
        if not is_valid_row(puzzle[row]):
            return False

    for col in range(9):
        column = [puzzle[row][col] for row in range(9)]
        if not is_valid_row(column):
            return False

    for start_row in range(0, 9, 3):
        for start_col in range(0, 9, 3):
            square = [
                puzzle[row][col]
                for row in range(start_row, start_row + 3)
                for col in range(start_col, start_col + 3)
            ]
            if not is_valid_row(square):
                return False

    return True

def is_valid_row(row):
    numbers = [n for n in row if n != 0]
    return len(set(numbers)) == len(numbers)

def draw_puzzle(puzzle):
    WINDOW.fill(WHITE)
    for i in range(9):
        for j in range(9):
            cell_value = puzzle[i][j]
            if cell_value != 0:
                text = FONT_LARGE.render(str(cell_value), True, BLACK)
                text_rect = text.get_rect(center=(j * 60 + 30, i * 60 + 30))
                WINDOW.blit(text, text_rect)
    for i in range(10):
        if i % 3 == 0:
            pygame.draw.line(WINDOW, BLACK, (0, i * 60), (540, i * 60), 3)
            pygame.draw.line(WINDOW, BLACK, (i * 60, 0), (i * 60, 540), 3)
        else:
            pygame.draw.line(WINDOW, GRAY, (0, i * 60), (540, i * 60), 1)
            pygame.draw.line(WINDOW, GRAY, (i * 60, 0), (i * 60, 540), 1)
    pygame.display.update()

def main():
    while True:
        # Generate and validate a random Sudoku puzzle
        puzzle = generate_sudoku()
        while not is_valid_sudoku(puzzle):
            puzzle = generate_sudoku()

        # Main game loop
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False

            draw_puzzle(puzzle)
            clock.tick(60)

        pygame.quit()

if __name__ == '__main__':
    main()