require 'lipa'

describe Lipa::Bunch do
  before :all do
    @tree =  Lipa::Tree.new "lipa" do
      with :attr_1 => 100, :attr_2 => "attr_2" do 
        node :obj_4
        node :obj_5
        node :obj_6, :attr_1 => 200, :attr_2 => ""
      end
    end

    @node = @tree["group_1/obj_1"]
  end

  it 'should create some object with any attributes' do 
    @tree["obj_4"].attr_1.should eql(100)
    @tree["obj_5"].attr_1.should eql(100)
    @tree["obj_6"].attr_1.should eql(200)

    @tree["obj_4"].attr_2.should eql("attr_2")
    @tree["obj_5"].attr_2.should eql("attr_2")
    @tree["obj_6"].attr_2.should eql("")
  end
  
  it 'should have "with" initial method' do
    t = Lipa::Tree.new("1") do
      with :attr_1 => 999 do 
        node :obj_1
      end
    end
    t["obj_1"].attr_1.should eql(999)
  end

  it 'should work with kinds' do
    t = Lipa::Tree.new("1") do
      kind :some_kind, :for => :node

      with :attr_1 => 999 do 
        some_kind :obj_1
      end
    end
    t["obj_1"].attr_1.should eql(999)
  end


end
