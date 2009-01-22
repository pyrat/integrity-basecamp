require File.dirname(__FILE__) + '/helper'

context "The Basecamp notifier" do
  setup do
    @config = {}
    @notifier = Integrity::Notifier::Basecamp
  end

  test "alerts Basecamp on build" do
    @notifier.any_instance.expects(:room).at_least_once.returns mock(:speak => true)
    @notifier.any_instance.expects(:short_message).returns('')
    @notifier.any_instance.expects(:build_url).returns('')
    @notifier.notify_of_build(stub_everything(:failed? => false, :project => stub_everything), @config)
  end

  test "sends the full message on failure only" do
    @notifier.any_instance.expects(:room).at_least_once.returns mock \
      :speak => true,
      :paste => true

    @notifier.any_instance.expects(:full_message).returns('')
    @notifier.any_instance.expects(:short_message).returns('')
    @notifier.any_instance.expects(:build_url).returns('')

    @notifier.notify_of_build(stub_everything(:failed? => true, :project => stub_everything), @config)

  end

  test "renders a haml config file" do
    haml = Integrity::Notifier::Basecamp.to_haml
    assert haml.include? 'basecamp_notifier_account'
  end
end
