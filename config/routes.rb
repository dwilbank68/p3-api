Todo::Application.routes.draw do

  root to: 'users#new'

  resources :users do
    resources :lists, except: [:index]
  end

  resources :lists, only: [] do
    resources :items, only: [:create, :new]
  end

  resources :items, only: [:destroy]

  ################ API ################

  namespace :api do
    resources :users do
      resources :lists
    end
  end

  namespace :api do
    resources :lists, only: [] do
      resources :items, only: [:create, :destroy]
    end
  end

end
