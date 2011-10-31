require 'lipa'

describe Lipa::Node do
  before :all do
    @tree =  Lipa::Tree.new "lipa" do
      node :group_1 do 
        any_attr "any attr"

        node :obj_1, :attr_1 => 5 do
          attr_2 3
          attr_3 run{attr_1 + attr_2}
          attr_4 ref("/other_object")

          node :obj_2 
          node :obj_3 
        end
      end

      node :other_object do 
        bool_attr false
      end

      kind :some_kind do
        param_1 "something"
      end

      some_kind :obj_x do 
        some_kind :obj_y1 do 
          some_kind :obj_z1
          some_kind :obj_z2
        end

        some_kind :obj_y2 do 
          some_kind :obj_z3
        end
      end
    end

    @node = @tree["group_1/obj_1"]
  end


  it 'should have descripted attr_1 eql 5' do
    @node.attr_1.should eql(5)
  end

  it 'should have descripted attr_2 eql 4' do
    @node.attr_2.should eql(3)
  end

  it 'should have descripted attr_3 eql sum of attr_1 and attr_2' do
    @node.attr_3.should eql(8)
    @node.attr_2 = 10
    @node.attr_3.should eql(15)
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

  it 'should have [] for access entry by path' do
    @node["obj_3"].should eql(@tree["group_1/obj_1/obj_3"])
  end

  it 'should not have bug in tree of kind objects' do
    @tree.obj_x.obj_y1.children.keys.should =~ [:obj_z1, :obj_z2]
    @tree.obj_x.children.keys.should =~ [:obj_y1, :obj_y2]
    @tree.obj_x.obj_y2.obj_z3.children.keys.should =~ []
  end

  it 'should have access other object by reference' do
    @node.attr_4.should eql(@tree.other_object)
  end

  it 'should have attrs with false ' do
    @tree['other_object'].bool_attr.should be_false
  end

end
