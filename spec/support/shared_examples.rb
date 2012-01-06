shared_examples_for "protected resource" do
  it "should protect resource" do
    flash[:alert].should_not be_nil
    response.should be_redirect
  end
end

shared_examples_for "accessible resource" do
  it "should protect resource" do
    flash[:alert].should be_nil
  end
end
