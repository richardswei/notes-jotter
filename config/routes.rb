Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  authenticated :user do
    root "pages#notes", as: :authenticated_root
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :notes, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
