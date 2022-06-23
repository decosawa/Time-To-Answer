class AdminsBackoffice::QuestionsController < AdminsBackofficeController

    before_action :set_question, only: [:update, :edit, :destroy]
    before_action :get_subjects, only: [:new, :edit]


  def index

    @questions = Question.includes(:subject).order(:description).page(params[:page])

  end

  def new

    @question = Question.new

  end

  def create

    @question = Question.new(params_question)

    if(@question.save)

      redirect_to admins_backoffice_questions_path, notice: "Pergunta criada com sucesso!"
    
    else

      render :index, notice: "Pergunta não criada"

    end

  end

  def edit 
  end

  def update

    if(@question.update(params_question))

      redirect_to admins_backoffice_questions_path, notice: "Pergunta atualizada com sucesso!"
    
    else

      render :edit, notice: "Pergunta não atualizada"

    end

  end

  def destroy

    if @question.destroy

      redirect_to admins_backoffice_questions_path, notice: "Pergunta excluída com sucesso!"

    else

      render :index
      
    end

  end

  private

    def set_question

      @question = Question.find(params[:id])

    end

    def params_question 
      
      params.require(:question).permit(:description)

    end

    def get_subjects
        
        @subjects = Subject.all

    end

end
