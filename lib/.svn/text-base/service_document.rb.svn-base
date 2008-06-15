module Atom
  module Acts #:nodoc:
    module ServiceDocument #:nodoc:
       require 'rexml/document'
       require 'rexml/element'
       require 'rexml/xpath'

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_service_document
          include Atom::Acts::ServiceDocument::InstanceMethods       
        end
      end

      module InstanceMethods
        
        def collections
          @collections || get_collections
        end
        
        def get_collections
          @collections = []
          ActionController::Routing::Routes.routes.each do |route| 
             controller = "#{route.requirements[:controller].camelize}Controller".constantize
             if controller.respond_to?:acts_as_collection? and not @collections.include?controller
                @collections << controller 
             end
          end
          @collections
        end
        
        def service_document          
          return @service_document || get_service_document
        end
        
        def get_service_document
              @service_document = REXML::Document.new
              @service_document << REXML::XMLDecl.default
              @service_document << REXML::Element.new('service')
              @service_document.root.add_namespace 'http://www.w3.org/2007/app'
              @service_document.root.add_namespace 'atom', 'http://www.w3.org/2005/Atom'
              
              collections.each do |collection|
                 col = REXML::Element.new 'collection'
                 #add href attribute
                 col.add_attribute 'href', collection.opts[:href]
                 #add title element
                 title = REXML::Element.new 'atom:title'
                 title.text = collection.opts[:title]
                 col.add_element title
                 #add accept elements
                 collection.opts[:accept].each do |accept|
                   accept_el = REXML::Element.new 'accept'
                   accept_el.text = accept.to_s
                   col.add_element accept_el
                 end
                 #add categories
                 if collection.opts[:categories]
                  collection.opts[:categories].each do |categories|
                     cats_el = REXML::Element.new 'categories'
                     if categories.include?:fixed and categories[:fixed] == 'yes'
                       cats_el.add_attribute 'fixed', categories[:fixed]
                       cats_el.add_attribute('scheme', categories[:scheme]) if categories[:scheme]
                       
                       categories.reject!{|key, value| key != :category}
                        categories.each do |cat, attrs|
                         cats = [] << attrs
                         cats.flatten.each do |c|
                           category = REXML::Element.new 'atom:category'
                           c.each do |att, value|
                             category.add_attribute att.to_s, value
                           end
                           cats_el.add_element category
                         end
                        end
                     elsif categories.include?:href
                        cats_el.add_attribute 'href', categories[:href]
                     end
                     
                     col.add_element cats_el
                   end
                 end
                 
                 #put the collection in the right workspace
                 workspaces = REXML::XPath.match(@service_document.root, './workspace') || []              
                 workspace = nil
                 workspaces.each do |wp|
                   if REXML::XPath.first(wp, './atom:title/text()') == collection.opts[:workspace]
                     workspace = wp
                     break
                   end
                 end
                 
                 unless workspace
                   workspace = REXML::Element.new 'workspace'
                   title = REXML::Element.new 'atom:title'
                   title.text = collection.opts[:workspace]                    
                   workspace.add_element title
                   @service_document.root.add_element workspace
                 end
                 
                 workspace.add_element col
              end
              @service_document
          end
      end
    end
  end
end