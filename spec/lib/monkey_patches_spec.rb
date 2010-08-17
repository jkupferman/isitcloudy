require File.join(File.dirname(__FILE__), '..', 'spec_helper')


describe Exception, " pretty_printer" do
  it "should have a pretty_printer method" do
    Exception.new.respond_to?(:pretty_printer).should be_true
  end

  class AnyExceptionSubclass < Exception; end

  context AnyExceptionSubclass do
    it "should have a pretty_printer method" do
      AnyExceptionSubclass.new.respond_to?(:pretty_printer).should be_true
    end
  end

  class AnyErrorSubclass < StandardError; end

  context AnyErrorSubclass do
    it "should have a pretty_printer method" do
      AnyErrorSubclass.new.respond_to?(:pretty_printer).should be_true
    end
  end
end
