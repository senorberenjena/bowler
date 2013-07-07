class Frame < ActiveRecord::Base
    belongs_to :player

    validates_numericality_of :round, :only_integer => true,
        :greater_than => 0, :less_than => 11
    validates_uniqueness_of :round, :scope => :player_id, :message => "must be unique for a specific player"
    validates_each :tries do |model, attr, value|
        if value.is_a?(Array)
            value.each do |try|
                model.errors.add(attr, 'must be an array of integers') unless try.is_a?(Integer)
                model.errors.add(attr, 'must contain tries with a value between 0 and 10') unless (try.is_a?(Integer) && try >= 0 && try <= 10)
            end
        else
            model.errors.add(attr, 'must be an array')
        end
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
        return open? || (strike? || spare?) && (round < 10 || tries.size == 3)
    end
end
