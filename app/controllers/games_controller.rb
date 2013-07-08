class GamesController < ApplicationController

    def index
        @title = 'All Games'
        @games = Game.find(:all)
    end

    def new
        @title = 'Start new Game'
        @game = Game.new
    end

    def create
        @game = Game.new(params[:game])
        if params.include?(:commit) && @game.save
            redirect_to new_game_frame_path(@game)
        else
            @title = 'Start new Game'
            render :action => 'new'
        end
    end

    def show
        @game = Game.find(params[:id])
        if @game.game_over?
            @title = 'Results'
        else
            redirect_to new_game_frame_path(@game)
        end
    end

end