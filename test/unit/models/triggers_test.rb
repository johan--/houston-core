require "test_helper"

class TriggersTest < ActiveSupport::TestCase

  def setup
    config.actions.define("test-action") { }
  end


  should "raise an error if a trigger has already been registered" do
    triggers.every("day at 5:30pm", "test-action")
    assert_raises Houston::DuplicateTriggerError do
      triggers.every("day at 5:30pm", "test-action")
    end

    # Triggers with different params count as different
    triggers.every("day at 5:30pm", "test-action", param: 1)
    refute_raises Houston::DuplicateTriggerError do
      triggers.every("day at 5:30pm", "test-action", param: 2)
    end
  end


  should "allow you to invoke an action without params" do
    trigger = triggers.every("day at 5:30pm", "test-action")
    mock(config.actions).run("test-action", {}, hash_including(trigger: trigger.to_s))
    trigger.call
  end

  should "allow triggers to pass params to an action" do
    trigger = triggers.every("day at 5:30pm", "test-action", trigger_param: 1)
    mock(config.actions).run("test-action", {trigger_param: 1}, hash_including(trigger: trigger.to_s))
    trigger.call
  end

  should "allow callbacks to override triggers' params" do
    trigger = triggers.every("day at 5:30pm", "test-action", trigger_param: 1)
    mock(config.actions).run("test-action", {trigger_param: 2}, hash_including(trigger: trigger.to_s))
    trigger.call(trigger_param: 2)
  end


private

  def triggers
    config.triggers
  end

  def config
    @config ||= Houston::Configuration.new
  end

end
