require File.dirname(__FILE__) + "/spec_helper"

describe Lipa::Node do
  before :each do
    @node = tree["group_1/obj_1"]
  end

  it 'should have name' do
    @node.name.should eql("obj_1")
  end

  it 'should have parent' do
    @node.parent.should eql(tree["group_1"])
  end

  it 'should have descripted attr_1 eql 5' do
    @node.attr_1.should eql(5)
  end

  it 'should have descripted attr_2 eql 4' do
    @node.attr_2.should eql(3)
  end

  it 'should have descripted attr_3 eql sum of attr_1 and attr_2' do
    @node.attr_3.should eql(8)
  end

  it 'should support write access for attrs' do
    @node.attr_1 = 8
    @node.attr_1.should eql(8)
  end

  it 'should have hash access for attrs' do
    @node.attrs[:attr_1].should eql(8)
    @node.attrs[:attr_1] = 9
    @node.attrs[:attr_1].should eql(9)
  end

  it 'should have children' do
    @node.children[:obj_2].should eql(tree["group_1/obj_1/obj_2"])
    @node.children[:obj_3].should eql(tree["group_1/obj_1/obj_3"])
  end

  it 'should have [] for access entry by path' do
    @node["obj_3"].should eql(tree["group_1/obj_1/obj_3"])
  end

  it 'should access for children by .' do
    @node.obj_3.should eql(tree["group_1/obj_1/obj_3"])
  end
end
