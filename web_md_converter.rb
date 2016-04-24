require 'sinatra'
require 'sinatra/reloader'
require 'tempfile'
require 'json'
require_relative 'type_manager'
require_relative 'template_manager'

get '/' do
  haml :index
end

helpers do
  def check_required_params(params, *required)
    return required.all? { |name| params[name] }
  end

  def create_type_manager(type)
    begin
      return TypeManager::create(type)
    rescue ArgumentError => e
      status 400
      body e.message
      return nil
    rescue StandardError => e
      status 500
      body e.message
      return nil
    end
  end
end

post '/convert' do
  if check_required_params(params, :file, :output_type) 
    f = params[:file][:tempfile]
    type_manager = create_type_manager(params[:output_type]) || return
    
    content_type type_manager.content_type
    Tempfile.open('temp.' + type_manager.specifier) do |file|
      `pandoc -o #{file.path} #{type_manager.make_pandoc_opts(params)} #{f.path}`
      file.read file.size
    end
  else
    status 400
    body 'The parameters, "file" (a markdown file) and "output_type" (string), are required'
  end
end

get '/test' do
  manager = TypeManager::Html.new()
  manager.content_type + ", " + manager.specifier + ", " + manager.make_pandoc_opts([])
end

# --- templates --- #

get '/templates' do
  unless check_required_params(params, :type, :name)
    status 400
    body 'The parameters, "type" and "name" are required'
    return
  end

  path = TemplateManager::get(type: params[:type], name: params[:name])

  type_manager = create_type_manager(params[:type]) || return
  File.open(path) { |file|
    content_type type_manager.template_content_type
    file.read file.size
  }
end

get '/templates/lists' do
  return TemplateManager::get_templates_list.to_json
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

