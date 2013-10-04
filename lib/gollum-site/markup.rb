module Gollum
  class SiteMarkup < Gollum::Markup
    # Attempt to process the tag as a page link tag.
    #
    # tag       - The String tag contents (the stuff inside the double
    #             brackets).
    # no_follow - Boolean that determines if rel="nofollow" is added to all
    #             <a> tags.
    #
    # Returns the String HTML if the tag is a valid page link tag or nil
    #   if it is not.
    def process_page_link_tag(tag, no_follow = false)
      parts = tag.split('|')
      name  = parts[0].strip
      cname = @wiki.page_class.cname((parts[1] || parts[0]).strip)
      if pos = cname.index('#')
        extra = cname[pos..-1]
        cname = cname[0..(pos-1)]
      end
      tag = if name =~ %r{^https?://} && parts[1].nil?
        %{<a href="#{name}">#{name}</a>}
      else
        presence    = "absent"
        link_name   = cname
        if @wiki.site.find_page(cname)
          SiteLog.debug("Marking link #{cname} as present")
          presence  = "present"
        end
          SiteLog.debug("Marking link #{cname} as absent")
        link = ::File.join(@wiki.base_path, CGI.escape(link_name))
        %{<a class="internal #{presence}" href="#{link}#{extra}">#{name}</a>}
      end
      if tag && no_follow
        tag.sub! /^<a/, '<a ref="nofollow"'
      end
      tag
    end

  end
end
