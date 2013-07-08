FactoryGirl.define do
    factory :frame do
        round 1
        association :player
        tries []
    end
end