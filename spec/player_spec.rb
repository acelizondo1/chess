require './lib/player.rb'

describe Player do
  let(:white_player) do
    @white_player = Player.new("white")
  end

  describe "#initialize" do
    it "creates an array of white starting pieces storing them in active_pieces" do
      expect(white_player.active_pieces["rook"][0]).to be_kind_of(Rook)
      expect(white_player.color).to eql("white")
      expect(white_player.active_pieces["queen"][0]).to be_kind_of(Queen)
    end
  end
end