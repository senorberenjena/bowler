require 'spec_helper'

describe 'games/new.html.erb' do

    let :game do
        mock_model(Game).as_new_record.as_null_object
    end

    let :players do
        3.times.map{ |i|
            mock_model(Player, :name => "Dude #{i}").as_null_object.as_new_record
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
        game.stub(:title => 'Entering the world of pain')
        render
        response.should have_tag 'input[type=?][name=?][value=?]',
            'text', 'game[title]', 'Entering the world of pain'
    end

    it 'renders a title label for its text field' do
        render
        response.should have_tag 'label[for=?]', 'game_title', 'Titel'
    end

    context 'for the players' do
        it 'renders a container div for the players to be entered' do
            render
            response.should have_tag 'div[id=?]', 'players'
        end

        it 'renders a text field for every @game.players' do
            game.stub(:players).and_return(players)
            render
            players.each do |player|
                response.should have_tag 'input[type=?][name=?][id=?][value=?]',
                    'text', 'game[players][name]', 'game_players_name', player.name
            end
        end

        it 'renders a text field for the name of a new player' do
            render
            response.should have_tag 'input[type=?][name=?][id=?]',
                'text', 'game[players][name]', 'game_players_name'
        end

        it 'renders a label for all player text fields' do
            game.stub(:players).and_return(players)
            render
            response.should have_tag 'label[for=?]', 'game_players_name', players.size + 1
        end
    end

end