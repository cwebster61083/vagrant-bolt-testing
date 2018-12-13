require 'config_builder/model'

module VagrantTesting
  module Vmpooler
    class ConfigBuilder < ::ConfigBuilder::Model::Provider::Base

      # @!attribute [rw] token
      def_model_attribute :token
      # @!attribute [rw] url
      def_model_attribute :url
      # @!attribute [rw] verbose
      def_model_attribute :verbose
      # @!attribute [rw] os
      def_model_attribute :os
      # @!attribute [rw] password
      def_model_attribute :password
      # @!attribute [rw] ttl
      def_model_attribute :ttl
      # @!attribute [rw] disk
      def_model_attribute :disk

      def instance_id
        'vmpooler'
      end

      ::ConfigBuilder::Model::Provider.register('vmpooler', self)
    end
  end
end
