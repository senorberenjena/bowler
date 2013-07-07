class FramesController < ApplicationController

    def new
        @game = Game.find(params[:game_id])
        @current_frame = @game.add_next_frame
        render :action => :edit
    end
end