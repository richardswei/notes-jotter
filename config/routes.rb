Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root :to => "pages#notes", as: :authenticated_root
  end
  root :to => 'pages#home'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :notes, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
