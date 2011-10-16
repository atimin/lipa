require File.dirname(__FILE__) + "/spec_helper"

describe Lipa::Branch do
  before :each do
    @grp = tree["group_1"]
  end

  it 'should have leafs (children)' do
    @grp.leafs["obj_1"].should eql(tree["group_1/obj_1"])
    @grp.leafs["obj_2"].should eql(tree["group_1/obj_2"])
  end

  it 'should have [] for access entry by path' do
    @grp["group_2/obj_3"].should eql(tree["group_1/group_2/obj_3"])
  end

  it 'should have any attrs also as leaf (Lipa::Leaf)' do
    @grp.any_attr.should eql("any attr")
  end

  it 'should have "dir" initial method' do
    t = Lipa::Tree.new(nil) { dir :dir_1 }
    t["dir_1"].class.should eql(Lipa::Branch)
  end

  it 'should have "object" initial method' do
    t = Lipa::Tree.new(nil) { group :group_1 }
    t["group_1"].class.should eql(Lipa::Branch)
  end
end
