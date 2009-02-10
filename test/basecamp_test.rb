require File.dirname(__FILE__) + '/helper'

context "The Basecamp notifier" do

  setup do
    @config = {}
    @notifier = Integrity::Notifier::Basecamp
    @basecamp = BasecampApi
  end

  test "alerts Basecamp on build" do
    @notifier.any_instance.stubs(:short_message).returns('')
    @notifier.any_instance.stubs(:build_url).returns('')
    @notifier.any_instance.expects(:full_message).returns('')
    @basecamp.any_instance.expects(:post_message).returns(true)
    @notifier.notify_of_build(stub_everything(:failed? => false, :project => stub_everything), @config)
  end

  test "renders a haml config file" do
    haml = Integrity::Notifier::Basecamp.to_haml
    assert haml.include?('basecamp_notifier_account')
  end
end
