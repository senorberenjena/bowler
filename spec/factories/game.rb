FactoryGirl.define do
    factory :game do
        title 'Entering the World of Pain'

        # Can manipulate the number of players associated with the game with
        # transient game attribute #players_count:
        # Factory(:game, :players_count => 200) will create a game with 200 Players
        ignore do
            players_count 3
        end

        after_build do |game, evaluator|
            evaluator.players_count.times do
                game.players << Factory.build(:player, :game => game)
            end
        end
        after_create do |game|
            game.players.each { |player| player.save! }
        end
    end

end