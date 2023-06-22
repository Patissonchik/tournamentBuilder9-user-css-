class TournamentsController < ApplicationController
	before_action :set_tournament, only: %i[edit update destroy show]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@tournaments = Tournament.all
	end

	def new
		@tournament = Tournament.new
	end

	def create
			@tournament = Tournament.new(tournament_params)
			@tournament.user_id = current_user.id

			if @tournament.save
				redirect_to tournaments_path, notice: 'Турнир успешно создан'
			else
				render :new
			end
	end

	def edit
		if @user == current_user || current_user.role == 'admin'
		else
			redirect_to tournaments_path, alert: 'У вас нет прав для редактирования турнира.'
		end
	end

	def update
		
		if @user == current_user || current_user.role == 'admin'
			@tournament.update(tournament_params)
			redirect_to tournament_path(@tournament)
		else
			redirect_to tournaments_path, alert: 'У вас нет прав для редактирования турнира.'
		end
	end

	def destroy
		if @user == current_user || current_user.role == 'admin'
			@tournament.destroy
			redirect_to tournaments_path
		else
			redirect_to tournaments_path, alert: 'У вас нет прав для редактирования турнира.'
		end
		
	end
	

	def show
		@matches = @tournament.matches
		@match = Match.new
	end

	private

	def tournament_params
		params.require(:tournament).permit(:name, :description, :user_id)
	end

	def set_tournament
		@tournament = Tournament.find(params[:id])
		@user = @tournament.user
	end
end
