Rails.application.routes.draw do
  resources :tweets do 
    resources :comments
  end
  
  devise_for :users
  root "epicenter#feed"
  get "feed", to: "epicenter#feed"

  get 'show_user' => 'epicenter#show_user'

  get 'now_following' => 'epicenter#now_following'

  get 'unfollow' => 'epicenter#unfollow'

  get 'tag_tweets' => 'epicenter#tag_tweets'

  get 'all_users', to: 'epicenter#all_users'
  
  get 'followings', to: 'epicenter#followings'
  get 'followers', to: 'epicenter#followers'


end
