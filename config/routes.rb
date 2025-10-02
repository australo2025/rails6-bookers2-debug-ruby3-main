Rails.application.routes.draw do
  get 'searches/search'
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  get 'search', to: 'searches#search', as: :search

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resources :relationships, only: [:create]
    delete "/relationships"=>"relationships#destroy"
    get :search, on: :member
  end

  resources :rooms, only: [:create, :show] do
    resources :messages, only: :create
  end

  resources :groups, only: [:new, :create, :index, :show, :edit, :update] do
  end

  resources :groups do
    member do
      post   :join
      delete :leave
    end
  end
    
end