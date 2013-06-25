Factory.define :player do |p|
    p.sequence(:name) { |n| "Dude#{n}" }
    p.association :game
end