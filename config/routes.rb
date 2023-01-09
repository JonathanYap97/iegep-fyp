Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root to: 'users/homepage#index'

  devise_for :users, path: "user", controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
  }

  namespace :users, path: 'user' do
    get '/homepage', to: 'homepage#index', as: 'homepage'
    get '/do', to: 'quizzes#do_quiz', as: 'do_quiz'
    post '/do', to: 'quizzes#do_quiz_submit', as: 'do_quiz_submit'
    get '/history', to: 'quizzes#history', as: 'history'

    get '/profile', to: 'homepage#profile', as: 'profile'
    patch '/profile/update', to: 'homepage#update', as: 'update_profile'
    patch '/profile/password', to: 'homepage#change_password', as: 'change_password'

    resources :quizzes do
      post '/start', to: 'quizzes#start', as: 'start'

      get '/do/classic', to: 'quizzes#classic', as: 'classic'
      post '/do/classic', to: 'quizzes#submit_classic', as: 'submit_classic'
      get '/do/live', to: 'quizzes#live', as: 'live'
      post '/do/live', to: 'quizzes#submit_live', as: 'submit_live'

      get '/answers', to: 'quizzes#answers', as: 'answers'
      get '/answers/:id/mark', to: 'quizzes#mark', as: 'mark'
      post '/answers/:id/mark', to: 'quizzes#submit_mark', as: 'submit_mark'
    end
  end
end