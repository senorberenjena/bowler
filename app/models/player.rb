class Player < ActiveRecord::Base
    belongs_to :game
    has_many :frames, :order => 'round'

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => :game_id

    def add_frame
        unless game.game_over?
            return @new_frame ||= frames.build(:player => self, :round => next_round)
        end
    end

    def next_round
        frames.empty? ? 1 : frames.last.round == 10 ? nil : frames.last.round + 1
    end
end
