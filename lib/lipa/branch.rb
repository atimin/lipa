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
  # Implemenation of branch (conteiner) for description
  #  
  # @example
  #
  # tree = Lipa::Tree.new :tree do 
  #   branch :group_1 do
  #     leaf :obj_1, :param_1 => "some_param"
  #   end
  # end
  # tree["group_1/obj_1"].param_1 #=> "some_param"
  #
  # alias #branch is #group, #dir

  class Branch < Leaf
    init_methods :branch, :dir, :group

    def method_missing(name, *args, &block)
      @attrs[:leafs] ||= {} 
      init_class = @@init_methods[name.to_s]
      if init_class
        args[1] ||= {}
        args[1][:branch] = self
        @attrs[:leafs][args[0].to_s] = init_class.send(:new, *args, &block )
      else
        super
      end
    end

    # Accessor for entry by path
    # @param [String] path to entry
    # @return entry
    #
    # @example
    # tree["dir_1/dir_2/searched_obj"] 
    def [](path)
      split_path = path.split("/")   
      obj = @attrs[:leafs][split_path[0]]
      if obj
        if split_path.size > 1
          obj[split_path[1..-1].join("/")]
        else
          obj
        end
      end
    end

    # Initial method for group description
    # 
    # @example
    # tree = Lipa::Tree.new :tree do 
    #   bunch :param_1 => "some_param" do
    #     leaf :obj_1
    #     leaf :obj_2
    #   end
    # end
    #
    # tree["obj_1"].param_1 #=> "some_param"
    # tree["obj_2"].param_1 #=> "some_param"
    def bunch(attrs = {}, &block)
      if block_given?
        Lipa::Bunch.new(self, attrs, &block)
      end
    end

    alias_method :with, :bunch
  end
end
