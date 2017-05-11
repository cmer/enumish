# frozen_string_literal: true

require "enumish/version"
require "active_support"

module Enumish
  extend ActiveSupport::Concern

  module ClassMethods
    def method_missing(method_id, *args, &block)
      if !method_id.to_s.match(/\?$/)
        obj = self.where(enum_id => method_id.to_s).first
        return obj if obj.present?
      end

      super method_id, *args, &block
    end

    def enum_id
      :short
    end
  end

  # Allow calls such as object.friendly? or model.attitude.friendly?
  def method_missing(method_id, *args, &block)
    if method_id.to_s.match(/\?$/) && args.empty? && block.nil?
      self.send(self.class.enum_id.to_s) == method_id.to_s.sub(/\?$/, "")
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
