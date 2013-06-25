class Game < ActiveRecord::Base
    has_many :players, :order => :name

    validates_presence_of :title
end
