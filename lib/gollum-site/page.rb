module Gollum
  class Page
    # Add ".html" extension to page links
    def self.cname(name)
      cname = name.respond_to?(:gsub)      ?
      name.gsub(%r{[ /<>]}, '-') :
        ''
      cname + '.html'
    end

    def find(cname, version)
      name = cname[0..-6]
      map = @wiki.tree_map_for(version)
      if page = find_page_in_tree(map, name)
        page.version = Grit::Commit.create(@wiki.repo, :id => version)
        page
      end
    end
  end
end
