NEXT  Release-1.1.0
----------------------
- Added method Node#refs for access to nodes which are referensing on it

  ```Ruby
    tree = root :tree do
      node :node_1 
      node :node_2 do
        param_1 ref("../node_1")
      end
    end
   
    root.node_1.refs #=> { :node_2 => <Lipa::Node:xxxxx @name = "node_2"> }
  ```

2011-11-05 Release-1.0.0
----------------------
- Added method Node#eval_attrs to access to attrs node with eval

    ```Ruby
    node :some_node d:
      param_1 1
      param_2 run{ param_1 + 2}
    end
    
    node.attrs #=> {:param_1 => 1, :param_2 => Proc}
    node.eval_attrs #=> {:param_1 => 1, :param_2 => 3}
    ```

- Renamed Lipa::Tree -> Lipa::Root and added helper method for initialization

  ```Ruby
    tree = root :tree do
      node :node_1
    end
  ```

- Fixed bug in Lipa::Node. Attributes is working with false values.
- Added :full_name attribute to Lipa::Node
- Attributes :name, :parent, :children, :root, :full_name, :kind are instance variables
- Fixed bug for calls: `node[""] #=> self` and `node["/"] #=> tree`
- All instances of Lipa::Tree have name an full name equal "/"

2011-10-27 Release-0.3.0
-----------------------
- Added supporting references to other object as attribute ```Node#ref```

  ```Ruby
    node :node_1 
    node :node_2 do
      param_1 ref("../node_1")
    end
  ```

- Added access to object by path in Unix style for ```Node#[]```

  ```Ruby
    node["dir_1/dir_2/searched_obj"] 
    node["searched_obj"] 
    node["./searched_obj"] 
    node["../dir_2/searched_obj"] 
  ```

- Added ```Node#run``` for wraping code

  ``` Ruby
    node :some_node do
      some_param run{ rand(10) }
    end
  ```
- Added load description of trees from external files ```Tree#load_from```:
  
  ```Ruby
    Lipa::Tree.new "lipa" do
      load_from File.dirname(__FILE__) + "/data/part_of_tree.rb"
    end
  ```

- Kind for node is default:

  ```Ruby
  t = Lipa::Tree.new("1") do
    kind :some_kind

    some_kind :obj_1
  end
  ```
- Added ```tree``` attribute for node
- Deleted deprecated classes ```Lipa::Leaf``` and ```Lipa::Branch```
- Deleted deprecated methods ```Node#leafs``` and ```Node#branch```

2011-10-20 Release-0.2.2
-------------------------

- Fixed issue [#1](https://github.com/flipback/lipa/issues/1) in template functional. 
  Lambda expressions is not supporting. Use `Proc.new {}` for added calculation in your trees

2011-10-19 Release-0.2.1
------------------------

- Fixed bug in Lipa::Bunch class. Now is working:

  ```Ruby
  t = Lipa::Tree.new("1") do
    kind :some_kind, :for => :node

    with :attr_1 => 999 do 
      some_kind :obj_1
    end
  end
  ```

- Refactoring. Added method Node#init_node for making cnildren nodes

2011-10-17 Release-0.2.0
------------------------
- New clear API with one general class ```Lipa::Node```. Classes ```Lipa::Leaf``` and ```Lipa::Branch``` 
is deprecated and is deleting in release 0.3.0. 

 
  ```Ruby
  node :node_1 do
   node :node_2 do
    param_1 :some_value
   end
  end
  ```

- Added new methods access to nodes;
 
  ```Ruby
  Tree["tree://path/to/obj"]
  tree.path.to.obj
  ```

- Extended template functional. For example, if you set attr ```:for => :node``` in kind
you will use name of kind instead of method ```node``` for subsribtion. [See examples](https://github.com/flipback/lipa/tree/master/examples)
  
  ```Ruby
  kind :planet_system, :for => :node do
    num_planet 0
  end

  kind :planet, :for => :node do 
    has_live false
    has_water false
    number 0
  end

  planet_system :sun_system do 
    planet :mercury do 
      number 1
      radius 46_001_210 
    end

    planet :venus do 
      number 2
      radius 107_476_259
    end

    planet :earth do 
      number 3
      radius 147_098_074
      has_live true
      has_water true

      node :moon, :radius => 363_104
    end
  end
  ```
2011-10-16 Release-0.1.0
------------------------
Initial released!
