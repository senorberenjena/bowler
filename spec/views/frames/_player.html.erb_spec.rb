require 'spec_helper'

describe 'frames/_player.html.erb' do

    let :game do
        mock_model(Game, :players => 2.times.map{ |i|
            mock_model(Player, :name => "Dude #{i}").as_null_object
        })
    end

    before do
        assigns[:game] = game
        @player = game.players.first
    end


    it 'renders a scoresheet of the player' do
        render :locals => {:player => @player}
        response.should have_tag 'div[id=?]', "player_#{@player.id}" do
            with_tag 'div[class=?]', 'name', @player.name
            with_tag 'div[class=?]', 'scoresheet'
        end
    end

    it 'renders the partial _frame.html.erb for all past frames of the player' do
        @player.stub(:frames => [mock_model(Frame), mock_model(Frame)])
        template.should_receive(:render).with({:partial => 'frame', :collection => @player.frames})
        render :locals => {:player => @player}
    end

end
