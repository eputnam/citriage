require "spec_helper"
require 'citriage/constants'

describe Constants do

  describe "the types" do
    it "VERSION is a string" do
      expect(Constants::VERSION).to be_a(String)
    end
    it "VERSION is not a fixnum" do
      expect(Constants::VERSION).to_not be_a(Fixnum)
    end
    it "BASE_URL is a string" do
      expect(Constants::BASE_URL).to be_a(String)
    end
    it "PLATFORMS is an array" do
      expect(Constants::PLATFORMS).to be_an(Array)
    end
  end

  describe "the values" do
    it "has a semver version number" do
      expect(Constants::VERSION).not_to be nil
      expect(Constants::VERSION).to match(/^\d\.\d\.\d$/)
    end

    it "uses the correct Jenkins url" do
      expect(Constants::BASE_URL).to start_with("https://jenkins-modules.puppetlabs.com/");
    end

    it "matches correct platforms" do
      expect(Constants::PLATFORMS).to match(['linux', 'windows', 'cross-platform', 'cloud', 'netdev'])
    end
  end

end
