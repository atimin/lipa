require 'lipa'

describe Lipa::Tree do 
  before :all do
    @tree =  Lipa::Tree.new "lipa" do
      node :group_1 do 
        any_attr "any attr"

        node :obj_1, :attr_1 => 5 do
          attr_2 3
          attr_3 run{attr_1 + attr_2}

          node :obj_2 
          node :obj_3 
        end
      end

      load_from File.dirname(__FILE__) + "/data/part_of_tree.rb"
    end
  end

  it 'should have name "/"' do
    @tree.name.should eql("/")
  end

  it 'should have full_name "/"' do
    @tree.full_name.should eql("/")
  end

  it "should have access any object in trees" do 
    Lipa::Tree["lipa://group_1/obj_1"].should eql(@tree["group_1/obj_1"])
  end

  it 'should load description from files' do
    @tree.external_node.msg.should eql("Hello!")
  end

  it 'should support absolute path for access to object' do
    @tree["/group_1/obj_1"].should eql(@tree["group_1/obj_1"])
  end

  it 'should support root access' do
    @tree[""].should eql(@tree)
  end

end

