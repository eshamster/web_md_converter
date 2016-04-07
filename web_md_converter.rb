require 'sinatra'
require 'sinatra/reloader'
require 'tempfile'

get '/' do
  haml :index
end

post '/convert' do
  if params[:file]
    content_type params[:file][:type]
    f = params[:file][:tempfile]
    case params[:output_type]
    when 'html' then
      content_type 'text/html'
    when 'docx' then
      content_type 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    end
    
    Tempfile.open('temp.' + params[:output_type]) do |file|
      `pandoc -o #{file.path} #{f.path}`
      file.read file.size
    end
  end
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

