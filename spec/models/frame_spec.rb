require 'spec_helper'

describe Frame do

    let (:frame) {Factory(:frame)}
    let (:frame_running) {Factory(:frame, :running)}
    let (:frame_open) {Factory(:frame, :open)}
    let (:frame_strike) {Factory(:frame, :strike)}
    let (:frame_spare) {Factory(:frame, :spare)}

    before(:each) do
        @valid_attributes = {
            :round => 1,
            :tries => [],
            :player_id => 1
        }
    end

    it "can be instantiated" do
        Frame.new.should be_an_instance_of(Frame)
    end

    context 'validation' do

        it "should create a new instance given valid attributes" do
            Frame.create!(@valid_attributes)
        end

        it 'is not valid, when round is set to an non-integer value' do
            Factory.build(:frame, :round => 3.4).should_not be_valid
        end

        it 'is not valid with a round > 10' do
            Factory.build(:frame, :round => 11).should_not be_valid
        end

        it 'is not valid with a round < 1' do
            Factory.build(:frame, :round => 0).should_not be_valid
        end

        it 'is not valid with tries beeing not an array' do
            Factory.build(:frame, :tries => 'dings').should_not be_valid
        end

        it 'is not valid with a try other than an integer' do
            Factory.build(:frame, :tries => ['ab']).should_not be_valid
        end

        it 'is not valid with a try higher than 10' do
            Factory.build(:frame, :tries => [12]).should_not be_valid
        end

        it 'belongs to a player' do
            Factory(:frame).player.should_not be_nil
        end

        it 'is not valid with a player beeing not unique under the scope of round' do
            f1 = Factory(:frame)
            Factory.build(:frame, :player => f1.player, :round => f1.round).should_not be_valid
        end
    end

    # # Solls das?
    # it 'should link to the previous frame by the same player - except when it\'s the first frame'

    # Soll vor dem Schreiben seinen Status updaten schreiben
    # Soll vor dem Speichern die Punkte schreiben (nur in Frame?, Game berechnet ondemand?)

    describe '#status' do
        # before do
        #     [frame, frame_running, frame_open, frame_strike, frame_spare].each do |f|
        #         f.stub(:completed?)
        #     end
        # end

        it 'is a running frame, when it is not completed' do
            frame_running.should_receive(:completed?).and_return(false)
            frame_running.status.should == 'running'
        end

        it 'is an open frame, when it has 2 tries and not all 10 pins are hit' do
            Factory(:frame, :tries => [2, 3]).status.should == 'open'
        end

        it 'is a strike, when 10 pins are hit by the first ball' do
            frame_strike.should_receive(:completed?).and_return(true)
            frame_strike.status.should == 'strike'
        end

        it 'is a spare, when 10 pins are hit by the second ball' do
            frame_spare.should_receive(:completed?).and_return(true)
            frame_spare.status.should == 'spare'
        end
    end

    #
    # Scoring

    it 'gives the sum of both balls as its score, when it is an open frame'

    describe '#completed?' do
        it 'is completed when it is an open frame' do
            frame.should_receive(:open?).and_return(true)
            frame.completed?.should be_true
        end

        context 'in the first 9 rounds' do
            it 'is completed when it is a strike' do
                frame_strike.should_receive(:round).and_return(8)
                frame_strike.should_receive(:strike?).and_return(true)
                frame_strike.completed?.should be_true
            end

            it 'is completed when it is a spare' do
                frame_spare.should_receive(:round).and_return(6)
                frame_spare.should_receive(:spare?).and_return(true)
                frame_spare.completed?.should be_true
            end
        end

        context 'in the last round' do
            it 'is completed when it is a strike and has 3 tries' do
                frame_strike.tries << 4 << 5
                frame_strike.should_receive(:round).and_return(10)
                frame_strike.should_receive(:strike?).and_return(true)
                frame_strike.completed?.should be_true
            end

            it 'is completed when it is a spare and has 3 tries' do
                frame_spare.tries << 10
                frame_spare.should_receive(:round).and_return(10)
                frame_spare.should_receive(:spare?).and_return(true)
                frame_spare.completed?.should be_true
            end
        end
    end

    describe '#hit!' do

        it 'does nothing, when the frame is completed already'

        it 'adds the given number of pins to the tries, when it is still not completed'

    end


end
