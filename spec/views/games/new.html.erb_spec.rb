require 'spec_helper'

describe 'games/new.html.erb' do

    let :game do
        mock_model(Game).as_new_record.as_null_object
    end

    let :players do
        3.times.map{ |i|
            mock_model(Player, :name => "Dude #{i}").as_null_object
        }
    end

    before do
        assigns[:game] = game
    end

    it 'renders a form to create a new Game with a Start button' do
        render
        response.should have_tag 'form[method=?][action=?]', 'post', games_path do
            with_tag 'input[type=?][value=?]', 'submit', 'Start Game'
        end
    end

    it 'renders a text field for the title of the game' do
        assigns[:game].stub(:title => 'Entering the world of pain')
        render
        response.should have_tag 'input[type=?][name=?][value=?]',
            'text', 'game[title]', 'Entering the world of pain'
    end

    it 'renders a title label for its text field' do
        render
        response.should have_tag 'label[for=?]', 'game_title', 'Titel'
    end

    context 'for the players' do
        before do
            assigns[:game].stub(:players_attributes=) # mocked das accepts_nested_attributes_for im Game Model
            assigns[:game].stub(:players).and_return(players)
            Player.stub(:new).and_return(mock_model(Player).as_null_object.as_new_record) # für das leere Player Eingabefeld brauchts ein leeres Objekt
        end

        it 'renders a container div for the players to be entered' do
            render
            response.should have_tag 'div[id=?]', 'players'
        end

        it 'renders a text field for every @game.players' do
            render
            players.each_with_index do |player, i|
                response.should have_tag 'input[type=?][name=?][id=?][value=?]',
                    'text', "game[players_attributes][#{i}][name]", "game_players_attributes_#{i}_name", player.name
            end
        end

        it 'renders a text field for the name of a new player' do
            render
            response.should have_tag 'input[type=?][name=?][id=?]',
                'text', "game[players_attributes][#{players.size}][name]", "game_players_attributes_#{players.size}_name"
        end

        it 'renders a label for all player text fields' do
            render
            players.each_with_index do |player, i|
                response.should have_tag 'label[for=?]', "game_players_attributes_#{i}_name"
            end
            response.should have_tag 'label[for=?]', "game_players_attributes_#{players.size}_name"
        end
    end

end