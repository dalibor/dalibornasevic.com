class ServicesController < ApplicationController
  def lastfm
    user = Scrobbler::User.new(LASTFM::USERNAME)
    
    begin
      Timeout::timeout(5) do
        @recent_tracks = user.recent_tracks.first(LASTFM::NUMBER_OF_TRACKS)
      end
      render :layout => false
    rescue Timeout::Error => e
      render :text => LASTFM::SERVICE_UNAVAILABLE, :status => :service_unavailable
    rescue Errno::ETIMEDOUT => e
      render :text => LASTFM::SERVICE_UNAVAILABLE, :status => :service_unavailable
    rescue SocketError => e
      render :text => LASTFM::SERVICE_UNAVAILABLE, :status => :service_unavailable
    end
  end

  def twitter
    user = TWITTER::USERNAME
    
    begin
      Timeout::timeout(5) do
        @twits = Twitter::Search.new.from(user).fetch.results.first(TWITTER::NUMBER_OF_TWITS)
      end
      render :layout => false
    rescue Timeout::Error => e
      render :text => TWITTER::SERVICE_UNAVAILABLE, :status => :service_unavailable
    rescue Errno::ETIMEDOUT => e
      render :text => TWITTER::SERVICE_UNAVAILABLE, :status => :service_unavailable
    rescue SocketError => e
      render :text => TWITTER::SERVICE_UNAVAILABLE, :status => :service_unavailable
    end
  end
end
