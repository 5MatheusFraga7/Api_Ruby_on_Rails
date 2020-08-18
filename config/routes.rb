require 'api_version_constraint'

Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Define thread de controller, com padrão de formatos em json, só permite subdomínio de 'api', retirando o www.
  #Especifica que não precisa de caminho a ser digitado na url para entrar nos controllers >> api.site/rota_criada
  namespace :api, defaults: {format: :json}, constraints: {subdomain: 'api'}, path: '/' do 	
  	namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
		resources :users, only: [:show, :create, :update, :destroy]		
  	end
  end 
end
