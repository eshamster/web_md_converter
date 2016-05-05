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

get '/test' do
  manager = TypeManager::Html.new()
  manager.content_type + ", " + manager.specifier + ", " + manager.make_pandoc_opts([])
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
  result_table = {};
  all_list = TemplateManager::get_templates_list;
  all_list.each { |type, list|
    result_table[type] = { "list" => list }
  }
  return result_table.to_json
end

post '/templates' do
  return unless check_required_params(params, :file, :type, :name)

  file_obj = params[:file]
  unless file_obj.is_a?(Hash) && file_obj[:tempfile]
    status 400
    body "The parameter 'file' should be a file object"
    return
  end
  
  f = file_obj[:tempfile]
  type_manager = create_type_manager(params[:type]) || return

  begin
    type = params[:type]
    name = params[:name]
    TemplateManager::add(src_path: f.path, type: type, dst_name: name)
    status 200
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

