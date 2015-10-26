class TagStoryApp < Sinatra::Application
  get '/' do
    haml :index
  end

  get '/login' do
    redirect '/auth/google_oauth2'
  end

  # sign in
  get '/auth/:provider/callback' do
    begin
      auth = request.env['omniauth.auth']
      @user = User.find_by_uid(auth['uid'])
      if @user # logged in
        session[:user] = @user
        session[:id] = @user.id
        redirect '/my-stories'
      else # new user
        logger.info "A new user(#{auth[:uid]}): #{auth[:info]}"
        session[:access_token] = auth[:credentials][:token]
        session[:refresh_token] = auth[:credentials][:refresh_token]
        session[:expires_at] = auth[:credentials][:expires_at]

        @user = User.create_user(auth[:info], auth[:uid])
        if @user.save
          session[:user] = @user
          session[:id] = @user.id
          redirect '/my-stories'
        else
          logger.warn @user.errors.messages
        end
      end
    rescue => e
      logger.error "User was not logged in with request #{request.env}"
      logger.error e
    end
    redirect '/'
  end

  get '/auth/failure' do
    content_type 'text/plain'
    begin
      request.env['omniauth.auth'].to_hash.inspect
    rescue => e
      puts "User could not log in with request #{request.env}"
      puts e
    end
    redirect '/'
  end
end
