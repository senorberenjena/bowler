class CreateGames < ActiveRecord::Migration
    def self.up
        create_table :games do |t|
            t.column :title, :string, :null => false
            t.timestamps
        end
    end

    def self.down
        drop_table :games
    end
end
