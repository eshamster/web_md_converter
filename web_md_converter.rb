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
    if required.all? { |name| params[name] }
      return true
    else
      status 400
      body "Some required parameters are lack: Required = #{required}"
      return nil
    end
  end

  def create_type_manager(type)
    begin
      return TypeManager::create(type)
    rescue ArgumentError => e
      status 400
      body e.message
      return nil
    rescue Exception => e
      status 500
      puts e.message
      body "Internal error: please see the server log"
      return nil
    end
  end
  
  def check_type_validation(type)
    return create_type_manager(type)
  end
end

post '/convert' do
  return unless check_required_params(params, :file, :output_type)

  f = params[:file][:tempfile]
  type_manager = create_type_manager(params[:output_type]) || return
  
  content_type type_manager.content_type
  Tempfile.open('temp.' + type_manager.specifier) do |file|
    `pandoc -o #{file.path} #{type_manager.make_pandoc_opts(params)} #{f.path}`
    file.read file.size
  end
end

# --- templates --- #

get '/templates' do
  return unless check_required_params(params, :type, :name)
  type_manager = create_type_manager(params[:type]) || return

  begin
    path = TemplateManager::get(type: params[:type], name: params[:name])
  rescue StandardError => e
    status 400
    body e.message
    return
  end
  File.open(path) { |file|
    content_type type_manager.template_content_type
    file.read file.size
  }
end

get '/templates/lists' do
  content_type 'application/json'
  return TemplateManager::get_templates_list.to_json
end

post '/templates' do
  return unless check_required_params(params, :file, :type, :name)
  return unless check_type_validation(params[:type])

  file_obj = params[:file]
  unless file_obj.is_a?(Hash) && file_obj[:tempfile]
    status 400
    body "The parameter 'file' should be a file object"
    return
  end
  
  f = file_obj[:tempfile]

  begin
    type = params[:type]
    name = params[:name]
    TemplateManager::add(src_path: f.path, type: type, dst_name: name)
    status 200
    content_type 'application/json'
    { "type" => type, "name" => name }.to_json
  rescue StandardError => e
    status 400
    body e.message
  rescue Exception => e
    status 500
    puts e.message
    body "Internal error"
  end
end

put '/templates' do
  "not implemnted"
end

delete '/templates' do
  return unless check_required_params(params, :type, :name)
  begin
    type = params[:type]
    name = params[:name]
    TemplateManager::delete(type: type, name: name);
    status 200
    content_type 'application/json'
    { "type" => type, "name" => name }.to_json
  rescue StandardError => e
    status 400
    body e.message
  rescue Exception => e
    status 500
    puts e.message
    body "Internal error"
  end
end

# --- template lists --- #

get '/template_lists' do
  "not implemented"
end

# --- types --- #

get '/types' do
  result = {}
  TypeManager::all_supported_types.each { |type|
    manager = TypeManager::create(type)
    result[type] = {
      "content_type" => manager.content_type,
      "specifier" => manager.specifier,
      "template_content_type" => manager.template_content_type
    }
  }
  content_type 'application/json'
  return result.to_json;
end
