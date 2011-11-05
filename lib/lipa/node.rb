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
  # attributes by constant, variable or code
  #
  # @example
  #   tree = root :tree do 
  #     node :object, :param_1 => 4 do
  #       param_2 "some_param"
  #       param_3 run{1+param_3}
  #     end
  #   end
  #   tree.object.param_1 #=> 4
  #   tree.object.param_2 #=> "some_param"
  #   tree.object.param_3 #=> 5
  class Node 
    attr_accessor :attrs, :name, :children, :root, :parent, :full_name, :kind
    @@init_methods = {:node => self}

    def initialize(name, attrs = {}, &block)
      @name = name.to_s
      @children = {}
      @parent = attrs.delete(:parent)
      @root = attrs.delete(:root)
      @full_name = attrs.delete(:full_name)
      @kind = attrs.delete(:kind)
      @attrs = attrs

      instance_eval &block if block_given?
    end

    def method_missing(name, *args, &block)
      unless Node.add_node(name, self, *args, &block)
        case args.size
          when 0
            child = children[name]
            return child if child

            val = @attrs[name]

            super if val.nil? #Raise MethodError if don't have it

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

    # Copy attributes with eval
    #
    # @retun [Hash] hash
    #
    # @example
    #   node :some_node d:
    #     param_1 1
    #     param_2 run{ param_1 + 2}
    #   end
    #
    #   node.attrs #=> {:param_1 => 1, :param_2 => Proc}
    #   node.eval_attrs #=> {:param_1 => 1, :param_2 => 3}
    def eval_attrs
      result = {}
      @attrs.each_pair do |k,v|
        result[k.to_sym] = instance_eval(k.to_s)
      end
      result
    end

    # Accessor for node by path in Unix style
    # @param [String] path nodes
    # @return [Node] node
    #
    # @example
    #   dir_2["dir_1/dir_2/searched_obj"] 
    #   dir_2["searched_obj"] 
    #   dir_2["./searched_obj"] 
    #   dir_2["../dir_2/searched_obj"] 
    def [](path)
      first, *rest_path = path.split("/")  
      obj = case first
      when nil
        if path == "/"
          root
        elsif path == ""
          self
        end
      when ""
        root
      when ".."
        parent
      when "."
        self
      else
        children[first.to_sym]
      end

      return nil if obj.nil?
      if rest_path.size > 0
        obj[rest_path.join("/")]
      else
        obj
      end
    end

    # Initial method for group description
    # 
    # @example
    #   tree = root :tree do 
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

    # Wraping code in attribute
    #
    # @param block of code
    #
    # @example
    #   root :tree do
    #     param_1 10
    #     param_2 run{ param_1 * 10 }
    #   end
    def run(&block)
      block
    end

    # Reference to othe object
    # @param path in Unix style
    #
    # @example
    #
    #   node :node_1 
    #   node :node_2 do
    #     param_1 ref("../node_1")
    #   end
    def ref(path) 
     Proc.new { self[path] }
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
    #   fls = root :folders do
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
      # OPTIMIZE: This code looks bad
      # Init from kind
      args[1] ||= {}
      attrs = {}

      k = parent.root.kinds[name]
      if k and k.for
        init_class = @@init_methods[k.for]
      else
        #from init methods
        init_class = @@init_methods[name]
      end

      if init_class
        # Init general attributes
        attrs[:parent] = parent
        attrs[:root] = parent.root
        fn = parent.full_name == "/" ? "" : parent.full_name
        attrs[:full_name] =  fn  + "/" + args[0].to_s

        node_name = args[0].to_sym
        children = parent.children
        if k
          attrs.merge! k.attrs
          attrs[:kind] = k.name
          #Node is descripted in kind
          existen_child = parent.children[node_name]
          attrs = existen_child.attrs.merge(attrs) if existen_child
          #Init from kind
          children[node_name] = init_class.send(:new, node_name, attrs, &k.block)
          #Local modification
          children[node_name].attrs.merge!(args[1])
          children[node_name].instance_exec(&block) if block_given?
        else
          children[node_name] = init_class.send(:new, node_name, attrs.merge(args[1]), &block )
        end
        true
      else  
        nil
      end
    end
  end
end
