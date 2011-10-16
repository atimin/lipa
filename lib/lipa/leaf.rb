=begin
Lipa - DSL for description treelike structures in Ruby

Copyright (c) 2011 Aleksey Timin

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end


module Lipa
  class Leaf 
    attr_accessor :attrs
    @@init_methods = {"leaf" => self, "object" => self}
    @@kinds = {}

    def initialize(name, attrs = {}, &block)
      @attrs = attrs 
      @attrs[:name] = name.to_s

      if attrs[:kind]
        @kind = @@kinds[attrs[:kind].to_sym]

        @attrs.merge! @kind.attrs
      end

      instance_eval &block if block_given?
    end

    def method_missing(name, *args, &block)
      case args.size
        when 0
          val = @attrs[name]
          if val.class == Proc
            val.call
          else
            val
          end
        when 1
          name = name.to_s
          name["="] = "" if name["="]
          @attrs[name.to_sym] = args[0]
        else
          super
      end
    end

    def self.init_methods(*names)
      if names.size > 0
        names.each do |name|
          @@init_methods[name.to_s] = self
        end
      else
        @@init_methods
      end
    end
  end
end
