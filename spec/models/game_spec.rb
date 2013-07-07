require 'spec_helper'

describe Game do

    let(:game) { Factory(:game) }

    it "can be instantiated" do
        Game.new.should be_an_instance_of(Game)
    end

    context 'validation' do
        before(:each) do
            @valid_attributes = {
                :title => 'Saving Donny',
                :players => [Factory(:player)]
            }
        end

        it "should create a new instance given valid attributes" do
            Game.create!(@valid_attributes)
        end

        it 'is invalid when no title is given' do
            Game.new.should_not be_valid
        end

        it 'is invalid without any player' do
            Game.new(@valid_attributes.reject{|k,v| k == :players}).should_not be_valid
        end
    end

    it "can mass_assign associated Player objects" do
        game_attrs = FactoryGirl.attributes_for(:game)
        game_attrs[:players_attributes] =
            [ {:name => 'Dude'}, {:name => 'Donny'} ]
        new_game = Game.new(game_attrs)

        new_game.should have(2).players
    end

    it 'doesn\'t save associated players with blank names when mass_assigned' do
        game_attrs = FactoryGirl.attributes_for(:game)
        game_attrs[:players_attributes] =
            [ {:name => 'Dude'}, {:name => ''}, {:name => ''} ]
        new_game = Game.create(game_attrs)

        new_game.players.should have(1).players
    end

    it 'doesn\'t save associated players with duplicate names when mass_assigned' do
        game_attrs = FactoryGirl.attributes_for(:game)
        game_attrs[:players_attributes] =
            [ {:name => 'Dude'}, {:name => 'Donny'}, {:name => 'Dude'} ]
        new_game = Game.create(game_attrs)

        new_game.players.should have(2).players
    end

    it "has the associated players sorted by their names" do
        player_names = game.players.map(&:name) + %w{Donny Dude Walter}
        Factory(:player, :name => 'Walter', :game => game)
        Factory(:player, :name => 'Dude', :game => game)
        Factory(:player, :name => 'Donny', :game => game)

        game.reload.players.map(&:name).should == player_names.sort
    end

    it 'has the associated frames sorted by round and player name' do
        walter = Factory(:player, :name => 'Walter', :game => game)
        donny = Factory(:player, :name => 'Donny', :game => game)
        Factory(:frame, :round => 2, :player => walter)
        Factory(:frame, :round => 1, :player => walter)
        Factory(:frame, :round => 3, :player => donny)
        Factory(:frame, :round => 2, :player => donny)
        Factory(:frame, :round => 1, :player => donny)
        game.frames.map(&:round).should == [1, 1, 2, 2, 3]
        game.frames.map(&:player).map(&:name).should == [
            'Donny', 'Walter',
            'Donny', 'Walter',
            'Donny'
        ]
    end

    describe '#next_player' do
        context 'when the game has no frames associated' do
            before do
                game.stub(:game_over? => false)
            end
            it 'returns the first player, when no frame is saved yet' do
                game.next_player.should == game.players.first
            end
        end

        context 'when the game has some frames associated' do

            before do
                game.stub(:game_over? => false)
                game.players.each do |player|
                    5.times do |i|
                        Factory(:frame, :player => player, :round => i+1)
                    end
                end
            end

            context 'when the last frames player is not the last one in #players' do
                it 'returns the next one' do
                    Factory(:frame, :player => game.players.first, :round => 6)
                    game.next_player.should == game.players[1]
                end
            end

            context 'when the last frames player is the last one in #players' do
                context 'when game is not over yet' do
                    before do
                        game.stub(:game_over? => false)
                    end
                    it 'returns the first player' do
                        game.next_player.should == game.players[0]
                    end
                end
                context 'when the game is over yet' do
                    before do
                        game.stub(:game_over? => true)
                    end
                    it 'returns nil' do
                        game.next_player.should be_nil
                    end
                end
            end
        end
    end


    describe '#add_next_frame' do
        context 'when Game is over' do
            before do
                game.stub(:game_over? => true)
            end
            it 'returns nil' do
                game.add_next_frame.should be_nil
            end
        end
        context 'when Game is running' do
            before do
                game.stub(:game_over? => false)
                game.stub(:next_player => game.players.first)
            end

            it 'returns a new Frame by calling #next_player.add_frame' do
                expected_next_player = game.players.first
                game.should_receive(:next_player).and_return(
                    expected_next_player
                )
                expected_next_frame = mock('NextFrame')
                expected_next_player.should_receive(:add_frame).and_return(
                    expected_next_frame
                )
                game.add_next_frame.should == expected_next_frame
            end

        end
    end


    describe '#game_over?' do
        it 'returns true when every player has 10 completed frames' do
            game.stub_chain(:frames, :completed, :count).and_return(
                game.players.count * 10
            )
            game.game_over?.should be_true
        end

        it 'returns false when there are players with less than 10 completed frames' do
            game.stub_chain(:frames, :completed, :count).and_return(
                game.players.count * 6
            )
            game.game_over?.should be_false
        end
    end

end
