module Houston
  
  def self.try(options, *rescue_from)
    options = { max_tries: options } if options.is_a?(Fixnum)
    options = {} unless options.is_a?(Hash)
    max_tries = options.fetch :max_tries, 3
    base = options.fetch :base, 2
    ignore = options.fetch :ignore, false
    
    tries = 1
    begin
      yield tries
    rescue *rescue_from
      unless (tries += 1) <= max_tries
        return if ignore
        raise
      end
      sleep base ** tries
      retry
    end
  end
  
end