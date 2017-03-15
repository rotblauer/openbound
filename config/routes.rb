# http://stackoverflow.com/questions/10918529/how-can-i-use-rails-routes-to-redirect-from-one-domain-to-another

Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  # root 'works#index'
  # root 'index#start'
  root 'projects#index'
  # get 'start' => 'index#start'

  # CSS Test
  get 'dash-test' => 'index#dash_test'
  get 'test' => 'index#test'

  # Directs all GET signey-uppey urls to single page.
  get 'signin' => 'index#signin' # my preferred path
  get 'signup' => 'index#signin' # recruiting path
  get 'login' => 'index#signin' # default path
  get 'members/new' => 'index#signin'

  # Manage user credentials for sessions or logging in
  post 'login'   => 'sessions#create'
  post 'signin' => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # Oauthable.
  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", :as => :signout


  # The following are user-related paths.
  resources :users, path: 'members', only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      get 'bookmarks' => 'users#bookmarks', as: 'show_bookmarks'
      get 'anonymousers' => 'users#anonymousers', as: 'show_anonymousers'
      delete "linked_accounts/:linked_account_id" => "linked_accounts#destroy", :as => :disconnect_linked_account
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :email_updates, only: [:new, :create, :edit, :update]

  #          projects GET    /projects(.:format)                              projects#index
  #                   POST   /projects(.:format)                              projects#create
  #       new_project GET    /projects/new(.:format)                          projects#new
  #      edit_project GET    /projects/:id/edit(.:format)                     projects#edit
  #           project GET    /projects/:id(.:format)                          projects#show
  #                   PATCH  /projects/:id(.:format)                          projects#update
  #                   PUT    /projects/:id(.:format)                          projects#update
  #                   DELETE /projects/:id(.:format)                          projects#destroy
  #     project_works GET    /projects/:project_id/works(.:format)            works#index
  #                   POST   /projects/:project_id/works(.:format)            works#create
  #  new_project_work GET    /projects/:project_id/works/new(.:format)        works#new
  # edit_project_work GET    /projects/:project_id/works/:id/edit(.:format)   works#edit
  #      project_work GET    /projects/:project_id/works/:id(.:format)        works#show
  #                   PATCH  /projects/:project_id/works/:id(.:format)        works#update
  #                   PUT    /projects/:project_id/works/:id(.:format)        works#update
  #                   DELETE /projects/:project_id/works/:id(.:format)        works#destroy
  #                   GET    /projects(.:format)                              projects#index
  #                   POST   /projects(.:format)                              projects#create
  #                   GET    /projects/new(.:format)                          projects#new
  #                   GET    /projects/:id/edit(.:format)                     projects#edit
  #                   GET    /projects/:id(.:format)                          projects#show
  #                   PATCH  /projects/:id(.:format)                          projects#update
  #                   PUT    /projects/:id(.:format)                          projects#update
  #                   DELETE /projects/:id(.:format)                          projects#destroy

  get 'projects/testes' => 'projects#testes'
  get 'projects/test-show' => 'projects#test_show'
  patch 'projects/:id/change-policy' => 'projects#change_policy', as: 'project_change_policy'
  get 'works/redirect-to-imported' => 'works#go_to_user_most_recent_work', as: 'work_imported'
  # get 'projects/testpartial' => 'projects#testpartial'
  # get 'projects/:id/add-version' => 'projects#add_version', as: 'add_version' # stand alone page to add version to project (link from projects#show and _work)
  resources :projects, only: [:index, :show, :update, :destroy]#, only: [:index, :show, :create, :edit, :update, :destroy]

  resources :projects do
    resources :works
  end

  # get 'works/:id/begin_new_version' => 'works#begin_new_version'
  resources :works do
    resources :comments, only: [:index, :new, :create, :edit, :destroy]
    resources :gradients, only: [:create, :update]
    resources :suggesteds, only: [:new, :create]
    member do
      get "save_as_new_version"
      get "begin_new_version"
      get "download"
    end
  end
  post 'google-drive/' => 'works#google_import'
  patch 'bookmarks/:project_id' => 'bookmarks#bookmarker', as: 'bookmark'  # Toggles current_user's bookmark for work.
  patch 'works/:id/change-policy' => 'works#change_policy', as: 'change_policy'  # Toggles current_user's (the work's owner) policy on superheroism

  patch 'works/:id/recommend' => 'works#recommend', as: 'recommendation' # Toggles recommendation /user/work
  # For confirm/deny of _suggesteds.
  post 'works/suggestions/:id/confirm-context' => 'suggesteds#confirm_context'
  post 'works/suggestions/:id/confirm-content' => 'suggesteds#confirm_content'
  post 'works/suggestions/:id/deny' => 'suggesteds#deny'

  # For initial editing opp after uploading.
  get 'shelving_cart' => 'projects#shelving_cart_edit', as: 'snooty_librarian'
  # post 'shelving_cart/:work_id' => 'works#shelving_cart_update', as: 'dewey_doing'

  resources :schools, only: [:show, :index]
  # get 'schools' => 'schools#index', as: 'schools'
  # get 'schools/:id' => 'schools#show', as: 'school'

  # Link to learn more - marketing and shit.
  get 'learn' => 'index#learn'

  # Footer.
  get 'privacy' => 'index#privacy'
  get 'terms-and-conditions' => 'index#terms_and_conditions', as: 'terms_and_conditions'
  get 'team' => 'index#team'
  get 'contact-us' => 'index#contact_us', as: 'contact_us'
  get 'colbysucks' => 'index#colbysucks'

  get 'admin/analytics' => 'admins#analytics'

  get 'new_google_upload_dan' => 'works#new_google_upload_dan'

    ##########################################
    ## For importing schools table
    ##########################################

    # for importing schools table:
    # get 'start' => 'index#start'

    # resources :schools do
    #   collection { post :import }
    # end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
