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
  # Implementation of group description
  # 
  # @example
  #   tree = Lipa::Tree.new :tree do 
  #     bunch :param_1 => "some_param" do
  #       leaf :obj_1
  #       leaf :obj_2
  #     end
  #   end
  #
  #   tree["obj_1"].param_1 #=> "some_param"
  #   tree["obj_2"].param_1 #=> "some_param"
  class Bunch 
    def initialize(parent, attrs = {}, &block)
      @attrs = attrs
      @parent = parent

      instance_eval &block if block_given?
    end

    def method_missing(name, *args, &block)
      args[1] ||= {}
      args[1] = @attrs.merge(args[1])
      unless Node.add_node(name, @parent, *args, &block)
        super
      end
    end
  end
end
