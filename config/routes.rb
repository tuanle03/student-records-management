Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :lops
  resources :grades, only: [ :index, :show ]
  resources :students, param: :ma_sv do
    scope module: :students do
      resources :diem_hoc_taps
      resources :diem_ren_luyens, only: :index
    end
  end

  get  "/bang-diem/new", to: "grades#new",    as: "new_grade"
  post "/bang-diem",     to: "grades#create", as: "create_grade"
end
