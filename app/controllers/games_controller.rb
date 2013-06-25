class GamesController < ApplicationController

    def index
        @games = Game.find(:all)
    end

    def new
        @game = Game.new
    end

    def create
        @game = Game.new(params[:game])
        if @game.save
            redirect_to new_game_frame_path(@game)
        else
            render :action => 'new'
        end
    end

end