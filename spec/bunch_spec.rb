require File.dirname(__FILE__) + "/spec_helper"

describe Lipa::Bunch do
  it 'should create some object with any attributes' do 
    tree["obj_4"].attr_1.should eql(100)
    tree["obj_5"].attr_1.should eql(100)
    tree["obj_6"].attr_1.should eql(200)

    tree["obj_4"].attr_2.should eql("attr_2")
    tree["obj_5"].attr_2.should eql("attr_2")
    tree["obj_6"].attr_2.should eql("")
  end
  
  it 'should have "with" initial method' do
    t = Lipa::Tree.new("1") do
      with :attr_1 => 999 do 
        leaf :obj_1
      end
    end
    t["obj_1"].attr_1.should eql(999)
  end
end
