Rails.application.routes.draw do

  get '/moderators/posts/:id/approve', to: 'moderators#approved', as: 'posts_approved'
  get '/moderators/posts/:id/rejected', to: 'moderators#rejected', as: 'posts_rejected'

  get '/posts/pending', to: 'posts#pending', as: 'posts_pending'
  get '/posts/myrejected', to: 'posts#rejected', as: 'posts_myreject'

  get 'moderators/index'
  get 'moderators/approved'

  devise_for :users
  root 'users#index'
  resources :users

  resources :posts do
    resources :comments
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
