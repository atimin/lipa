require 'lipa'

describe Lipa::Node do
  before :all do
    @tree =  root "lipa" do
      node :group_1 do 
        node :obj_1, :attr_1 => 5 do

          node :obj_2 
          node :obj_3 
        end
      end

      kind :some_kind do
        param_1 "something"
      end

      some_kind :obj_x
    end
    @node = @tree["group_1/obj_1"]
  end

  it 'should have name' do
    @node.name.should eql("obj_1")
  end

  it 'should have full_name' do
    @node.full_name.should eql("/group_1/obj_1") 
  end

  it 'should have root' do
    @node.root.should eql(@tree)
  end

  it 'should kind' do
    @tree["obj_x"].kind.should eql(:some_kind)
  end

  it 'should have parent' do
    @node.parent.should eql(@tree["group_1"])
  end

  it 'should have children' do
    @node.children.values.should =~ [@tree["group_1/obj_1/obj_2"], @tree["group_1/obj_1/obj_3"]]
  end

  it 'should access for children by .' do
    @node.obj_3.should eql(@tree["group_1/obj_1/obj_3"])
  end

  it 'should not have attrs indentical withi instance varianles' do
    [:attrs, :name, :children, :tree, :parent, :full_name, :kind].each do |n|
      @node.attrs.include?(n).should be_false 
    end
  end
end
