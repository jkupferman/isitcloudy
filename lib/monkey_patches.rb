
# Add a nice output method to exceptions to provide better output
class Exception
  def pretty_printer
    "#{self.class.to_s} - #{self.message.to_s}:\n#{self.backtrace.join("\n")}"
  end
end

# Override how rails computes asset tags to work in multi-server deployments
module ActionView
  module Helpers
    module AssetTagHelper
      require 'digest/md5'

      def rails_asset_id(source)
        if asset_id = ENV["RAILS_ASSET_ID"]
          asset_id
        else
          if @@cache_asset_timestamps && (asset_id = @@asset_timestamps_cache[source])
            asset_id
          else
            path = File.join(ASSETS_DIR, source)
            asset_id = File.exist?(path) ? Digest::MD5.file(path).hexdigest[0..6] : ''
            
            if @@cache_asset_timestamps
              @@asset_timestamps_cache_guard.synchronize do
                @@asset_timestamps_cache[source] = asset_id
              end
            end
            
            asset_id
          end
        end
      end
    end
  end
end

