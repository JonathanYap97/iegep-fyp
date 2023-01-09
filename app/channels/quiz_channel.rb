class QuizChannel < ApplicationCable::Channel
  on_subscribe :join

  def subscribed
    stream_from "quiz_#{params[:quizID]}"
  end

  def unsubscribed
    stop_all_streams
  end

  def start(data)
    question = Question.find(data['question'].to_i)

    ActionCable.server.broadcast('quiz_' + data['quiz'].to_s, {type: 'start', body: render_question(question, data['quiz_name'].to_s, 1)})
  end

  def answer(data)
    question = Question.find(data['question'].to_i)
    marks = 0

    if data['answer_number'].to_i == question.correct_answer
      marks = question.marks
    end

    QuestionAnswer.create(question: question, quiz_answer_id: data['qa'].to_i, marks: marks, answer: data['answer_number'].to_i)

    user = User.find(data['user'].to_i)

    ActionCable.server.broadcast('quiz_' + data['quiz'].to_s, {type: 'answer', user: user.name, marks: marks, question: data['question'].to_i})
  end

  def leaderboard(data)
    question = Question.find(data['question'].to_i)
    
    correct_answer = ''

    case question.correct_answer
    when 1
      correct_answer = question.answer_1
    when 2
      correct_answer = question.answer_2
    when 3
      correct_answer = question.answer_3
    else
      correct_answer = question.answer_4
    end

    ActionCable.server.broadcast('quiz_' + data['quiz'].to_s, {type: 'leaderboard', body: render_leaderboard(data['scores'], data['quiz_name'].to_s, question, correct_answer, data['q_number'].to_s), host: Quiz.find(params[:quizID]).user.id})
  end

  def proceed(data)
    quiz = Quiz.find(data['quiz'].to_i)
    question = quiz.questions[data['q_number'].to_i]

    if question.nil?
      host = quiz.user.id
      ActionCable.server.broadcast('quiz_' + data['quiz'].to_s, {type: 'end', body: render_end(data['scores'], quiz.name), scores: data['scores'], host: quiz.user.id})

      quiz.quiz_answers.each do |qa|
        qa.update(total_marks: qa.question_answers.sum(:marks))
      end
    else
      ActionCable.server.broadcast('quiz_' + data['quiz'].to_s, {type: 'start', body: render_question(question, data['quiz_name'].to_s, (data['q_number'].to_i + 1).to_s)})
    end
  end

  private
  def join
    user = User.find(params[:userID].to_i)
    quiz = Quiz.find(params[:quizID].to_i)

    if user.id != quiz.user.id
      ActionCable.server.broadcast('quiz_' + params[:quizID].to_s, {type: 'join', name: user.name, id: user.id})
    end
  end

  def render_question(question, quiz_name, q_number)
    ApplicationController.render(partial: 'users/quizzes/live_question', locals: {name: quiz_name, number: q_number, id: question.id, q_text: question.q_text, answer_1: question.answer_1,  answer_2: question.answer_2,  answer_3: question.answer_3,  answer_4: question.answer_4})
  end

  def render_leaderboard(scores, quiz_name, question, correct_answer, q_number)
    ApplicationController.render(partial: 'users/quizzes/live_leaderboard', locals: {name: quiz_name, number: q_number, correct_answer: correct_answer, marks: question.marks, scores: scores})
  end

  def render_end(scores, quiz_name)
    ApplicationController.render(partial: 'users/quizzes/live_end', locals: {name: quiz_name, scores: scores})
  end
end
