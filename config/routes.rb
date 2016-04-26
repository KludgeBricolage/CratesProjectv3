Rails.application.routes.draw do
    
    match 'auth/:provider/callback', to: 'sessions#create_from_fb', via: [:get, :post]
    match 'auth/failure', to: redirect('/'), via: [:get, :post]
    match 'signout', to: 'session#destroy', as: 'signout', via: [:get, :post]

    get 'password_resets/new'
    get 'password_resets/edit'
    root 'pages#home'
    get 'fam' => 'admins#show', as: 'admin'
    get 'signup' => 'users#new'
    get 'crate_manager' => 'pages#crate_manager'
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'
    get 'search' => 'crates#index'
    get 'community' => 'pages#community', as: 'community'
    get 'tags/:tag', to: 'crates#index', as: 'tag'
    get 'help' => 'pages#help', as: 'help'
    get 'change_pin' => 'forum_posts#change_pin'
    get 'change_lock' => 'forum_posts#change_lock'
    post 'new_comment' => 'forum_comments_controller#create', as: 'new_comment'
    post 'change_status' => 'pages#change_status'
    get 'crate_manager' => 'pages#crate_manager'
    post 'unrate' => 'users#unrate'
    post 'rate' => 'users#rate'
    
    get 'change_subsc' => 'forum_posts#change_subsc'
    post 'deactivate_user' => 'users#deactivate'
    
    get 'q_noti' => 'pages#get_all_cq'
    get 'r_noti' => 'pages#get_all_rep'
    get 'fp_noti' => 'pages#get_all_fp'
    
    resources :users do
        resources :profiles
    end
    
    resources :groups, only: [:show,:index]
    
    resources :crates
    
    resources :queries, only: [:create,:update]
    resources :replies, only:[:create,:update]
    
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :reports, only: [:create,:destroy,:show,:index]
    resources :forum_categories, only: [:show]
    resources :forum_posts, only: [:new,:create,:destroy,:show,:edit,:update] do
        resources :forum_comments, only: [:new,:create,:destroy,:edit,:update] 
    end
    resources :forum_comments, only: [:new,:create,:destroy,:edit,:update] 
    
   
    
    #match "*path", to: "application#dont_url_manipulate", via: :all
end
