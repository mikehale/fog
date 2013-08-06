require 'fog/core/model'

module Fog
  module AWS
    class AutoScaling
      class Configuration < Fog::Model

        identity  :id,                    :aliases => 'LaunchConfigurationName'
        attribute :arn,                   :aliases => 'LaunchConfigurationARN'
        attribute :block_device_mappings, :aliases => 'BlockDeviceMappings'
        attribute :created_at,            :aliases => 'CreatedTime'
        attribute :image_id,              :aliases => 'ImageId'
        attribute :instance_monitoring,   :aliases => 'InstanceMonitoring', :squash => 'Enabled'
        attribute :instance_type,         :aliases => 'InstanceType'
        attribute :kernel_id,             :aliases => 'KernelId'
        attribute :key_name,              :aliases => 'KeyName'
        attribute :ramdisk_id,            :aliases => 'RamdiskId'
        attribute :security_groups,       :aliases => 'SecurityGroups'
        attribute :user_data,             :aliases => 'UserData'

        def ready?
          # AutoScaling requests are synchronous
          true
        end

        def save
          requires :id
          requires :image_id
          requires :instance_type

          options = Hash[self.class.aliases.map { |key, value| [key, send(value)] }]
          options.delete_if { |key, value| value.nil? }
          service.create_launch_configuration(image_id, instance_type, id, options) #, listeners.map{|l| l.to_params})

          reload
        end

        def destroy
          requires :id
          service.delete_launch_configuration(id)
        end

      end
    end
  end
end
