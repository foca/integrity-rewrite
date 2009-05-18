module Integrity
  module Helpers
    module PrettyOutputHelper
      # Cycle between a list of values, each time outputting the "next" one
      # in the sequence. For example
      #
      #     <li class="<%= cycle("even", "odd") %>">...</li>
      #
      # Will output "even" the first time it's called, "odd" the second one,
      # "even" the third, and so on.
      def cycle(*values)
        @cycles ||= {}
        @cycles[values] ||= -1 # this is so the first value returned is 0
        next_value = @cycles[values] = (@cycles[values] + 1) % values.size
        values[next_value]
      end

      # Return a list of breadcrumbs pointing to the current page. This is
      # a fairly naive implementation that assumes that the entire URL is
      # meaningful. For example, for the URL <tt>/foo/bar/baz</tt> this will
      # generate:
      #
      #     <a href="/foo">foo</a> / <a href="/bar">bar</a> / baz
      #
      # The separator (by default " / ") can be passed as an argument.
      def breadcrumbs(separator=" / ")
        crumbs = env["PATH_INFO"].split("/").map {|path| { :path => path, :name => path } }
        crumbs[0] = { :path => "/", :name => "projects" }
        crumbs = crumbs[0..-2].inject([]) do |crumbs_so_far, current|
          crumbs_so_far << %(<a href="#{current[:path]}">#{current[:name]}</a>)
        end << crumbs.last[:name]
        crumbs.join(separator)
      end

      # Substitute bash color codes for html tags so they can be styled. The
      # escape sequences are replaced as follows:
      #
      # \e[0m::  </span>
      # \e[31m:: <span class="color31>
      # \e[32m:: <span class="color32>
      # \e[33m:: <span class="color33>
      # \e[34m:: <span class="color34>
      # \e[35m:: <span class="color35>
      # \e[36m:: <span class="color36>
      # \e[37m:: <span class="color37>
      def bash_color_codes(string)
        string.gsub("\e[0m", '</span>').
          gsub("\e[31m", '<span class="color31">').
          gsub("\e[32m", '<span class="color32">').
          gsub("\e[33m", '<span class="color33">').
          gsub("\e[34m", '<span class="color34">').
          gsub("\e[35m", '<span class="color35">').
          gsub("\e[36m", '<span class="color36">').
          gsub("\e[37m", '<span class="color37">')
      end

      # Show the date in a "friendly" format. Possible values are <tt>today</tt>,
      # <tt>yesterday</tt> and the date formatted as: <tt>on Mar 21st</tt> (if
      # the date was, for example, March 21st)
      def pretty_date(date_time)
        days_away = (Date.today - Date.new(date_time.year, date_time.month, date_time.day)).to_i
        if days_away == 0
          "today"
        elsif days_away == 1
          "yesterday"
        else
          strftime_with_ordinal(date_time, "on %b %d%o")
        end
      end

      # Do the same as <tt>Time#strftime</tt>, but also recognize the escape
      # sequence <tt>%o</tt> which is replaced by the ordinal form of the date
      # (<tt>st</tt>, <tt>nd</tt>, <tt>rd</tt> or <tt>th</tt>)
      def strftime_with_ordinal(date_time, format_string)
        ordinal = case date_time.day
          when 1, 21, 31 then "st"
          when 2, 22     then "nd"
          when 3, 23     then "rd"
          else                "th"
        end

        date_time.strftime(format_string.gsub("%o", ordinal))
      end

      # Display the page title, according to whatever was set from the application
      # when rendering a view.
      def page_title
        h Array(@title).join(" / ") + " | integrity"
      end
    end
  end
end
