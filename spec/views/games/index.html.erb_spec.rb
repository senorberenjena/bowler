require 'spec_helper'

describe 'games/index.html.erb' do

    let :games do
        3.times.map{ |i| mock_model(Game, :title => "Dude with #{i} White Russians") }
    end

    before do
        assigns[:games] = games
    end

    it 'has an link to start a new Game' do
        render
        response.should have_tag('a[href=?]', new_game_path)
    end

    it 'lists all Games in the DB' do
        render
        response.should have_tag('ul') do
            games.each do |game|
                with_tag('li', game.title)
            end
        end
    end

    it 'links to all Games in the DB' do
        render
        games.each do |game|
            response.should have_tag('a[href=?]', game_path(game))
        end
    end

end