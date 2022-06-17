Rails.application.routes.draw do

  get '/moderators/posts/:id/approve', to: 'moderators#approved', as: 'posts_approved'
  get '/moderators/posts/:id/rejected', to: 'moderators#rejected', as: 'posts_rejected'


  
  get '/posts/pending', to: 'posts#pending', as: 'posts_pending'
  get '/posts/myrejected', to: 'posts#rejected', as: 'posts_myreject'


  post '/posts/:post_id/comments/:comment_id', to: 'likes#like_on_comment', as: 'post_comments_like'
  delete '/posts/:post_id/comments/:comment_id', to: 'likes#delete_like_on_comment', as: 'delete_post_comments_like'

  post '/posts/:post_id/comments/:comment_id/reply', to: 'comments#reply', as: 'comment_replies'
  

  get 'moderators/index'
  get 'moderators/approved'

  devise_for :users
  root 'users#index'
  resources :users  

  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
