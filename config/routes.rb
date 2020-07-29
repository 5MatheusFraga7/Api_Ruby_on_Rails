Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Define thread de controller, com padrão de formatos em json, só permite subdomínio de 'api', retirando o www.
  #Especifica que não precisa de caminho a ser digitado na url para entrar nos controllers >> api.site/rota_criada
  namespace :api, defaults: {format: :json}, constraints: {subdomain: 'api'}, path: '/' do 

  	

  end 
end
