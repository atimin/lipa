Next Release-0.3.0
-----------------------
- Deleted deprecated classes ```Lipa::Leaf``` and ```Lipa::Branch```
- Deleted deprecated methods ```Node#leafs``` and ```Node#branch```

2011-10-20 Release-0.2.2

- Fixed issue [#1](https://github.com/flipback/lipa/issues/1) in template functional. 
  Lambda expressions is not supporting. Use `Proc.new {}` for added calculation in your trees

2011-10-19 Release-0.2.1

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
