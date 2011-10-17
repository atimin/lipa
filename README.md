Lipa - DSL for description treelike structures in Ruby
=======================================================

Features
------------------------------------------------------
- Dynamic creating treelike structures for Ruby
- Flexible syntax
- Supporting templates and scope initialization
- Supporting Proc object as attributes

Installation
-----------------------------------------------------
`gem install lipa`

Example
------------------------------------------------------
```Ruby
require 'lipa'

tree = Lipa::Tree.new :tree do 
  kind :red_leaf do 
    color "red"
  end

  node :branch do 
    with :color => "green",  do 
      node :leaf_green
      node :leaf_yelow, :color => "yelow"
    end    
  end

  node :red_leaf, :kind => :red_leaf
end


puts tree["branch/leaf_green"].color
puts tree["branch/leaf_yelow"].color
puts tree["red_leaf"].color
```

