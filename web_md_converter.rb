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
  %head
    :javascript
      function hide_all_conf () {
        var confs = document.querySelectorAll('[class*="conf"]');
        Array.prototype.forEach.call(confs, function(conf) {
          conf.style.display = 'none';
        });
      }
      function show_one_conf_only (selector) {
        hide_all_conf();
        var confs = document.querySelectorAll('.' + selector.value + '_conf');
        Array.prototype.forEach.call(confs, function(conf) {
          conf.style.display = '';
        });
      }
  %body
    %form{:action => '/upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %input{:type => 'file', :name => 'file'}
      %select{:name => 'output_type', :onChange => 'show_one_conf_only(this);'}
        %option{:value => 'html'} html
        %option{:value => 'docx'} word
      %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}
    %div{:class => 'html_conf'} configuration of html
    %div{:class => 'docx_conf', :style => 'display:none'} configuration of docx
