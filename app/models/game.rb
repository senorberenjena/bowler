class Game < ActiveRecord::Base
    has_many :players, :order => :name
    has_many :frames, :through => :players, :order => 'frames.round, players.name'

    accepts_nested_attributes_for :players, :reject_if => :reject_nested_player

    validates_associated :players
    validates_presence_of :title
    validate :must_have_one_player

    def next_player
        return @next_player ||= (game_over? ? nil : players[next_player_index])
    end

    def add_next_frame
        unless game_over?
            return @next_frame ||= next_player.add_frame()
        end
    end

    def game_over?
        return frames.completed.count == players.count * 10
    end

    private

    def next_player_index
        return @next_player_index ||= if frames.empty?
            0
        else
            (players.index(frames.last.player) + 1) % players.count
        end
    end

    # Mass-Assignment during creation can't validate the uniquness of the players
    # in the scope of their associated Game (-> https://github.com/rails/rails/issues/1572),
    # so we do a more or less dirty workaround here:
    # We reject empty and duplicate names when mass assigning nested Player attributes!
    def reject_nested_player(attrs)
        return attrs[:name].blank? || (players.map(&:name).include?(attrs[:name]))
    end

    def must_have_one_player
        errors.add(:players, 'must have at least one player') if players.empty?
    end

end
