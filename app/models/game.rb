class Game < ActiveRecord::Base
    has_many :players, :order => :name
    accepts_nested_attributes_for :players

    validates_presence_of :title
end
