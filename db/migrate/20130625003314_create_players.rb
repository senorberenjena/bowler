class CreatePlayers < ActiveRecord::Migration
    def self.up
        create_table :players do |t|
            t.column :name, :string, :null => false
            t.column :game_id, :integer, :null => false
            t.timestamps
        end
    end

    def self.down
        drop_table :players
    end
end
