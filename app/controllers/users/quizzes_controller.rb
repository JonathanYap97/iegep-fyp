class Users::QuizzesController < Users::BaseController
  

  def index
    @quizzes = @user.quizzes.order(start_date: :desc, end_date: :asc)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    quiz = Quiz.create(quiz_params.merge(user: @user, code: rand(10000000...99999999)))

    count = params['questions']['number'].to_i - 1
    
    for i in 0..count do
      data = params['questions']['data'][i.to_s].split(',')
      if data[2] != 'deleted'
        Question.create(quiz: quiz, q_text: data[0], q_type: data[2], marks: data[1], answer_1: data[3], answer_2: data[4], answer_3: data[5], answer_4: data[6], correct_answer: data[7])
      end
    end
    
    redirect_to users_quizzes_path
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions
    
    @q_array = []
    @questions.each do |q|
      @q_array << [q.q_text, q.marks, q.q_type, q.answer_1, q.answer_2, q.answer_3, q.answer_4, q.correct_answer]
    end
  end

  def update
    quiz = Quiz.find(params[:id])
    quiz.update(quiz_params)

    quiz.questions.destroy_all
    
    count = params['questions']['number'].to_i - 1
    
    for i in 0..count do
      data = params['questions']['data'][i.to_s].split(',')
      if data[2] != 'deleted'
        Question.create(quiz: quiz, q_text: data[0], q_type: data[2], marks: data[1], answer_1: data[3], answer_2: data[4], answer_3: data[5], answer_4: data[6], correct_answer: data[7])
      end
    end
    
    redirect_to users_quizzes_path
  end

  def destroy
    quiz = Quiz.find(params[:id])
    
    quiz.questions.each do |q|
      q.question_answers.destroy_all
    end
    quiz.questions.destroy_all

    quiz.update(user: nil)
    quiz.destroy
  end

  def do_quiz
    
  end

  def do_quiz_submit
    quiz = Quiz.find_by(code: params[:code].to_i)

    if !quiz.nil?
      if DateTime.now >= DateTime.new(quiz.start_date.year, quiz.start_date.month, quiz.start_date.day, quiz.start_time.hour, quiz.start_time.min, quiz.start_time.sec, quiz.start_time.zone)
        if DateTime.now <= DateTime.new(quiz.end_date.year, quiz.end_date.month, quiz.end_date.day, quiz.end_time.hour, quiz.end_time.min, quiz.end_time.sec, quiz.end_time.zone)
          if quiz.q_type == 'classic'
            render :json => {id: quiz.id, type: 'classic'}
          else
            render :json => {id: quiz.id, type: 'live'}
          end
        else
          render :json => {id: 0, type: 'fail'}
        end
      else
        render :json => {id: 0, type: 'fail'}
      end
    else
      render :json => {id: 0, type: 'fail'}
    end
  end

  def history
    @history = @user.quiz_answers
  end

  def start

  end

  def classic
    @quiz = Quiz.find(params[:quiz_id])
    @answer = QuizAnswer.new

    @end_time = DateTime.new(@quiz.end_date.year, @quiz.end_date.month, @quiz.end_date.day, @quiz.start_time.hour, @quiz.start_time.min, @quiz.start_time.sec, @quiz.start_time.zone).strftime("%b %-d, %Y %H:%M:%S")
  end

  def submit_classic
    quiz = Quiz.find(params[:quiz_id])
    qa = QuizAnswer.create(quiz: quiz, user: @user, start_date: quiz.start_date, end_date: quiz.end_date, start_time: quiz.start_time, end_time: quiz.end_time)
    
    params['answers'].each do |a|
      QuestionAnswer.create(question_id: a[0], quiz_answer: qa, marks: nil, answer: a[1])
    end
    
    redirect_to root_path
  end

  def live
    @quiz = Quiz.find(params[:quiz_id])
    @host = false
    
    if @quiz.user != @user
      @qa = QuizAnswer.where(user: @user).where(quiz: @quiz).first
      if @qa.nil?
        @qa = QuizAnswer.create(quiz: @quiz, user: @user, start_date: @quiz.start_date, end_date: @quiz.end_date, start_time: @quiz.start_time, end_time: @quiz.end_time)
      end
    else
      @host = true;
    end
  end

  def submit_live
  end

  def answers
    @quiz = Quiz.find(params[:quiz_id])
  end

  def mark
    @quiz = Quiz.find(params[:quiz_id])
    @qa = QuizAnswer.find(params[:id])
  end

  def submit_mark
    total = 0
    params['marks'].each do |m|
      QuestionAnswer.find(m[0].to_i).update(marks: m[1].to_i)
      total += m[1].to_i
    end

    QuizAnswer.find(params[:id]).update(total_marks: total)
    
    redirect_to users_quiz_answers_path(params[:quiz_id])
  end

  private

  def quiz_params
    params.require(:quiz).permit(:name, :q_type, :description, :start_date, :end_date, :start_time, :end_time)
  end
end
