require 'spec_helper'

describe Game do
    before(:each) do
        @valid_attributes = {
            :title => 'Saving Donny'
        }
    end

    it "can be instantiated" do
        Game.new.should be_an_instance_of(Game)
    end

    it "should create a new instance given valid attributes" do
        Game.create!(@valid_attributes)
    end

    it 'is invalid when no title is given' do
        Game.new.should_not be_valid
    end

    it "can mass_assign associated Player objects" do
        game_attrs = FactoryGirl.attributes_for(:game)
        game_attrs[:players_attributes] =
            [ {:name => 'Dude'}, {:name => 'Donny'} ]
        new_game = Game.new(game_attrs)
        new_game.should have(2).players
    end

    it "has the associated players sorted by their names" do
        game = Factory(:game)
        game.players << Factory(:player, :name => 'Walter', :game => game)
        game.players << Factory(:player, :name => 'Dude', :game => game)
        game.players << Factory(:player, :name => 'Donny', :game => game)

        game.players.map(&:name).should == %w{Donny Dude Walter}
    end
end
