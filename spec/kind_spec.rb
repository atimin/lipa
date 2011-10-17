require File.dirname(__FILE__) + "/spec_helper"

describe Lipa::Kind do
  it 'should create brunch from template' do 
    tree["group_3/obj_y"].attr_1.should eql("from_kind")
  end

  it 'should support local changing in instances' do
    tree["group_3/obj_x"].attr_1.should eql("from_instance")
  end

  it 'should create init method with name template' do
    tree.folder_1.some_file.size.should eql(1024) 
    tree.folder_1.some_file.ext.should eql("txt") 
  end
end
