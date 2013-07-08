class CreateLebowskiQuotes < ActiveRecord::Migration
    def self.up
        create_table :quotes, :force => true do |t|
          t.string :quote
          t.timestamps
        end
    end

    def self.down
        drop_table :quotes
    end
end