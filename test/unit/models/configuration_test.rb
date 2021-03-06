require "test_helper"
require "support/houston/module1"
require "support/houston/module2"

class ConfigurationTest < ActiveSupport::TestCase


  context "#action" do
    should "define a new action" do
      config.action("test-action") { }
      assert config.actions.exists?("test-action")
    end

    should "raise if a block isn't given" do
      assert_raises ArgumentError do
        config.action("test-action")
      end
    end

    should "raise if the action has already been defined" do
      config.action("test-action") { }
      assert_raises ArgumentError do
        config.action("test-action") { }
      end
    end
  end


  context "#every" do
    should "define an action and a timer that triggers it when you pass two arguments" do
      assert_difference "config.triggers.count", +1 do
        config.every("10m", "test-action") { }
        assert config.actions.exists?("test-action")
      end
    end

    should "define an action and a timer that triggers it when you pass a hash" do
      assert_difference "config.triggers.count", +1 do
        config.every("10m" => "test-action") { }
        assert config.actions.exists?("test-action")
      end
    end

    should "define a timer for an existing action" do
      assert_difference "config.triggers.count", +1 do
        config.action("test-action") { }
        config.every "10m" => "test-action"
      end
    end

    should "raise if the action requires any params" do
      config.action("test-action", ["required_param"]) { }
      assert_raises Houston::Observer::MissingParamError do
        config.every "10m" => "test-action"
      end
    end
  end


  context "#on" do
    should "define an action and an observer that triggers it when you pass two arguments" do
      assert_difference "config.triggers.count", +1 do
        config.on("hooks:example", "test-action") { }
        assert config.actions.exists?("test-action")
      end
    end

    should "define the action to require the params passed by the event" do
      action = config.on("hooks:example", "test-action") { }
      assert_equal %w{params}, action.required_params
    end

    should "define an action and an observer that triggers it when you pass a hash" do
      assert_difference "config.triggers.count", +1 do
        config.on("hooks:example" => "test-action") { }
        assert config.actions.exists?("test-action")
      end
    end

    should "define an observer for an existing action" do
      assert_difference "config.triggers.count", +1 do
        config.action("test-action") { }
        config.on "hooks:example" => "test-action"
      end
    end

    should "raise if the event doesn't supply the action's required params" do
      config.action("test-action", ["required_param"]) { }
      assert_raises Houston::Observer::MissingParamError do
        config.on "hooks:example" => "test-action"
      end
    end
  end


  context "#use" do
    should "add a module to the list of modules to be loaded" do
      config.use :module1
      assert config.uses?(:module1)
    end

    should "configure the module when passed a block" do
      config.use :module1 do
        self.option1 = "value1"
      end
      assert_equal "value1", Houston::Module1.config.option1
    end

    should "raise an exception if passed a block for a module that doesn't accept configuration" do
      assert_raises ArgumentError do
        config.use :module2 do
          # Module2 doesn't accept configuration
        end
      end
    end

    should "not load a module twice" do
      config.use :module1
      config.use :module1
      assert_equal 1, config.modules.length
    end

    should "combine configuration if a module is used more than once" do
      config.use :module1 do
        self.option1 = "value1"
      end
      config.use :module1 do
        self.option2 = "value2"
      end
      assert_equal "value1", Houston::Module1.config.option1
      assert_equal "value2", Houston::Module1.config.option2
    end

    should "automatically use a module that is declared as a dependency" do
      config.use :module2
      assert config.uses? :module1
    end
  end


private

  def config
    @config ||= Houston::Configuration.new
  end

end
