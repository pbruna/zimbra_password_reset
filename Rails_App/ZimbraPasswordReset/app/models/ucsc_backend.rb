module UcscBackend

  def self.get_secondary_email(email)
    require 'net/https'
    url = URI.parse(APP_CONFIG["backend_url"])
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == "https"
    post_params = { :key => APP_CONFIG["backend_key"], :cmd => "correo-obtener", :correo => email }
    begin
      resp = http.request_post(url.path, post_params.to_param)
      parse_email(resp.body)
    rescue Exception => e
      raise "Problemas con el servidor Backend: #{url.host}\nContacte al Administrador.\n"
    end
  end

  def self.parse_email(email)
    begin
      mail = Mail::Address.new(email)
      return nil if mail.domain.nil?
      mail.address
    rescue Exception => e
      nil
    end
  end

end
