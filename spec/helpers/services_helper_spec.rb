require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ServicesHelper

describe ServicesHelper do
  
  before(:each) do
    @track = mock('Track')
  end
  
  it "should return nil when song name is missing" do
    @track.stub!(:artist).and_return('Kreator')
    @track.stub!(:album).and_return('Warcurse')
    @track.stub!(:name).and_return('')
    get_full_track_name(@track).should be_nil
  end
  
  it "should return valid song name when artist and album are missing" do
    @track.stub!(:artist).and_return('')
    @track.stub!(:album).and_return('')
    @track.stub!(:name).and_return('Warcurse')
    get_full_track_name(@track).should == 'Warcurse'
  end
  
  it "should return valid song name when album is missing" do
    @track.stub!(:artist).and_return('Kreator')
    @track.stub!(:album).and_return('')
    @track.stub!(:name).and_return('Warcurse')
    get_full_track_name(@track).should == 'Kreator - Warcurse'
  end
  
  it "should return valid song name when artist is missing" do
    @track.stub!(:artist).and_return('')
    @track.stub!(:album).and_return('Hordes Of Chaos')
    @track.stub!(:name).and_return('Warcurse')
    get_full_track_name(@track).should == 'Warcurse (Hordes Of Chaos)'
  end
  
  it "should return valid song name when artist, album and song is available" do
    @track.stub!(:artist).and_return('Kreator')
    @track.stub!(:album).and_return('Hordes Of Chaos')
    @track.stub!(:name).and_return('Warcurse')
    get_full_track_name(@track).should == 'Kreator - Warcurse (Hordes Of Chaos)'
  end
  

  

  

  

  
end
