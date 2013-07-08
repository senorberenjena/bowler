# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def render_first_try(frame)
        frame.strike? ? 'X' : frame.first
    end

    def render_second_try(frame)
        frame.strike? ? (frame.round < 10 ? '&nbsp;' : frame.second) :
            (frame.spare? ? '/' : frame.second)
    end

    def render_quote
        q = Quote.random
        content_tag :span, "What the Dude says: #{q.quote}" if q
    end
end
