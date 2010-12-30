DelicateServer::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'


  match 'login',        :to => 'edit#login', :as => "login"
  match 'logout',       :to => 'edit#logout', :as => "logout"

  match 'help',       :to => 'edit#help', :as => "help"

  match 'bundles',      :to => 'edit#bundles', :as => "bundles"

  match 'create_bundle', :to => 'edit#create_bundle', :as => "create_bundle"
  match 'delete_bundle', :to => 'edit#delete_bundle', :as => "delete_bundle"
  match 'tag_to_bundle', :to => 'edit#tag_to_bundle', :as => "tag_to_bundle"
  match 'rename_tag',   :to => 'edit#rename_tag', :as => "rename_tag"
  match 'delete_tag',   :to => 'edit#delete_tag', :as => "delete_tag"
  match 'merge_tags',   :to => 'edit#merge_tags', :as => "merge_tags"

  match 'v2_get_token', :to => 'edit#v2_get_token', :as => "v2_get_token"
  match 'v2_bundles',   :to => 'edit#v2_bundles', :as => "v2_bundles"
  match 'v2_test',   :to => 'edit#v2_test', :as => "v2_test"

  root :to => 'edit#bundles'

end
