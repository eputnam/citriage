require "spec_helper"
require 'citriage/constants'

describe Citriage do

  before(:each) do
    @citriage = Citriage.new
  end

  it "not be nil" do
    expect(@citriage).to_not be(nil)
  end

end
