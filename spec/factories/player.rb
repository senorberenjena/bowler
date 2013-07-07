FactoryGirl.define do
    factory :player do
        sequence(:name) { |n| "Dude#{n}" }
        association :game
    end

    trait :with_frames do
        ignore do
            number_of_frames 3
        end

        after_create do |player, evaluator|
            FactoryGirl.create_list :frame, evaluator.number_of_frames, :player => player
            player.reload
        end
    end
end