require 'spec_helper'

describe '/frames/edit.html.erb' do

    let :game do
        mock_model(Game, :players => 2.times.map{ |i|
            mock_model(Player, :name => "Dude #{i}").as_null_object
        }).as_null_object
    end

    before do
        assigns[:game] = game
        assigns[:current_frame] = mock_model(Frame).as_null_object
    end

    it 'renders a container div around all players' do
        render
        response.should have_tag 'div[id=?]', 'players'
    end

    it 'renders the partial _player.html.erb for every player' do
        template.should_receive(:render).with({:partial => '/frames/player', :collection => game.players})
        render
    end

end

