require "spec_helper"
require 'citriage'

describe Citriage::Citriage do
  before(:each) do
    @triage = Citriage::Citriage.new
  end

  it "has a version number" do
    expect(Citriage::VERSION).not_to be nil
  end

  it "uses the correct URL" do
    expect(@triage.base_url).to start_with("https://jenkins-modules.puppetlabs.com/");
  end

end
