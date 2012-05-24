module ActiveAdmin
  module ViewHelpers
    module BreadcrumbHelper

			# Returns an array of links to use in a breadcrumb
			def breadcrumb_links(path = nil)
				path ||= request.fullpath
				parts = path.gsub(/^\//, '').split('/')
				parts.pop unless %w{ create update }.include?(params[:action])
				crumbs = []
				parts.each_with_index do |part, index|
					name = ""
					if part =~ /^\d/ && parent = parts[index - 1]
						begin
							parent_class = active_admin_namespace.resources.find_by_key(parent.singularize.titleize).resource
							obj = parent_class.find(part.to_i)
							name = obj.display_name if obj.respond_to?(:display_name)
						rescue
						end
					end
					name = part.titlecase if name == ""

					#if resource is defined, this is "show" link and it does not respond to "show"
					if part =~ /^\d/ && parent = parts[index - 1] && 
							active_admin_namespace.resources.find_by_key(parent.singularize.titleize) && 
							!active_admin_namespace.resources.find_by_key(parent.singularize.titleize).respond_to?(:show)
						begin
							crumbs << I18n.translate!("activerecord.models.#{part.singularize}")
						rescue I18n::MissingTranslationData
							crumbs << name
						end
					else
						begin
							crumbs << link_to( I18n.translate!("activerecord.models.#{part.singularize}", :count => 2), "/" + parts[0..index].join('/'))
						rescue I18n::MissingTranslationData
							crumbs << link_to( name, "/" + parts[0..index].join('/'))
						end
					end
				end
				crumbs
			end

    end
  end
end
