#!/usr/bin/env ruby
#
# replace by regex

module Jekyll
  module RegexFilter
    def regex_replace(input, reg_str, repl_str)
      return nil if input.nil?
      re = Regexp.new reg_str

      # This will be returned
      input.gsub re, repl_str
    end
  end
end

Liquid::Template.register_filter(Jekyll::RegexFilter)
