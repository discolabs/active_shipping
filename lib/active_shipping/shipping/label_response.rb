module ActiveMerchant #:nodoc:
  module Shipping

    # This is UPS specific for now; the hash is not at all generic
    # or common between carriers.

    class LabelResponse < Response

      attr :params # maybe?

      def initialize(success, message, params = {}, options = {})
        @params = params
        super
      end

      def labels
        return @labels if @labels
        packages = params["ShipmentResults"]["PackageResults"]
        packages = [ packages ] if Hash === packages
        @labels  = packages.map do |package|
          { :tracking_number => package["TrackingNumber"],
            :image           => package["LabelImage"] }
        end
      end

      protected

      # I'm following already established conventions.  Other response objects
      # expect a hash like object.  This object is bound to vary from carrier
      # to carrier, but I Ain't Gonna Need It...
      def extract_package_data params
        begin
          packages = params["ShipmentResults"]["PackageResults"]
          packages = [ packages ] if Hash === packages
          @labels  = packages.map do |package|
            { :tracking_number => package["TrackingNumber"],
              :image => package["LabelImage"]
            }
          end
        rescue RuntimeError => e
          warn "Params do not appear to contain package data. #{params.keys}"
        end
      end
    end

  end
end
