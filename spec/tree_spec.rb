require File.dirname(__FILE__) + "/spec_helper"

describe Lipa::Tree do 
  it "should have access any object in trees" do 
    Lipa::Tree["lipa://group_1/obj_1"].should eql(tree["group_1/obj_1"])
  end
end

