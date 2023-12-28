class QuestionsController < ApplicationController
  #質問一覧表示
  def index
    @questions = Question.all
  end

  #質問の一覧表示
  def show
    @question = Question.find(params[:id])
  end

  #質問の作成
  def new
    @question = Question.new
  end

  #質問の登録
  def create
    @question = Question.new(question_params)

    respond_to do |format|
        if @question.save
          format.html { redirect_to questions_path, notice: '質問が正常に登録されました。' }
          format.turbo_stream { render turbo_stream: turbo_stream.append('questions_list', partial: 'questions/question', locals: { question: @question }) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@question, partial: "questions/form", locals: { question: @question }) }
        end
    end
  end
  #   #Questionモデルを初期化
  #   @question = Question.new(question_params)
  #   #QuestionモデルをDBに保存
  #   if @question.save
  #     #showへリダイレクト
  #     redirect_to @question
  #   else
  #     render 'new', status: :unprocessable_entity
  #   end
  # end

  #質問の編集
  def edit
    @question = Question.find(params[:id])
  end

  #質問の更新
  def update
    @question = Question.find(params[:id])

    if @question.update(question_params)
      redirect_to @question
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  #質問の削除
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to questions_path
  end

  private
  def question_params
    params.require(:question).permit(:title, :name, :content, :old)
  end
end
