# frozen_string_literal: true

require "enumish/version"
require "active_support"

module Enumish
  extend ActiveSupport::Concern

  module ClassMethods
    def method_missing(method_id, *args, &block)
      if !method_id.to_s.match(/\?$/) && enum_ids.include?(method_id.to_s)
        obj = self.where(enum_id => method_id.to_s).first
        return obj if obj.present?
      end

      super method_id, *args, &block
    end

    def enum_id
      :short
    end

    def refresh_enum_ids!
      Mutex.new.synchronize do
        @enum_ids = self.pluck(enum_id)
      end
    end

    def enum_ids
      refresh_enum_ids! if @enum_ids.blank?
      @enum_ids
    end
  end

  # Allow calls such as object.friendly? or model.attitude.friendly?
  def method_missing(method_id, *args, &block)
    bare_method = if method_id.to_s.match(/\?$/) && args.empty? && block.nil?
      method_id.to_s.sub(/\?$/, "")
    end

    if bare_method && self.class.enum_ids.include?(bare_method)
      self.send(self.class.enum_id.to_s) == bare_method
    else
      super
    end
  end

  def to_s
    self.send(self.class.enum_id).to_s
  end

  def to_sym
    self.send(self.class.enum_id).to_sym
  end
end
