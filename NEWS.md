2011-10-17 Release-0.2.0
------------------------
- New clear API with one general class Lipa::Node. Classes Lipa::Leaf and Lipa::Branch 
is deprecated and is deleting in release 0.3.0. 

- Added new methods access to nodes;
  * Tree["tree://path/to/obj"]
  * tree.path.to.obj

- Extended template functional. For example, if you set attr :for => :node in kind
you will use name of kind instead of method #node for subsribtion. [See examples](https://github.com/flipback/lipa/tree/master/examples)

2011-10-16 Release-0.1.0
------------------------
Initial released!
