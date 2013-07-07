require 'spec_helper'

describe Player do

    let(:player) {Factory(:player)}

    before(:each) do
        @valid_attributes = {
            :name => 'Dude',
            :game_id => '1'
        }
    end

    it "can be instantiated" do
        Player.new.should be_an_instance_of(Player)
    end

    it "should create a new instance given valid attributes" do
        Player.create!(@valid_attributes)
    end

    it 'is invalid without a name' do
        Factory.build(:player, :name => '').should_not be_valid
    end

    it 'is invalid, when there is already a player with the same name in its game' do
        Player.create(@valid_attributes)
        Player.new(@valid_attributes).valid?.should == false
    end



    describe '#add_frame' do
        before do
            player.stub(:next_round)
            player.game.stub(:game_over?).and_return(false)
        end

        it 'returns nil, when Game is over' do
            player.game.should_receive(:game_over?).and_return(true)
            player.add_frame.should == nil
        end

        it 'creates and returns a new frame for the player' do
            new_frame = Factory.build(:frame)
            Frame.should_receive(:new).and_return(new_frame)
            player.add_frame.should == new_frame
        end

        it 'increments the round of the frame each time it is called' do
            player.should_receive(:next_round).and_return(4)
            player.add_frame.round.should == 4
        end

        it 'associates the Frame with the Player' do
            player.add_frame.player.should == player
        end

        it 'associates the Player with the Frames' do
            player.frames.should include(player.add_frame)
        end

    end



    describe '#next_round' do
        before do
            5.times do |i|
                Factory(:frame, :player => player, :round => i+1)
            end
        end

        it 'increments the round value of the last player#frames' do
            player.next_round.should == 6
        end

        it 'returns nil, when there are already 10 frames for this player' do
            5.times do |i|
                Factory(:frame, :player => player, :round => i+6)
            end
            player.next_round.should be_nil
        end
    end

end
