class Site::WelcomeController < SiteController

  def index

    @questions = Questions.last_questions(params[:page])
    
  end

end
