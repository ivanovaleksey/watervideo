Rails.application.routes.draw do
  root to: 'videos#index'

  resources :videos, except: :destroy do
    member do
      get :thumbnail_state
      get :file_state
    end
  end
end
