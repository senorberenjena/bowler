class CreateFrames < ActiveRecord::Migration
    def self.up
        create_table :frames do |t|
            t.column :round, :integer, :null => false
            t.column :player_id, :integer, :null => false

            t.column :tries, :string
            t.column :score, :integer

            t.timestamps
        end

        add_index :frames, [:round, :player_id], :unique => true
    end

    def self.down
        remove_index :frames, :column => [:round, :player_id]
        drop_table :frames
    end
end