class MatchesController < ApplicationController
  before_action :set_tournament_and_user, only: %i[edit update destroy show new create]
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @matches = Match.all
  end

	

  def show
    @match = @tournament.matches.find(params[:id])
    @match_stat = @match.match_stat
    @match_stat.data ||= "[]"
    @match_stat_data = JSON.parse(@match_stat.data) rescue []
  end

  def new
    if @user == current_user || current_user.role == 'admin'
	    @match = @tournament.matches.build
    else
      redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
    end
  end

  def create
  if @user == current_user || current_user.role == 'admin'
    @match = @tournament.matches.build(match_params)
    @match.statistics_fields = params[:match][:statistics_fields]
    
    if @match.valid? # Проверяем валидность объекта Match
      @match.save
      @match.create_match_stat(data: "[]") unless @match.match_stat
      redirect_to tournament_match_path(@tournament, @match), notice: 'Матч успешно создан'
    else
      render :new
    end
  else
    redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
  end
end


  def update
    if @user == current_user || current_user.role == 'admin'
      @match = @tournament.matches.find(params[:id])
      @match_stat = @match.match_stat
    
      if @match_stat.update(match_params[:match_stat])
        render json: { success: true }
      else
        render json: { success: false, errors: @match_stat.errors.full_messages }
      end
    else
      redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
    end
  end

  def destroy
    if @user == current_user || current_user.role == 'admin'
      @match = @tournament.matches.find(params[:id])
      MatchStat.where(match_id: @match.id).destroy_all
      
      if @match.destroy
        redirect_to tournament_path(@tournament), notice: 'Матч успешно удален'
      else
        redirect_to tournament_match_path(@tournament, @match), alert: 'Ошибка при удалении матча'
      end
    else
      redirect_to tournament_path(@tournament), alert: 'У вас нет прав для этого действия.'
    end
    
  end

  private
    def match_params
      params.require(:match).permit(:name, :players, :statistics_fields, match_stat: [:id, :data, :match_id])
    end

    def set_tournament_and_user
      @tournament = Tournament.find(params[:tournament_id])
      @user = @tournament.user
    end
end
