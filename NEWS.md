2011-10-17 Release-0.2.0
------------------------
- New clear API with one general class Lipa::Node. Classes Lipa::Leaf and Lipa::Branch 
is deprecated and is deleting in release 0.3.0. 

    node :branch do 
      with :color => "green",  do 
        node :leaf_green
        node :leaf_yelow, :color => "yelow"
      end    
    end

- Added new methods access to nodes:

    puts Lipa::Tree["tree://branch/leaf_green"].color
    #or
    puts tree["branch/leaf_yelow"].color
    #or
    puts tree.red_leaf.color

- Extended template functional:

  kind :planet, :for => :node do 
    has_live false
    has_water false
    number 0
  end

  planet :venus do 
    number 2
    radius 107_476_259
  end

2011-10-16 Release-0.1.0
------------------------
Initial released!
