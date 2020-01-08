require 'rails_helper'

RSpec.describe Appza, type: :model do
  let(:appza) { FactoryBot.build :appza }
  
  subject { appza }

  describe "is valid" do
    it "should be valid" do
      expect(appza).to be_valid
    end

    it "should respond to name" do
      expect(appza).to respond_to(:name)
    end

    it "should respond to url" do
      expect(appza).to respond_to(:url)
    end
    
    it "should respond to callback_url" do
      expect(appza).to respond_to(:callback_url)
    end

    it "should respond to accept_header" do
      expect(appza).to respond_to(:accept_header)
    end
    
    it "should respond to requires" do
      expect(appza).to respond_to(:requires)
    end
  end

  describe "is invalid" do
    it "is invalid without a name" do
      appza.name = nil
      expect(appza).to_not be_valid
    end
    
    it "is invalid if name is empty" do
      appza.name = ''
      expect(appza).to_not be_valid
    end
    
    it "is invalid if name length is < 3" do
      appza.name = 'ab'
      expect(appza).to_not be_valid
    end

    it "is invalid if name length is > 30" do
      appza.name = '1234567891234567891234567891234'
      expect(appza).to_not be_valid
    end

    it "is invalid without a url" do
      appza.url = nil
      expect(appza).to_not be_valid
    end
    
    it "is invalid if url is empty" do
      appza.url = ''
      expect(appza).to_not be_valid
    end

    it "is invalid without a callback_url" do
      appza.callback_url = nil
      expect(appza).to_not be_valid
    end
    
    it "is invalid if callback_url is empty" do
      appza.callback_url = ''
      expect(appza).to_not be_valid
    end

    it "is invalid without a accept_header" do
      appza.accept_header = nil
      expect(appza).to_not be_valid
    end
    
    it "is invalid if accept_header is empty" do
      appza.accept_header = ''
      expect(appza).to_not be_valid
    end

    it "is invalid without requires" do
      appza.requires = nil
      expect(appza).to_not be_valid
    end
    
    it "is invalid if requires is empty or less than 1" do
      appza.requires = []
      expect(appza).to_not be_valid
    end

    it "is invalid if requires is > 4" do
      appza.requires = ["a", "b", "c", "d", "e"]
      expect(appza).to_not be_valid
    end
  end
end
