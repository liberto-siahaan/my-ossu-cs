# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces + [ 
                  rotations([[0, 0], [-1, 0], [-1, 1], [0, 1], [1, 1]]), # big L
                  [[[0, 0], [1, 0], [-1, 0], [2, 0], [-2, 0]], # longer (only needs two)
                   [[0, 0], [0, 1], [0, 2], [0, -1], [0, -2]]
                  ],
                  rotations([[0, 0], [1, 0], [0, 1]]) # small L 
                  ]

  # modify the next_piece method to include the additional pieces
  def self.next_piece(board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  # add a cheat piece to the game
  def self.cheat_piece(board)
    MyPiece.new([[0,0]], board)
  end
end

class MyBoard < Board
  def initialize (game)
    super(game)
    @current_block = MyPiece.next_piece(self)
    @cheating = false
  end

  # rotate the piece 180 degrees
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 1)
      @current_block.move(0, 0, 1)
    end
    draw
  end

  def cheat
    if @score >= 100 and !@cheating
      @cheating = true
      @score -= 100
    end
  end

  def next_piece
    def next_piece
      if @cheating
        @current_block = MyPiece.cheat_piece(self)
        @cheating = false
      else
        @current_block = MyPiece.next_piece(self)
      end
      @current_pos = nil
    end
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1 )).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
  

  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.cheat})
  end

end


