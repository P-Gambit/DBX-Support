# https://github.com/omniauth/omniauth-oauth2/blob/master/README.md
# https://github.com/zammad/zammad/issues/775#issuecomment-282554174

class Oauth2Database < OmniAuth::Strategies::OAuth2
  option :name, 'oauth2'

  # This is where you pass the options you would pass when
  # initializing your consumer from the OAuth gem.
  option :client_options, {:site => "https://dbx-oauth.digibitx.com"}

  def initialize(app, *args, &block)

    # database lookup
    config  = Setting.get('auth_oauth2_credentials') || {}
    args[0] = config['app_id']
    args[1] = config['app_secret']
    args[2][:client_options] = args[2][:client_options].merge(config.symbolize_keys)
    super
  end

  def callback_url
    full_host + script_name + callback_path
  end

  uid { raw_info['uid'] }

  info do
    {
      email: raw_info['email'],
      login: raw_info['email']
    }
  end

  def raw_info
    @raw_info ||= access_token.get('/api/v1/accounts/me').parsed
  end

end