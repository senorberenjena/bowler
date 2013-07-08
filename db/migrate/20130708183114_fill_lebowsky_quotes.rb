class FillLebowskyQuotes < ActiveRecord::Migration
    def self.up
        Quote.create :quote => "Oh, the usual. I bowl. Drive around. The occasional acid flashback."
        Quote.create :quote => "That's a great plan, Walter. That's f*ckin' ingenious, if I understand it correctly. It's a Swiss fuckin' watch."
        Quote.create :quote => "God damn you Walter! You f*ckin' *sshole! Everything's a f*ckin' travesty with you, man! And what was all that sh*t about Vietnam? What the F*CK, has anything got to do with Vietnam? What the f*ck are you talking about?"
        Quote.create :quote => "F*ck sympathy! I don't need your f*ckin' sympathy, man, I need my f*cking johnson!"
        Quote.create :quote => "Obviously you're not a golfer."
        Quote.create :quote => "She's not my special lady, she's my f*cking lady friend. I'm just helping her conceive, man!"
        Quote.create :quote => "Where's the f*cking money Lebowski?"
        Quote.create :quote => "That rug really tied the room together."
        Quote.create :quote => "It's like what Lenin said... you look for the person who will benefit, and, uh, uh..."
        Quote.create :quote => "Hey, careful, man, there's a beverage here!"
        Quote.create :quote => "Yeah, well, you know, that's just, like, your opinion, man."
        Quote.create :quote => "Mind if I do a J?"
        Quote.create :quote => "Come on, man. I had a rough night and I hate the f*ckin' Eagles, man!"
        Quote.create :quote => "F*ckin' A, man. I got a rash, man."
        Quote.create :quote => "Nobody calls me Lebowski. You got the wrong guy. I'm the Dude, man."
        Quote.create :quote => "Yeah, well. The Dude abides."
        Quote.create :quote => "This is a very complicated case, Maude. You know, a lotta ins, a lotta outs, a lotta what-have-yous. And, uh, a lotta strands to keep in my head, man. Lotta strands in old Duder's head. Fortunately, I'm adhering to a pretty strict, uh, drug regimen to keep my mind, you know, uh, limber."
        Quote.create :quote => "You mean coitus?"
        Quote.create :quote => "I dropped off the money exactly as per... look, man, I've got certain information, all right? Certain things have come to light. And, you know, has it ever occurred to you, that, instead of, uh, you know, running around, uh, uh, blaming me, you know, given the nature of all this new shit, you know, I-I-I-I... this could be a-a-a-a lot more, uh, uh, uh, uh, uh, uh, complex, I mean, it's not just, it might not be just such a simple... uh, you know?"
        Quote.create :quote => "You human... paraquat"
        Quote.create :quote => "Let me explain something to you. Um, I am not \"Mr. Lebowski\". You're Mr. Lebowski. I'm the Dude. So that's what you call me. You know, that or, uh, His Dudeness, or uh, Duder, or El Duderino if you're not into the whole brevity thing."
        Quote.create :quote => "Oh boy. How ya gonna keep 'em down on the farm once they've seen Karl Hungus."
        Quote.create :quote => "Oh, uh, yeah, uh... a tape deck, some Creedence tapes, and there was a, uh... uh, my briefcase."
        Quote.create :quote => "I do mind, the Dude minds. This will not stand, ya know, this aggression will not stand, man."
    end

    def self.down
        Quote.destroy_all
    end
end
