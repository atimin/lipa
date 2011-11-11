Lipa [![Build Status](https://secure.travis-ci.org/flipback/lipa.png)](http://travis-ci.org/flipback/lipa)
=======================================================
Lipa - DSL for description treelike structures in Ruby

Installation
-----------------------------------------------------
`gem install lipa`

Getting started
------------------------------------------------------
Description of simple treelike structure

    required 'lipa'
    tree = root :tree do
      node :node_1 do
        node :node_2 do
          param_1 1     #attribute of node_2
        end
      end
    end

Access to node by path in Unix style

    tree["/node_1/node_2"].param_1 #=> 1

or in OOP style

     tree.node_1.node_2.param_1 #=> 1

## Access to objects
Source tree

    tree = root :tree do
      node :node_1 do
        node :node_2 do
          node :node_3 do
            param_1 0
          end
        end
      end
    end

### Access to node
OOP style access

    tree.node_1.node_2 #=> node_2

For access to any object of tree it's using `[]` in tree or node object:

    n = tree["node_1/node_2"] #=> node_2
    # relative path
    n["node_3"] #=> node_3
    n["./node_3"] #=> node_3
    # absolute path
    n["/node_1/node_2/node_3"] #=> node_3
    # by parent node
    n["../node_2/node_3"] #=> node_3

Helpers for access

    n = tree.node_1.node_2
    n.root #=> tree
    n.parent #=> node_1
    n.children[:node_2] #=> node_2

### Access to attributes
Lipa provide two methods for access to attributes: by field

    tree["/node_1/node_2/node_3"].param_1 #=> 1

or by hash of attributes

    tree["/node_1/node_2/node_3"].attrs[:param_1] #=> 1
    # or
    tree["/node_1/node_2/node_3"].eval_attrs[:param_1] #=> 1

**NOTE:** Use `Node#eval_attrs` if you have Proc attrs. 
This method copy attrs and call everything proc attrs. 
If you want fast access to attributes when use `Node#attrs` method.

### Several trees
You can configure many trees and get access by `Root::[]method`

    root :tree_1 do
      node :node_1
    end

    root :tree_2 do
      node :node_1
    end

    Lipa::Root["tree_1://node_1"] #=> node_1 of tree_1
    Lipa::Root["tree_2://node_1"] #=> node_1 of tree_2

## Attributes
Attributes is being initialized as hash parameter or\and as method 
in block of node and it will be any type

    root :tree do
      # Hash style initializations
      node :some_node, :attr_1 => 0, :attrs_2 => "some_string"
      # Hash style initializations
      node :some_node do
        attr_1 0
        attr_2 "some_string"
      end
      # Mixing style
      node :some_node, :attr_1 => 0 do
        attr_2 "some_string"
      end
    end

You can initialize attribute as block of code which is running 
when you access to it. Use `Node#run` method for it:

    tree = root :tree do
      node :some_node do
        attr_1 run{ rand(10) }
      end
    end

    tree.somde_node.attr_1 #=> 3
    tree.somde_node.attr_1 #=> 7
    tree.somde_node.attr_1 #=> 2

Also you can initialize attribute as reference on other object

    tree = root :tree do
      node :node_1 
      node :node_2 do
        param_1 ref("../node_1")
      end
    end

    tree.node_2.param_1 #=> node_1
    tree.node_1.refs #=> { :node_2 => node_2 }

## Templates
Best way to configure of tree is using templates. 
You can create template by `Root#kind` method with defaults attributes 
as node and make its instances. For example:

    tree = root :tree do
      # template
      kind :object do
        param_1 0
        param_2 "string_of_param"
      end
             
      # instances
      object :obj_1 
      object :obj_2
    end

    tree.obj_1.param_1 #=> 0
    tree.obj_2.param_1 #=> 0
    tree.obj_1.kind #=> :object
    tree.obj_2.kind #=> :object

Default attributes from template can be overridden in instance:

    tree = root :tree do
    kind :object do
      param_1 0
      param_2 "string_of_param"
    end

    object :obj_1 
      object :obj_2 do
          param_1 999
      end
    end

    tree.obj_1.param_1 #=> 0
    tree.obj_2.param_1 #=> 999

Also Lipa provide template for nesting nodes:

    tree = root :tree do
      kind :object do
        node :child do
          param_1 0
        end
      end

      object :obj_1 
    end

    tree.obj_1.child.param_1 #=> 0

## Misc

### Scope initialization of attributes

You can set many attributes for several nodes by method `Node#with`:

    tree = root :tree do
      with :param_1 => 0, :param_2 => "..." do
        node :obj_1 
        node :obj_2
        node :obj_3
      end
    end

    tree.obj_1.param_1 #=> 0
    tree.obj_2.param_1 #=> 0
    tree.obj_3.param_1 #=> 0

### Build tree from several files
If description of tree is very big, you will separate into several files 
and load it:

    tree = root :tree do
      load_from "path/to/file1"
      load_from "path/to/file2"
      load_from "path/to/file3"
    end

Reference
----------------------------------
Home page: http://lipa.flipback.net

Web access to Lipa https://github.com/flipback/lipa-web
