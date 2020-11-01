require './lib/game.rb'

describe Game do
  let!(:game) do
    @game = Game.new
  end

  describe "#play_game" do
    it "changes current_player after a valid piece move is entered" do 
      allow(game).to receive(:gets).and_return("pawn a2 a3", "yield")
      game.play_game
      expect(game.current_player.color).to eql("black")
    end

    it "plays a string of moves only running the valid ones" do
      allow(game).to receive(:gets).and_return("pawn a2 a3","rook a6 a3","knight g8 h6","pawn c2 c3","pawn h7 h6","pawn d7 d6","bishop f1 f2","qUEEN d1 a4")
      game.play_game
      expect(game.winner.color).to eql("white")
      expect(game.white_player.active_pieces['pawn'][0].position).to eql(['a',3])
      expect(game.black_player.active_pieces['knight'][1].position).to eql(['h',6])
      expect(game.white_player.active_pieces['queen'][0].position).to eql(['a',4])
      expect(game.black_player.active_pieces['pawn'][3].position).to eql(['d',6])
    end

    it "plays a quick game to checkmate" do
      allow(game).to receive(:gets).and_return("pawn e2 e3","pawn e7 e6","bishop f1 b5","knight b8 c6","queen d1 h5","knight g8 f6","queen h5 f7")
      game.play_game
      expect(game.winner.color).to eql("white")
    end

    it "changes winner to opponent player when yield command is entered" do
      allow(game).to receive(:gets).and_return("yield")
      game.play_game
      expect(game.winner.color).to eql("black")
    end

    it "processes valid castle move" do
      allow(game).to receive(:gets).and_return("pawn e2 e4","pawn e7 e5","knight g1 f3","knight g8 f6","bishop f1 e2","pawn h7 h5","castle","yield")
      game.play_game
      expect(game.board.board['g'][0].class).to eql(King)
      expect(game.board.board['f'][0].class).to eql(Rook)
    end

    it "ignores a castle request if not valid" do
      allow(game).to receive(:gets).and_return("pawn e2 e4","knight g8 f6","knight g1 f3","knight f6 g4","bishop f1 e2","knight g4 e3","castle","yield")
      game.play_game
      expect(game.board.board['e'][0].class).to eql(King)
      expect(game.board.board['h'][0].class).to eql(Rook)
    end

    it "allows a pawn diagonal forward overtake", :focus do
      allow(game).to receive(:gets).and_return("pawn e2 e4","pawn d7 d5","pawn e4 d5","yield")
      game.play_game
      expect(game.board.board['d'][4].color).to eql("white")
    end
  end

  describe "#process_move" do
    it "updates a player position on move to an empty spot" do
      game.process_move(['pawn',['c',2],['c',3]])
      expect(game.current_player.active_pieces["pawn"][2].position).to eql(['c',3])
      expect(game.board.board["c"][2].class).to eql(Pawn)
    end

    it "updates a piece position on an overtake and eliminates from opponent" do
      game.process_move(['knight',['b',1],['c',3]])
      game.process_move(['knight',['c',3],['d',5]])
      game.process_move(['knight',['d',5],['e',7]])
      expect(game.current_player.active_pieces['knight'][0].position).to eql(['e',7])
      expect(game.board.board['e'][6].class).to eql(Knight)
      expect(game.opponent_player.eliminated_pieces[0].class).to eql(Pawn)
    end

    it "updates a piece and also checks if move puts king in checkmate"do
      game.process_move(['pawn',['e',2],['e',3]])
      game.send(:switch_current_player)
      game.process_move(['pawn',['f',7],['f',6]])
      game.process_move(['pawn',['h',7],['h',5]])
      game.send(:switch_current_player)
      game.process_move(['queen',['d',1],['h',5]])
      game.process_move(['queen',['h',5],['h',8]])
      game.process_move(['queen',['h',8],['h',5]])
      expect(game.winner.color).to eql("white")
      expect(game.opponent_player.in_check).to eql(true)
    end
  end

  describe "#get_valid_move" do
    it "doesn't make invalid moves" do
      allow(game).to receive(:gets).and_return("rook a1 a2", "rook a1 a4", "pawn a2 a3")
      expect(game.get_valid_move).to eql(['pawn',['a',2],['a',3]])
    end

    it "doesn't make a move that doesn't remove player from check" do
      game.process_move(['pawn',['e',2],['e',3]])
      game.send(:switch_current_player)
      game.process_move(['pawn',['d',7],['d',6]])
      game.send(:switch_current_player)
      game.process_move(['bishop',['f',1],['b',5]])
      game.send(:switch_current_player)
      allow(game).to receive(:gets).and_return("pawn a7 a6","pawn c7 c6")
      expect(game.get_valid_move).to eql(['pawn',['c',7],['c',6]])
    end

    it "allows special commands to be entered" do
      allow(game).to receive(:gets).and_return("YiEld")
      expect(game.get_valid_move).to eql("yield")
    end
  end

  describe "#get_input" do
    it "returns array of move inputs if user input is valid" do
      allow(game).to receive(:gets).and_return("Queen a3 c5")
      expect(game.get_input).to eql(['queen',['a',3],['c',5]])
    end

    it "prompts user to enter move again if invalid input" do 
      allow(game).to receive(:gets).and_return("wrong input", "Closer format input", "EvenCloser bb a5", "a6 b5", "KiNg D5 c6")
      expect{game.get_input}.to output("White player please enter your move(enter 'help' for possible commands):\nWhite player please enter your move(enter 'help' for possible commands):\nWhite player please enter your move(enter 'help' for possible commands):\nWhite player please enter your move(enter 'help' for possible commands):\nWhite player please enter your move(enter 'help' for possible commands):\n").to_stdout
    end

    it "allows an input of a special command" do
      allow(game).to receive(:gets).and_return("HELP")
      expect(game.get_input).to eql("help")
    end
  end

  describe "#remove_check?" do 
    it "should return true if king moves out of check" do
      game.process_move(['knight',['b',1],['c',3]])
      game.process_move(['knight',['c',3],['d',5]])
      game.send(:switch_current_player)
      game.process_move(['pawn',['f',7],['f',6]])
      game.send(:switch_current_player)
      game.process_move(['knight',['d',5],['f',6]])
      game.send(:switch_current_player)
      expect(game.remove_check?(['king',['e',8],['f',7]])).to eql(true)
      expect(game.current_player.active_pieces["king"][0].position).to eql(['e',8])
    end

    it "should return true if checking piece is overtaken" do
      game.process_move(['knight',['b',1],['c',3]])
      game.process_move(['knight',['c',3],['d',5]])
      game.send(:switch_current_player)
      game.process_move(['pawn',['f',7],['f',6]])
      game.send(:switch_current_player)
      game.process_move(['knight',['d',5],['f',6]])
      game.send(:switch_current_player)
      expect(game.remove_check?(['pawn',['e',7],['f',6]])).to eql(true)
      expect(game.current_player.active_pieces["pawn"][4].position).to eql(['e',7])
    end

    it "should return true if checking path is blocked by move" do
      game.process_move(['pawn',['e',2],['e',3]])
      game.send(:switch_current_player)
      game.process_move(['pawn',['d',7],['d',6]])
      game.send(:switch_current_player)
      game.process_move(['bishop',['f',1],['b',5]])
      game.send(:switch_current_player)
      expect(game.remove_check?(['pawn',['c',7],['c',6]])).to eql(true)
      expect(game.current_player.active_pieces["pawn"][2].position).to eql(['c',7])
    end

    it "should return false if move does not remove the king from check" do
      game.process_move(['pawn',['e',2],['e',3]])
      game.send(:switch_current_player)
      game.process_move(['pawn',['d',7],['d',6]])
      game.send(:switch_current_player)
      game.process_move(['bishop',['f',1],['b',5]])
      game.send(:switch_current_player)
      expect(game.remove_check?(['pawn',['a',7],['a',6]])).to eql(false)
      expect(game.current_player.active_pieces["pawn"][0].position).to eql(['a',7])
    end
  end

  describe "#input_in_range?" do
    it "should return true if all inputs are in board range" do
      expect(game.send(:input_in_range?, "pawn", ['a', 2], ['a', 3])).to eql(true)
    end

    it "returns false if invalid entries" do
      expect(game.send(:input_in_range?, "test", ['a', 2], ['a', 3])).to eql(false)
    end
  end

  describe "#clean_input" do
    it "returns an array of cleaned input" do
      expect(game.send(:clean_input, "Rook a3 a6")).to eql(["rook",['a',3],['a',6]])
    end

    it "returns false if invalid row coordinate inputs" do
      expect(game.send(:clean_input, "Rook aa a6")).to eql(false)
    end

    it "returns false if invalid column coordinate inputs" do
      expect(game.send(:clean_input, "Rook a3 56")).to eql(false)
    end

    it "returns false if invalid number of arguments are entered" do
      expect(game.send(:clean_input, "rook a5")).to eql(false)
    end
  end
end