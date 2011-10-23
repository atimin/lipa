require 'lipa'

describe Lipa::Tree do 
  before :all do
    @tree =  Lipa::Tree.new "lipa" do
      node :group_1 do 
        any_attr "any attr"

        node :obj_1, :attr_1 => 5 do
          attr_2 3
          attr_3 Proc.new{attr_1 + attr_2}

          node :obj_2 
          node :obj_3 
        end
      end
    end
  end

  it "should have access any object in trees" do 
    Lipa::Tree["lipa://group_1/obj_1"].should eql(@tree["group_1/obj_1"])
  end
end

