class MatchStatsController < ApplicationController
  before_action :set_tournament_and_user
  before_action :set_match
  before_action :authenticate_user!, except: [:index, :show]
  def new
    @match_stat = @match.match_stat || @match.build_match_stat
  end

  def show
    @tournament = Tournament.find(params[:tournament_id])
    @match = @tournament.matches.find(params[:match_id])
    @match_stat = @match.match_stat
    @match_stat.data ||= "[]"
  end

  def create
    data = params[:match_stat][:data]
    @match_stat = MatchStat.new(match_stat_params)
    @match_stat.match = @match
  
    respond_to do |format|
      if @match_stat.save
        @match.update(match_stat_data: @match_stat.data)
        match_stat_data = JSON.parse(data) if data.present?
        match_stat_data ||= []
        if match_stat_data.is_a?(Array)
          match_stat_data.map! do |item|
            item.is_a?(Hash) ? item.transform_values { |value| value.transform_keys(&:to_i) } : item
          end
          @match.update(match_stat_data: match_stat_data.to_json) # Обновление атрибута match_stat_data
        end
        format.json { render json: { success: true, message: "Match stat created successfully." } }
      else
        format.json { render json: { success: false, errors: @match_stat.errors.full_messages } }
      end
    end
  end


  def edit
    if @user == current_user  || current_user.role == 'admin'
      @match_stat = @match.match_stat
    else
      redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
    end
    
  end

  def update
    
    if @user == current_user || current_user.role == 'admin'
      @match_stat = @match.match_stat || @match.build_match_stat
      if @match_stat.update(match_stat_params)
        redirect_to tournament_match_path(@tournament, @match), notice: 'Данные таблицы успешно обновлены'
      else
        render :edit
      end
    else
      redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
    end
  end

  def destroy
    if @user == current_user || current_user.role == 'admin'
      @match_stat = @match.match_stat
      @match_stat.destroy
    else
      redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
    end
    
    #redirect_to tournament_match_path(@tournament, @match), notice: "Match stat deleted successfully."
  end

  private

  def set_tournament_and_user
    @tournament = Tournament.find(params[:tournament_id])
    @user = @tournament.user
  end

  def set_match
    @match = @tournament.matches.find(params[:match_id])
  end

  def match_stat_params
    params.require(:match_stat).permit(:data, :match_id)
  end
end