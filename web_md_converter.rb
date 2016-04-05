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
    :css
      #main_table td:nth-of-type(1) {
        text-align: right;
      }
    :javascript
      function foreach_selector(selector, func) {
        var elems = document.querySelectorAll(selector);
        Array.prototype.forEach.call(elems, function(elem) {
          func(elem);
        });
      }
      function hide_all_conf () {
        foreach_selector('[class*="conf"]', function(conf) {
          conf.style.display = 'none';
        });
      }
      function show_one_conf_only (elem) {
        hide_all_conf();
        foreach_selector('.' + elem.value + '_conf', function(conf) {
          conf.style.display = '';
        });
      }
  %body
    %form{:action => '/upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %table#main_table
        %tr
          %td markdown file
          %td
            %input{:type => 'file', :name => 'file'}
        %tr
          %td output type
          %td
            %select{:name => 'output_type', :onChange => 'show_one_conf_only(this);'}
              %option{:value => 'html'} html
              %option{:value => 'docx'} word
        %tr
          %td
          %td
            %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}
    %div.html_conf configuration of html
    %div.docx_conf{:style => 'display:none'} configuration of docx
