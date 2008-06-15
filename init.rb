# Include hook code here
require 'atom_pub_server'
ActionController::Base.send(:include, Atom::Acts::ServiceDocument)
ActionController::Base.send(:include, Atom::Acts::Collection)
#ActionView::Helpers::AtomFeedHelper.send(:include, Atom::Acts::Feed)

Mime::Type.register 'application/atomsvc+xml', :atom_svc
Mime::Type.register 'application/atomcat+xml', :atom_cat
Mime::Type.register 'application/atom+xml;type=entry', :atom_entry
