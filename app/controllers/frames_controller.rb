class FramesController < ApplicationController

    def new
        @game = Game.find(params[:game_id])
        @title = "Play Game"
        @current_frame = @game.add_next_frame
        render :action => :edit
    end

    def create
        @game = Game.find(params[:game_id])
        @current_frame = @game.add_frame(params[:frame])

        if @current_frame.nil? || (@current_frame.valid? && @current_frame.completed? && @current_frame.save)
            redirect_to new_game_frame_path(@game)
        else
            render :action => :edit
        end
    end
end