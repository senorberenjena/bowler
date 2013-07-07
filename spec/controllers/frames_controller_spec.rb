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
end