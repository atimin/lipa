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

    require 'lipa'

    tree = Lipa::Tree.new :tree do 
      kind :red, :for => :node do 
        color "red"
      end

      node :branch do 
        with :color => "green",  do 
          node :leaf_green
          node :leaf_yelow, :color => "yelow"
        end    
      end

      red :red_leaf
    end

    #Datra access
    puts Lipa::Tree["tree://branch/leaf_green"].color
    #or
    puts tree["branch/leaf_yelow"].color
    #or
    puts tree.red_leaf.color

Reference
----------------------------------
Home page: http://lipa.flipback.net
