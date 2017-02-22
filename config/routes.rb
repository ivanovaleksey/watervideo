Rails.application.routes.draw do
  root to: 'videos#index'

  resources :videos, except: :destroy do
    member do
      get :thumbnail_state, controller: 'progress'
      get :file_state, controller: 'progress'
    end
  end
end
