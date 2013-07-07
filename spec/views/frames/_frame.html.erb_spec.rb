require 'spec_helper'

describe 'frames/_frame.html.erb' do

    let :game do
        mock_model(Game, :players => 2.times.map{ |i|
            mock_model(Player, :name => "Dude #{i}").as_null_object
        })
    end

    let :current_frame do
        mock_model(Frame).as_null_object
    end

    before do
        assigns[:game] = game
        assigns[:current_frame] = current_frame
        @frame = mock_model(Frame).as_null_object
    end

    context 'when the @current_frame is not displayed' do

        before do
            @frame.should_receive(:first).and_return 0
            @frame.should_receive(:second).and_return 5
        end

        it 'renders the result of the 2 possible tries of the frame' do
            render :locals => {:frame => @frame}

            response.should have_tag 'div[class=?]', 'tries' do
                with_tag 'div', /0/
                with_tag 'div', /5/
            end
        end

        it 'renders no submit button' do
            render :locals => {:frame => @frame}

            response.should_not have_tag 'input[type=?]', 'submit'
        end
    end


    context 'when the @current_frame is displayed' do

        before do
            @frame = current_frame
            @frame.stub(:first => 0)
            @frame.stub(:second => 5)
            @frame.stub(:player_id => 42)
            @frame.stub(:round => 2)
        end

        it 'renders an input form for its 2 possible tries' do
            render :locals => {:frame => @frame}

            response.should have_tag 'form[method=?][action=?]',
                'post', game_frame_path(game, @frame) do
                with_tag 'div[class=?]', 'tries' do
                    with_tag 'input[type=?][name=?][id=?][value=?]',
                        'text', 'frame[first]', 'frame_first', @frame.first
                    with_tag 'input[type=?][name=?][id=?][value=?]',
                        'text', 'frame[second]', 'frame_second', @frame.second
                end
            end
        end

        it 'renders 3 inputs for its tries, when it\'s a strike or spare in 10th round'

        it 'renders an submit button' do
            render :locals => {:frame => @frame}

            response.should have_tag 'input[type=?]', 'submit'
        end

        it 'renders an hidden field for the Player of the @current_frame' do
            render :locals => {:frame => @frame}

            response.should have_tag 'input[type=?][name=?][id=?][value=?]',
                'hidden', 'frame[player_id]', 'frame_player_id', @frame.player_id
        end

        it 'renders an hidden field for the round of the @current_frame' do
            render :locals => {:frame => @frame}

            response.should have_tag 'input[type=?][name=?][id=?][value=?]',
                'hidden', 'frame[round]', 'frame_round', @frame.round
        end
    end

    it 'renders a field for the current score of the frame' do
        @frame.stub(:score => '120')
        render :locals => {:frame => @frame}

        response.should have_tag 'div[class=?]', 'score', /120/
    end

end
