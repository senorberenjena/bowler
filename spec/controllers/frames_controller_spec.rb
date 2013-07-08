require 'spec_helper'

describe FramesController do
    describe 'GET new (/games/<Game>/frames/new)' do

        let(:game) { mock_model(Game, :id => 1).as_null_object }
        let(:new_frame) { mock_model(Frame).as_null_object.as_new_record }

        before do
            Game.stub(:find).and_return(game)
            game.stub(:add_next_frame).and_return(new_frame)
        end

        it 'finds the given game' do
            Game.should_receive(:find).with('1').and_return(game)
            get :new, :game_id => 1
        end

        it 'assigns @game' do
            get :new, :game_id => 1
            assigns[:game].should == game
        end

        context 'when Game is running' do
            before do
                game.stub(:game_over? => false)
            end

            it 'asks the game for the next frame' do
                game.should_receive(:add_next_frame).and_return(new_frame)
                get :new, :game_id => 1
            end

            it 'assigns @current_frame' do
                get :new, :game_id => 1
                assigns[:current_frame].should == new_frame
            end

            it 'renders the edit template' do
                get :new, :game_id => 1
                response.should render_template(:edit)
            end
        end

        context 'when Game is over' do
            before do
                game.stub(:game_over? => true)
            end

            it 'redirects to Game show path' do
                get :new, :game_id => 1
                response.should redirect_to(game_path(game))
            end
        end

    end

    describe 'POST create (/games/<Game>/frames)' do

        let(:game) { mock_model(Game).as_null_object }
        let(:new_frame) { mock_model(Frame).as_new_record.as_null_object }

        before do
            Game.stub(:find).and_return(game)
            game.stub(:add_frame).and_return(new_frame)
            @valid_params = {
                :game_id => 1,
                :frame => {
                    :player_id => 2,
                    :round => 6,
                    :tries => {
                        0 => 3,
                        1 => 7
                    }
                }
            }
        end

        it 'finds the given game' do
            Game.should_receive(:find).with('1').and_return(game)
            post :create, @valid_params
        end

        it 'assigns @game' do
            post :create, @valid_params
            assigns[:game].should == game
        end

        it 'it calls Game#add_frame with the given Frame params' do
            game.should_receive(:add_frame).with(
                hash_including(@valid_params[:frame])
            ).and_return(new_frame)
            post :create, @valid_params
        end

        context 'when it is not a completed Frame' do
            before do
                new_frame.stub(:completed?).and_return(false)
            end

            it 'doesn\'t get saved' do
                new_frame.should_not_receive(:save)
                post :create, @valid_params
            end

            it 'calls the validations for error message feedback to the user' do
                new_frame.should_receive(:valid?)
                post :create, @valid_params
            end

            it 'assigns the Frame to be created to @current_frame' do
                post :create, @valid_params
                assigns[:current_frame].should == new_frame
            end

            it 'renders the edit template' do
                post :create, @valid_params
                response.should render_template(:edit)
            end
        end

        context 'when it gets saved successfully' do
            before do
                new_frame.stub(:save).and_return(true)
            end

            it 'redirects to Frames new path' do
                post :create, @valid_params
                response.should redirect_to(new_game_frame_path(game))
            end
        end

        context 'when it gets not saved successfully' do
            before do
                new_frame.stub(:save).and_return(false)
            end

            it 'assigns the Frame to be created to @current_frame' do
                post :create, @valid_params
                assigns[:current_frame].should == new_frame
            end

            it 'renders the edit template' do
                post :create, @valid_params
                response.should render_template(:edit)
            end
        end
    end
end