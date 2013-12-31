Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '269524539866849', '75a6694bfeee3d8084ddd5c214d52ac1'
  provider :twitter, 'vGcdh5JKwK4A0yArl46Vw', 'iSyUznC5BxT2R7dVjbWxL9dAJam7LIbR7xBrwWJZM9I'
  provider :identity, fields: [:email, :name], model: User, on_failed_registration: lambda { |env|      
    UsersController.action(:new).call(env)  
  }
end