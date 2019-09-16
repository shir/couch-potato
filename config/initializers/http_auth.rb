# frozen_string_literal: true

if ENV['HTTP_AUTH_USER'].present? && ENV['HTTP_AUTH_PASSWORD'].present?
  Rails.application.configure do
    config.middleware.use(Rack::Auth::Basic) do |u, p|
      [u, p] == [ENV['HTTP_AUTH_USER'], ENV['HTTP_AUTH_PASSWORD']]
    end
  end
end
