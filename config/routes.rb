Rails.application.routes.draw do

  # scope :api do
  #   resources :phrases do
  #     resources :photos
  #   end
  # end

  resources :phrases do
    resources :photos
  end

  root to: 'phrases#index'

  # match '*path' => 'phrases#index', via: :get
end
