require 'sinatra'
require 'sinatra/reloader'
require 'tempfile'
require_relative 'type_manager'

get '/' do
  haml :index
end

post '/convert' do
  if params[:file]
    content_type params[:file][:type]
    f = params[:file][:tempfile]
    type_manager = TypeManager::Base::create(params[:output_type])
    content_type type_manager.content_type
    
    Tempfile.open('temp.' + type_manager.specifier) do |file|
      `pandoc -o #{file.path} #{f.path}`
      file.read file.size
    end
  end
end

get '/test' do
  manager = TypeManager::Html.new()
  manager.content_type + ", " + manager.specifier + ", " + manager.make_pandoc_opts([])
end

# --- templates --- #

get '/templates' do
  "not implemented"
end

post '/templates' do
  "not implemnted"
end

put '/templates' do
  "not implemnted"
end

delete '/templates' do
  "not implemnted"
end


# --- template lists --- #

get '/template_lists' do
  "not implemented"
end

