$:.unshift File.join(File.dirname(__FILE__),'../lib')
require 'lipa'

un = Lipa::Tree.new :universe do 
  kind :planet do 
    has_live false
    has_water false
    number 0
  end

  node :sun_system do 
    node :mercury, :kind => :planet do 
      number 1
      radius 46_001_210 
    end

    node :venus, :kind => :planet do 
      number 2
      radius 107_476_259
    end

    node :earth, :kind => :planet do 
      number 3
      radius 147_098_074
      has_live true
      has_water true

      node :moon, :radius => 363_104
    end

  end
end


puts un["sun_system/earth"].number
puts un["sun_system/earth"].radius
puts un["sun_system/earth"].has_live
puts un["sun_system/earth"].has_water
puts un["sun_system/earth/moon"].radius