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
  # Base object for all nested object of tree
  # It supports initialization 
  # attributes by constant, variable or Proc object
  #
  # @example
  #   tree = Lipa::Tree.new :tree do 
  #     node :object, :param_1 => 4 do
  #       param_2 "some_param"
  #       param_3 Proc.new{1+param_3}
  #     end
  #   end
  #   tree.object.param_1 #=> 4
  #   tree.object.param_2 #=> "some_param"
  #   tree.object.param_3 #=> 5
  class Node 
    attr_accessor :attrs
    @@init_methods = {:node => self}
    @@kinds = {}

    def initialize(name, attrs = {}, &block)
      @attrs = {} 

      #init attrs from template
      if attrs[:kind]
        kind = @@kinds[attrs[:kind].to_sym]
        @attrs.merge! kind.attrs if kind
      end

      @attrs.merge! attrs
      @attrs[:name] = name.to_s
      instance_eval &block if block_given?
    end

    def method_missing(name, *args, &block)
      unless Node.add_node(name, self, *args, &block)
        case args.size
          when 0
            child = @attrs[:children][name]
            return child if child

            val = @attrs[name]
            if val.class == Proc
              instance_eval &(val)
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
    end

    # Accessor for node by path
    # @param [String] path nodes
    # @return [Node] node
    #
    # @example
    #   tree["dir_1/dir_2/searched_obj"] 
    def [](path)
      split_path = path.split("/")   
      obj = @attrs[:children][split_path[0].to_sym]
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
    #   tree = Lipa::Tree.new :tree do 
    #     with :param_1 => "some_param" do
    #       node :obj_1
    #       node :obj_2
    #     end
    #   end
    #
    #   tree.obj_1.param_1 #=> "some_param"
    #   tree.obj_2.param_1 #=> "some_param"
    def with(attrs = {}, &block)
      if block_given?
        Lipa::Bunch.new(self, attrs, &block)
      end
    end

    # Accesor for methods for initialization
    # node objects
    # 
    # @param names of initial methods
    #
    # @example
    #   class Folder < Lipa::Node
    #     init_methods :folder
    #   end
    #
    #   fls = Lipa::Tree.new :folders do
    #     folder :folder_1 do
    #       param_1 "some_param
    #     end
    #   end
    #
    #   fls.folder_1.class #=> Folder
    def self.init_methods(*names)
      if names.size > 0
        names.each do |name|
          @@init_methods[name.to_sym] = self
        end
      else
        @@init_methods
      end
    end

    # Making children node
    #
    # @param [String] name of initial method or kind
    # @param [Node] parent node
    # @param args of node
    # @param block for node
    def self.add_node(name, parent, *args, &block)
      parent.attrs[:children] ||= {} 
       
      # Init from kind
      kind = @@kinds[name]
      if kind and kind.for
        init_class = @@init_methods[kind.for] 
        args[1] ||= {}
        args[1][:kind] = kind.name
      else
        #from init methods
        init_class = @@init_methods[name]
      end

      if init_class
        args[1] ||= {}
        args[1][:parent] = parent 
        child_name = args[0].to_sym

        existen_child = parent.attrs[:children][child_name]
        args[1] = existen_child.attrs.merge(args[1]) if existen_child
          
        parent.attrs[:children][child_name] = init_class.send(:new, *args, &block )
      else  
        nil
      end
    end
  end
end
