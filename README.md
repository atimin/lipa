Lipa - DSL for description treelike structures in Ruby
=======================================================

Features
------------------------------------------------------
- Dynamic creating treelike structures for Ruby
- Flexible syntax
- Supporting templates and scope initialization

Install
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

  branch :branch do 
    bunch :color => "green",  do 
      leaf :leaf_green
      leaf :leaf_yelow, :color => "yelow"
    end    
  end

  leaf :red_leaf, :kind => :red_leaf
end


puts tree["branch/leaf_green"].color
puts tree["branch/leaf_yelow"].color
puts tree["red_leaf"].color
```

