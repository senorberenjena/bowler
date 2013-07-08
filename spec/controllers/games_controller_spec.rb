require 'spec_helper'

describe GamesController do
    describe 'GET index (/games)' do
        let(:games) do
             3.times.map{ |i| mock_model(Game, :title => "Dude with #{i} White Russians") }
        end

        before do
            Game.stub(:find).and_return(games)
        end

        it 'fetches all games of the db' do
            Game.should_receive(:find).with(:all).and_return(:games)
            get :index
        end

        it 'assigns @games' do
            get :index
            assigns[:games].should == games
        end

        it 'renders the index template' do
            get :index
            response.should render_template('index')
        end
    end

    describe 'GET new (/games/new)' do
        let(:game) {mock_model(Game).as_new_record.as_null_object}

        before do
            Game.stub(:new).and_return(game)
        end

        it 'creates a new empty Game' do
            Game.should_receive(:new).and_return(game)
            get :new
        end

        it 'assigns @game' do
            get :new
            assigns[:game].should == game
        end

        it 'renders the new template' do
            get :new
            response.should render_template('new')
        end

    end

    describe 'POST create (/games)' do
        let(:game) { mock_model(Game).as_null_object }

        before do
            Game.stub(:new).and_return(game)
        end

        it 'creates a new Game' do
            Game.should_receive(:new).with('title' => 'Go ahead Donny!').and_return(game)
            post :create, :game => { 'title' => 'Go ahead Donny!' }
        end

        context 'when it should add a new player input field' do
            it 'assigns @game' do
                post :create, :add_player => 'Buttonbeschriftung'
                assigns[:game].should == game
            end

            it 'renders the new template' do
                post :create, :add_player => 'Buttonbeschriftung'
                response.should render_template('new')
            end

            it 'does not save the game' do
                game.should_not_receive(:save)
                post :create, :add_player => 'Buttonbeschriftung'
            end

        end

        context 'when the Game gets saved successfully' do
            before do
                game.stub(:save).and_return(true)
            end

            it 'saves the Game' do
                game.should_receive(:save).and_return(true)
                post :create, :commit => 'Dings'
            end

            it 'redirects to Frames new page' do
                post :create, :commit => 'Dings'
                response.should redirect_to(new_game_frame_path(game))
            end
        end

        context 'when the Game doesn\'t save without errors' do
            before do
                game.stub(:save).and_return(false)
            end

            it 'assigns @game' do
                post :create
                assigns[:game].should == game
            end

            it 'renders the new template' do
                post :create
                response.should render_template('new')
            end

        end
    end


    describe 'GET show (/games/<Game>)' do
        let(:game) {mock_model(Game).as_null_object}

        before do
            Game.stub(:find).and_return(game)
        end

        it 'finds the given Game' do
            Game.should_receive(:find).with('1').and_return(game)
            get :show, :id => 1
        end

        it 'assigns @game' do
            get :show, :id => 1
            assigns[:game].should == game
        end

        context 'when game is over' do
            before do
                game.stub(:game_over? => true)
            end

            it 'renders the show template' do
                get :show, :id => 1
                response.should render_template('show')
            end
        end

        context 'when game is running' do
            before do
                game.stub(:game_over? => false)
            end

            it 'redirects to Frames new  page' do
                get :show, :id => 1
                response.should redirect_to(new_game_frame_path(game))
            end
        end
    end

end