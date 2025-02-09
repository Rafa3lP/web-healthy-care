# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  scope(path_names: { new: "novo", edit: "editar" }) do
    constraints lambda { |request| Rails.env.development? || User.find(request.cookie_jar.signed["user_id"]).admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    devise_for :users, path: "usuarios",
                       path_names: { sign_in: "login", sign_up: "registrar", sign_out: "logout", password: "senha" },
                       controllers: { registrations: "users/registrations" }

    devise_scope :user do
      root to: "devise/sessions#new"
    end

    resource :admin,                                 only: :show do
      # TODO
    end

    resource :dispatches,                            only: :show,                                          path: "ir-para"
    resources :doctors,                              only: [:new, :show, :index, :create, :edit, :update], path: "medicos"
    resources :patients,                             only: [:new, :create, :index, :edit, :update],        path: "pacientes" do
      scope module: :patients do
        resources :access_controls,                  only: [:create, :update, :destroy, :index],           path: "autorizacoes"
        resource  :dashboard,                        only: :show
        resource  :biodata,                          only: [:show],                                        path: "biodados"
        resources :consultations,                    only: [:new, :create, :show, :index],                 path: "consultas"
        resources :surgeries,                        only: [:new, :edit, :create, :update, :show, :index], path: "cirurgias" do
          scope module: :surgeries do
            resources :medication_surgeries,         only: [:new, :create],                                path: "medicamentos"
          end
        end
        resources :exams,                            only: [:new, :create, :show, :index],                 path: "exames" do
          scope module: :exams do
            resources :biodata,                      only: [:new, :create],                                path: "biodados"
          end
        end
        resources :diagnostics,                      only: [:new, :create, :show, :index, :update],        path: "diagnosticos" do
          scope module: :diagnostics do
            resources :treatments,                   only: [:new, :show, :index, :update],                 path: "tratamentos"
            resources :diets,                        only: [:new, :create],                                path: "dietas"
            resources :prescriptions,                only: [:new, :create, :edit, :update],                path: "receitas" do
              scope module: :prescriptions do
                resources :medication_prescriptions, only: [:new, :create],                                path: "medicamentos"
              end
            end
            resources :surgeries,                    only: [:new, :edit, :create, :update],                path: "cirurgias" do
              scope module: :surgeries do
                resources :medication_surgeries,     only: [:new, :create],                                path: "medicamentos"
              end
            end
          end
        end
      end
    end
  end
end
