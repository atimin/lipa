$:.unshift File.join(File.dirname(__FILE__),'../lib')
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

#Access
puts Lipa::Tree["tree://branch/leaf_green"].color
#or
puts tree["branch/leaf_yelow"].color
#or
puts tree.red_leaf.color
