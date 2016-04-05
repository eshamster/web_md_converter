require 'sinatra'
require 'sinatra/reloader'
require 'tempfile'

set :bind, '0.0.0.0'

get '/' do
  haml :index
end

put '/upload' do
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

__END__

@@index
%html
  %body
    %form{:action => '/upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %input{:type => 'file', :name => 'file'}
      %select{:name => 'output_type'}
        %option{:value => 'html'} html
        %option{:value => 'docx'} word
      %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}
