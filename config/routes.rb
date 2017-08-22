Rails.application.routes.draw do

  resources :phrases do
    resources :photos
  end

end
