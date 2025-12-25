Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :lops
  resources :grades, only: [ :index, :show ] do
    collection do
      get :import, action: :import_new
      post :import, action: :import_create
      get :export
      get :download_template
    end
  end
  resources :students, param: :ma_sv do
    collection do
      get  :import, action: :import_new      # /students/import
      post :import, action: :import_create   # /students/import
      get  :export                           # /students/export
      get  :download_template                # /students/download_template
    end

    scope module: :students do
      resources :diem_hoc_taps
      resources :diem_ren_luyens, only: :index
    end
  end
end
