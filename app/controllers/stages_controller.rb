class StagesController < ApplicationController
    include StagesHelper
    before_action :set_stage, only: [ :edit, :update, :destroy, :ring_games_generate, :ring_games_swap_from_stage, :cup_games_generate]
    before_action :set_champ

    def index
      @stages = Stage.all
    end

    def new
      authorize! :manage, Stage
      @stage = Stage.new
    end

    def edit
      authorize! :manage, Stage
    end

    def create
      authorize! :manage, Stage
      @stage = @champ.stages.new(stage_params)

      if @stage.save
        redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
      else
        render action: 'new', error: 'Ошибка при добавлении'
      end
    end

    def destroy
      authorize! :manage, Stage
      if @stage.destroy
        redirect_to edit_champ_path(@champ), notice: 'OK'
      else
        render action: 'edit', error: 'Ошибка при удалении'
      end
    end

    def update
      authorize! :manage, Stage
      if @stage.update_attributes(stage_params)
        redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
      else
        render action: 'edit', error: 'Ошибка при обновлении'
      end

    end


    def ring_games_swap_from_stage
      ring_games_swap @stage, params[:parent_stage]
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    end

    def ring_games_generate
      ring_games_gen @stage
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    end

    def cup_games_generate
      teams_cnt = params[:teams_count]
      cup_games_gen @stage, teams_cnt
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    end


  private
    def set_champ
      @champ = Champ.find(params[:champ_id])
    end
    def set_stage
      @stage = Stage.find(params[:id])
    end
    def stage_params
      params[:stage].permit(:title, :stage_type, :status)
    end

end