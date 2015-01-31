require 'rubygems'
require 'sinatra'

use Rack::Session::Pool

@library_call = true
require './world'

get '/' do
  haml :app
end

post '/evolve' do
  if session['world_name'] != params[:world_name]
    session['world_name'] = params[:world_name] 
    session['world'] = TwoDimensionalRectangularWorld.new(File.read(File.dirname(__FILE__) + "/sample_worlds/#{params[:world_name]}.gol"))
  else
    session['world'].evolve!
  end
  session['world'].to_s
end

__END__

@@ app
%html
  %head
    %title Sinatra Game of Life Demo

    %script{:type => 'text/javascript', :src => 'jquery-1.5.1.min.js'}

    :javascript
      var timer = null;
      
      function schedule_poll() {
        var reload_milliseconds = parseFloat($('#refresh_rate').val()) * 1000;
        timer = setTimeout(function(){poll_world()}, reload_milliseconds);
      }
      
      function poll_world() {
        timer = null;
        if($('#pause_button').val() == 'pause') {
          $.post($('#evolve').attr('action'), $('#evolve').serialize(), function(data){
            $('#world').text(data);
          }, "text");
        }
        schedule_poll();
      }
    
      $(document).ready(function() {
        poll_world();
        
        $('#pause_button').click(function() {
          // The timer will still be running - should really be clearing it here
          if ($(this).val() == 'pause') {
            $(this).val('resume');  
          } else {
            $(this).val('pause');
          }
        });
      });
      
  %body
    #content{:style => "text-align:center"}
      %h1 Cellular Automation Simulation
      %pre#world{:style => "margin-bottom:40px"} 
        Loading..
      %form#evolve{:action => '/evolve'}
        #actions
          %select{:name => 'world_name'}
            %option{:value => 'oscillator-pulsar'} Pulsar Oscillator 
            %option{:value => 'oscillator-blinking'} Blinking Oscillator 
            %option{:value => 'spaceship-lightweight'} Lightweight Spaceship 
            %option{:value => 'gosper_glider_gun'} Gosper Glider Gun 
          %label{:for => 'refresh_rate'} Refresh Rate (in seconds):
          %input.pink{:type => "text", :id => "refresh_rate", :value => "1.0"}
          %input.pink{:type => "button", :id => "pause_button", :value => "pause"}
      %p
        The code for this implementation of
        %a{:href => "http://en.wikipedia.org/wiki/Conway's_Game_of_Life"} Life
        is at:
        %a{:href => "http://github.com/jkotchoff/game_of_life"} 
          http://github.com/jkotchoff/game_of_life
