class Frame < ActiveRecord::Base
    belongs_to :player

    named_scope :completed, :conditions => {:completed => true}

    serialize :tries, Array

    validates_numericality_of :round, :only_integer => true,
        :greater_than => 0, :less_than => 11
    validates_uniqueness_of :round, :scope => :player_id, :message => "must be unique for a specific player"
    validate :validates_tries

    before_save :update_completed
    def after_initialize
        self.tries ||= []
    end

    def status
        return 'running' if !completed?
        return 'strike' if strike?
        return 'spare' if spare?
        return 'open' if open?
    end

    def strike?
        tries.any? && tries.first == 10
    end

    def spare?
        tries.any? && tries.size >= 2 && (tries[0] + tries[1]) == 10
    end

    def open?
        tries.any? && tries.size == 2 && (tries[0] + tries[1]) < 10
    end

    def completed?
        (new_record? || changed?) ? check_completed : read_attribute(:completed)
    end

    # Always checks if the frame is completed
    def check_completed
        return open? || (strike? || spare?) && (round < 10 || tries.size == 3)
    end

    def first
        self.tries.first
    end

    def first=(value)
        self.tries[0] = value.to_i
    end

    def second
        self.tries[1]
    end

    def second=(value)
        self.tries[1] = value.to_i unless self.strike? && self.round < 10
    end

    def third
        self.tries[2]
    end

    def third=(value)
        self.tries[2] = value.to_i
    end

    # TODO: spec & aufräumen
    def score
        if self.completed?
            result = self.tries.sum
            if (self.strike?)
                result += next_frame.tries.first if (next_frame && next_frame.completed?)
                if (next_frame && next_frame.open?)
                    result += next_frame.tries.second
                elsif (next_frame && next_frame.strike? && next_frame.next_frame && next_frame.next_frame.completed?)
                    result += next_frame.next_frame.tries.first
                elsif (next_frame && next_frame.strike? && next_frame.round == 10)
                    result += next_frame.tries.second
                end
            elsif (self.spare?)
                result += next_frame.tries.first if (next_frame && next_frame.completed?)
            end
            return result
        end
    end

    # TODO: spec!
    def summarized_score
        previous_score = previous_frames.inject(0){|sum,f| sum += f.score}
        previous_score += score if (self.completed?)
    end

    # TODO: spec!
    def next_frame
        @next_frame ||= Frame.find(:first, :conditions => {:player_id => player.id, :round => round + 1})
    end

    # TODO: spec!
    def previous_frames
        @previous_frames ||= Frame.find(:all, :conditions => ['player_id=? AND round <?', player.id, round])
    end

    private

    def validates_tries
        tries.each do |try|
            errors.add(:tries, 'must be an array of integers') unless try.is_a?(Integer)
            errors.add(:tries, 'must contain tries with a value between 0 and 10') unless (try.is_a?(Integer) && try >= 0 && try <= 10)
        end
        if (errors.empty?)
            errors.add(:tries, 'sum must not be greater than 10 in the first 9 rounds') if (tries.sum > 10 && self.round < 10)
            errors.add(:tries, 'must not not contain more than 2 tries in the first 9 rounds') if (tries.size > 2 && self.round < 10)
            errors.add(:tries, 'must not not contain more than 2 tries in the last round, except it is a spare or a strike') if (tries.size > 2 && self.round == 10 && !(self.strike? || self.spare?))
        end
    end

    def update_completed
        self.completed = self.check_completed if (self.new_record? || self.changed?)
        return true
    end

end
