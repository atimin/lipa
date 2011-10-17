Future Release-0.2.0
------------------------
- New clear API by one class Lipa::Node. Classes Lipa::Leaf and Lipa::Branch 
is depricated and is deleting in release 0.3.0. 
  ```Ruby
    node :branch do 
      with :color => "green",  do 
        node :leaf_green
        node :leaf_yelow, :color => "yelow"
      end    
    end

- Added new method access to nodes:
  ```Ruby
    puts Lipa::Tree["tree://branch/leaf_green"].color
    #or
    puts tree["branch/leaf_yelow"].color
    #or
    puts tree.red_leaf.color
  ```

2011-10-16 Release-0.1.0
------------------------
Initial relesed!
