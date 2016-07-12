require "thread_safe"

module Houston
  class Actions

    def initialize
      @actions = ThreadSafe::Hash.new
    end

    def exists?(name)
      actions.key?(name)
    end

    def define(name, &block)
      raise ArgumentError, "#{name.inspect} is already defined" if exists?(name)
      actions[name] = block
    end

    def run(name, params={}, options={})
      block = actions.fetch(name)
      Houston.async do
        run! name, params, options.fetch(:trigger, "manual"), block
      end
    end

  private
    attr_reader :actions

    def run!(name, params, trigger, block)
      Action.record name do
        Rails.logger.info "\e[34m[#{name}/#{trigger}] Running job\e[0m"
        block.call # TODO: put params here
      end
    rescue Exception # rescues StandardError by default; but we want to rescue and report all errors
      Houston.report_exception($!, parameters: {action_name: name, trigger: trigger, params: params})
    end

  end
end