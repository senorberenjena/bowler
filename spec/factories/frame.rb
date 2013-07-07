FactoryGirl.define do
    factory :frame do
        round 1
        association :player
        tries []
    end

    trait :running do
        tries [3]
    end

    trait :open do
        tries [3, 6]
    end

    trait :strike do
        tries [10]
    end

    trait :spare do
        tries [2, 8]
    end
end