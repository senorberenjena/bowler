class AddCompletedFlagToFrames < ActiveRecord::Migration
    def self.up
        add_column :frames, :completed, :boolean, :default => false
    end

    def self.down
        remove_column :frames, :completed
    end
end