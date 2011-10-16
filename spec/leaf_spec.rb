require File.dirname(__FILE__) + "/spec_helper"

describe Lipa::Leaf do
  before :each do
    @obj = tree["group_1/obj_1"]
  end

  it 'should have name' do
    @obj.name.should eql("obj_1")
  end

  it 'should have branch (parent)' do
    @obj.branch.should eql(tree["group_1"])
  end

  it 'should have descripted attr_1 eql 5' do
    @obj.attr_1.should eql(5)
  end

  it 'should have descripted attr_2 eql 4' do
    @obj.attr_2.should eql(3)
  end

  it 'should have descripted attr_3 eql sum of attr_1 and attr_2' do
    @obj.attr_3.should eql(8)
  end

  it 'should support write access for attrs' do
    @obj.attr_1 = 8
    @obj.attr_1.should eql(8)
  end

  it 'should have hash access for attrs' do
    @obj.attrs[:attr_1].should eql(8)
    @obj.attrs[:attr_1] = 9
    @obj.attrs[:attr_1].should eql(9)
  end

  it 'should have "object" initial method' do
    t = Lipa::Tree.new(nil) { object :obj }
    t["obj"].class.should eql(Lipa::Leaf)
  end
end
