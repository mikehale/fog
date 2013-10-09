module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppMetadata.html
        #   vCloud API Documentation
        # @since vCloud API version 1.5
        def get_vapp_metadata(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/metadata/"
          )
        end
      end
    end
  end
end