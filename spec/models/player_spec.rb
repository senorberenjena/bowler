require 'spec_helper'

describe Player do
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

    it 'is invalid, when there is already a player with the same name in its game'

    describe '#add_frame!' do

        before(:each) do
            @player = Factory(:player)
        end

        it 'creates and returns a new empty frame for the player'

        it 'increments the round of the frame each time it is called'

        it 'can only be called 10 times, afterwards it does nothing and returns nil'

    end


end
