module Atom
  module Acts #:nodoc:
    module Collection #:nodoc:
      class UndefinedOptionError < StandardError ; end
      class UnsupportedContentTypeError < StandardError ; end

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_collection(opts = {})
          include Atom::Acts::Collection::InstanceMethods
          extend Atom::Acts::Collection::SingletonMethods
          raise UndefinedOptionError('accept') unless opts.include?:accept
          raise UndefinedOptionError('href') unless opts.include?:href
          raise UndefinedOptionError('title') unless opts.include?:title
          raise UndefinedOptionError('workspace') unless opts.include?:workspace
          accept = [] << opts[:accept]
          opts[:accept] = accept.flatten
          
          if opts[:categories]
            categories_list = [] << opts[:categories]
            opts[:categories] = categories_list.flatten
          end
          @opts = opts
        end
        
      end

      module SingletonMethods
        def acts_as_collection?
          true
        end
        
        def opts
          @opts
        end
        
        collection_post_method = ENV['COLLECTION_POST_METHOD'] || :create
        entry_put_method = ENV['ENTRY_PUT_METHOD'] || :update
        ActionController::Base.before_filter :filter_content_type, :only => [collection_post_method, entry_put_method]
      end

      module InstanceMethods
=begin
    This filter format has been deprecated, 
    please, visit http://ryandaigle.com/articles/2007/10/22/what-s-new-in-edge-rails-filters-get-tweaked for more info
        def filter_content_type
          self.class.opts[:accept].each do |type|
            return true if (type == request.format)
          end
          return false
        end
=end
      end
    end
  end
end