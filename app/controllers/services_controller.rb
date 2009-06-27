class ServicesController < ApplicationController
  def lastfm
    user = Scrobbler::User.new(LASTFM_USERNAME)
    
    begin
      Timeout::timeout(5) do
        @recent_tracks = user.recent_tracks.first(LASTFM_NUMBER_OF_TRACKS)
      end
      render :layout => false
    rescue Timeout::Error => e
      render :text => LASTFM_SERVICE_UNAVAILABLE_MESSAGE, :status => :service_unavailable
    rescue Errno::ETIMEDOUT => e
      render :text => LASTFM_SERVICE_UNAVAILABLE_MESSAGE, :status => :service_unavailable
    rescue SocketError => e
      render :text => LASTFM_SERVICE_UNAVAILABLE_MESSAGE, :status => :service_unavailable
    end
  end

  def twitter
    user = TWITTER_USERNAME
    
    begin
      Timeout::timeout(5) do
        @twits = Twitter::Search.new.from(user).fetch.results.first(TWITTER_NUMBER_OF_TWITS)
      end
      render :layout => false
    rescue Timeout::Error => e
      render :text => TWITTER_SERVICE_UNAVAILABLE_MESSAGE, :status => :service_unavailable
    rescue Errno::ETIMEDOUT => e
      render :text => TWITTER_SERVICE_UNAVAILABLE_MESSAGE, :status => :service_unavailable
    rescue SocketError => e
      render :text => TWITTER_SERVICE_UNAVAILABLE_MESSAGE, :status => :service_unavailable
    end
  end
end
