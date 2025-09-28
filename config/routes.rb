Rails.application.routes.draw do
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]

  end
  resources :users, only: [:index,:show,:edit,:update] do
    resources :relationships, only: [:create]
    delete "/relationships"=>"relationships#destroy"
  end
    
end