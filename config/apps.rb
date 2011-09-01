Padrino.configure_apps do
  set :sessions, true
  set :session_secret, '339ed174e13302a1c6f090df5ebf2b6df9d8e153f21df757229e0629aa143321'
  set :delivery_method, :smtp => {
    :address         => 'smtp.lipsiasoft.com',
    :port            => '25',
    :user_name       => 'mailer@lipsiasoft.com',
    :password        => 'mailer!',
    :authentication  => :login # :plain, :login, :cram_md5, no auth by default
  }
end

# Mounts the core application for this project
Padrino.mount("PadrinoWeb").to("/")
Padrino.mount("Admin").to("/admin")
