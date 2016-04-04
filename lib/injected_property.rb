require 'injected_property/version'
require 'active_support/concern'

module InjectedProperty
  extend ActiveSupport::Concern

  included do
    private

    @@properties = {}
    @@setters = @@getters = nil

    def self.injected_accessors(*properties,
                                before_set: nil, after_set: nil,
                                before_get: nil, after_get: nil,
                                inject_set: nil, inject_get: nil)
      properties.each do |property|
        property = property.to_s

        if @@properties[property]
          raise "Already defined property `#{property}`."
        end

        @@properties[property] = { before_set: before_set, after_set: after_set,
                                   before_get: before_get, after_get: after_get,
                                   inject_set: inject_set,
                                   inject_get: inject_get }
      end

      @@setters = @@properties.keys.each_with_object('=').map(&:+)
      @@getters = @@properties.keys

      private

      attr_accessor *properties
    end

    public

    def method_missing(name, *args)
      name = name.to_s

      if @@setters.include?(name)
        injected_writer(name, @@properties[name.gsub('=', '')], *args)
      elsif @@getters.include?(name)
        injected_reader(name, @@properties[name])
      else
        raise NoMethodError,
              "undefined method `#{name}' for #{self}:#{self.class}"
      end
    end

    private

    def injected_reader(name, callbacks)
      execute_callback(callbacks[:before_get])

      read_value = if callbacks[:inject_get]
                     execute_callback(callbacks[:inject_get], send(name))
                   else
                     send name
                   end

      execute_callback(callbacks[:after_get], read_value)

      read_value
    end

    def injected_writer(name, callbacks, *args)
      execute_callback(callbacks[:before_set], *args)

      write_value = if callbacks[:inject_set]
                      send name, execute_callback(callbacks[:inject_set], *args)
                    else
                      send name, *args
                    end

      execute_callback(callbacks[:after_set], write_value)

      write_value
    end

    def execute_callback(callback, *args)
      case callback
      when Symbol, String then send callback, *args
      when Proc then callback.(self, *args)
      end
    end
  end
end
