require "../spec_helper"

describe Crux::Matcher::Any do
  it "always matches" do
    Crux::Matcher::Any.new.match?(FakeContext.new).should be_truthy
  end
end
