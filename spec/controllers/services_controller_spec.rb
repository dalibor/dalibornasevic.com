require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServicesController, "lastfm" do

  before(:each) do
    Scrobbler::User.stub!(:new).with(LASTFM::USERNAME).and_return(@lastfm_user = mock('Scrobbler User'))
 @lastfm_user.stub!(:recent_tracks).and_return(@recent_tracks = mock('recent tracks'))
@recent_tracks.stub!(:first).with(LASTFM::NUMBER_OF_TRACKS).and_return(@tracks = [mock('track')])
  end

  it "should be successful" do
    Scrobbler::User.should_receive(:new).with(LASTFM::USERNAME).and_return(@lastfm_user)
    @lastfm_user.should_receive(:recent_tracks).and_return(@recent_tracks)
    @recent_tracks.should_receive(:first).and_return(@tracks)
    get 'lastfm'
    response.should be_success
    assigns(:recent_tracks).should_not be_nil
  end
end

describe ServicesController, "twitter" do
  
  before(:each) do
    Twitter::Search.stub!(:new).and_return(@twitter_search = mock('Twitter Search'))
    @twitter_search.stub!(:from).with(TWITTER::USERNAME).and_return(@twitter_search_from = mock('Twitter Search From'))
    @twitter_search_from.stub!(:fetch).and_return(@mash_object = mock('twitter mash'))
    @mash_object.stub!(:results).and_return(@results = [mock('twit')])
    @results.stub!(:first).with(TWITTER::NUMBER_OF_TWITS).and_return(@twits = mock('twits'))
  end
  
    it "should be successful" do
      Twitter::Search.should_receive(:new).and_return(@twitter_search)
      @twitter_search.should_receive(:from).with(TWITTER::USERNAME).and_return(@twitter_search_from)
      @twitter_search_from.should_receive(:fetch).and_return(@mash_object)
      @mash_object.should_receive(:results).and_return(@results)
      @results.should_receive(:first).with(TWITTER::NUMBER_OF_TWITS).and_return(@twits)
      get 'twitter'
      response.should be_success
      assigns(:twits).should_not be_nil
    end
end
