module ActionView
  module Helpers #:nodoc
    module AtomFeedHelper #:nodoc
      
      alias_method :__atom_feed, :atom_feed
      
      def atom_feed(options = {}, &block)
        xml = options[:xml] || eval("xml", block.binding)
        xml.instruct!

        feed_opts = { "xml:lang" => options[:language] || "en-US", "xmlns" => 'http://www.w3.org/2005/Atom' }

        options.each do |key, value|
          feed_opts[key] = value if key.match(/^xmlns/)
        end

        xml.feed feed_opts do
          xml.id("tag:#{request.host}:#{request.request_uri.split(".")[0].gsub("/", "")}")      
          xml.link(:rel => 'alternate', :type => 'text/html', :href => options[:root_url] || (request.protocol + request.host_with_port))

          if options[:url]
            xml.link(:rel => 'self', :type => 'application/atom+xml', :href => options[:url] || request.url)
          end

          yield AtomFeedBuilder.new(xml, self)
        end
      end
      
    end
  end
end