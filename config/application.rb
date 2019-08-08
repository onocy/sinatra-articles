# Configuration file for server auto-reload

# For all environments, run the following code
configure do
# Load all .rb files in the app folder
Dir[File.join(File.dirname(__FILE__), '../app', '**', '*.rb')].each do |file|
    require file
end
# set :views, 'app/views'
end

configure :development, :test do
require 'pry'
require "sinatra/reloader"

Dir[__dir__ + "/../app/**/*.rb"].each do |file|
    also_reload file
end
end