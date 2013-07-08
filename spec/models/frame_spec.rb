require 'spec_helper'

describe Frame do

    let (:frame) {Factory(:frame)}
    let (:frame_running) {Factory(:frame, :tries => [3])}
    let (:frame_open) {Factory(:frame, :tries => [3, 6])}
    let (:frame_strike) {Factory(:frame, :tries => [10])}
    let (:frame_spare) {Factory(:frame, :tries => [3, 7])}

    before(:each) do
        @valid_attributes = {
            :round => 1,
            :player_id => 1
        }
    end

    it "can be instantiated" do
        Frame.new.should be_an_instance_of(Frame)
    end

    it 'has #tries set per default to an empty Array' do
        Frame.new.tries.should == []
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

        it 'raises an error when tries beeing not an array' do
            expect {
                Factory.build(:frame, :tries => 'dings').should_not be_valid
            }.to raise_error
        end

        it 'is not valid with a try other than an integer' do
            Factory.build(:frame, :tries => ['ab']).should_not be_valid
        end

        it 'is not valid with a try higher than 10' do
            Factory.build(:frame, :tries => [12]).should_not be_valid
        end

        it 'is not valid with a sum of tries higher than 10 in the first 9 rounds' do
            Factory.build(:frame, :round => 9, :tries => [3, 8]).should_not be_valid
        end

        it 'is not valid with more than 2 tries in the first 9 rounds' do
            Factory.build(:frame, :round => 9, :tries => [2, 2, 3]).should_not be_valid
        end

        it 'is not valid with more than 2 tries in the last round when its neither a strike nor a spare' do
            Factory.build(:frame, :round => 10, :tries => [2, 2, 3]).should_not be_valid
        end

        it 'is valid with 3 tries in the last round, when it\'s a spare or a strike' do
            Factory.build(:frame, :round => 10, :tries => [10, 10, 3]).should be_valid
            Factory.build(:frame, :round => 10, :tries => [7, 3, 3]).should be_valid
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

    context 'before it gets saved it' do
        it 'updates its completed attribute before it gets saved' do
            frame.should_receive(:completed=)
            frame.tries = [2,3]
            frame.save
        end
    end

    describe '#completed?' do
        it 'calls check_completed if it is a new record' do
            frame.should_receive(:new_record?).and_return(true)
            frame.should_receive(:check_completed)
            frame.completed?
        end

        it 'calls check_completed if it is a changed (dirty) record' do
            frame.should_receive(:changed?).and_return(true)
            frame.should_receive(:check_completed)
            frame.completed?
        end

        it 'reads the completed attribute from the db, when it is not dirty' do
            frame.should_receive(:changed?).and_return(false)
            frame.should_receive(:read_attribute).with(:completed)
            frame.completed?
        end
    end

    describe '#check_completed' do
        it 'is completed when it is an open frame' do
            frame.should_receive(:open?).and_return(true)
            frame.check_completed.should be_true
        end

        context 'in the first 9 rounds' do
            it 'is completed when it is a strike' do
                frame_strike.should_receive(:round).and_return(8)
                frame_strike.should_receive(:strike?).and_return(true)
                frame_strike.check_completed.should be_true
            end

            it 'is completed when it is a spare' do
                frame_spare.should_receive(:round).and_return(6)
                frame_spare.should_receive(:spare?).and_return(true)
                frame_spare.check_completed.should be_true
            end
        end

        context 'in the last round' do
            it 'is completed when it is a strike and has 3 tries' do
                frame_strike.tries << 4 << 5
                frame_strike.should_receive(:round).and_return(10)
                frame_strike.should_receive(:strike?).and_return(true)
                frame_strike.check_completed.should be_true
            end

            it 'is completed when it is a spare and has 3 tries' do
                frame_spare.tries << 10
                frame_spare.should_receive(:round).and_return(10)
                frame_spare.should_receive(:spare?).and_return(true)
                frame_spare.check_completed.should be_true
            end
        end
    end

    describe '#first' do
        it 'returns the first try if it is set' do
            frame.should_receive(:tries).and_return([2])
            frame.first.should == 2
        end

        it 'returns nil when not tries are set yet' do
            frame.should_receive(:tries).and_return([])
            frame.first.should == nil
        end
    end

    describe '#second' do
        it 'returns the second try when it is set' do
            frame.should_receive(:tries).and_return([2,3])
            frame.second.should == 3
        end

        it 'returns nil when no 2nd try is set yet' do
            frame.should_receive(:tries).and_return([2])
            frame.second.should == nil
        end
    end

    describe '#third' do
        it 'returns the third try when it is set' do
            frame.should_receive(:tries).and_return([3,7,10])
            frame.third.should == 10
        end

        it 'returns nil when no 3rd try is set yet' do
            frame.should_receive(:tries).and_return([2,8])
            frame.third.should == nil
        end
    end


    #
    # Scoring
    describe '#score' do
        it 'returns the sum of all tries' do
            frame_open.tries.should_receive(:sum).and_return(9)
            frame_open.score.should == 9
        end
    end


end
