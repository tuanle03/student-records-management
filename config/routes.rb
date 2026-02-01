Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  namespace :admin do
    get "mon_hocs/:id", to: "mon_hocs#show", constraints: { id: /[^\/]+/ }
    get "mon_hocs/:id/edit", to: "mon_hocs#edit", constraints: { id: /[^\/]+/ }
    patch "mon_hocs/:id", to: "mon_hocs#update", constraints: { id: /[^\/]+/ }
    put "mon_hocs/:id", to: "mon_hocs#update", constraints: { id: /[^\/]+/ }
    delete "mon_hocs/:id", to: "mon_hocs#destroy", constraints: { id: /[^\/]+/ }
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :lops
  get "grades", to: "grades#index", as: :grades
  get "grades/:id", to: "grades#show", as: :grade, constraints: { id: /[^\/]+/ }
  resources :grades, only: [] do
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
      resources :diem_ren_luyens
    end
  end
end
