Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_graph, ENV['AZURE_APP_ID'], ENV['AZURE_APP_SECRET']
end
