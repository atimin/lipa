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
  class Bunch 
    def initialize(branch, attrs = {}, &block)
      @attrs = attrs
      @branch = branch
      @branch.attrs[:leafs] ||= {}

      instance_eval &block if block_given?
    end

    def method_missing(name, *args, &block)
      init_class = Lipa::Leaf.init_methods[name.to_s]
      if init_class and init_class.class == Class
        args[1] ||= {}
        args[1] = @attrs.merge(args[1]) #to save local attrs
        args[1][:branch] = @branch
        @branch.attrs[:leafs][args[0].to_s] = init_class.send(:new, *args, &block )
      else
        super
      end
    end
  end
end
