require 'lipa' 

describe Lipa::Kind do
  before :all  do
    @tree = Lipa::Tree.new :tree do 
      # Set #1 
      kind :object, :for => :node
      kind :group, :for => :node do 
        object :obj_x do
          attr_0 "from_kind"
          attr_1 "from_kind"
          attr_3 Proc.new{ attr_2 * 2}
        end
      end

      group :group_1 do 
        object :obj_x do 
          attr_1 "from_instance"
          attr_2 2
        end
      end
      # Set #2
      kind :folder
      kind :file do 
        size 1024
        ext "jpg"
      end

      folder :folder_1 do 
        file :some_file, :ext => "txt"
      end
    end    
  end

  it 'should create brunch from template' do 
    @tree.group_1.obj_x.attr_0.should eql("from_kind")
  end

  it 'should support local changing in instances' do
    @tree.group_1.obj_x.attr_1.should eql("from_instance")
  end

  it 'should have lazy calculation' do 
    @tree.group_1.obj_x.attr_2.should eql(2)
    @tree.group_1.obj_x.attr_3.should eql(4)
  end

  it 'should create init method with name template' do
    @tree.folder_1.some_file.size.should eql(1024) 
    @tree.folder_1.some_file.ext.should eql("txt") 
  end

  it 'should create node with your name' do
    @tree.folder_1.name.should eql("folder_1")
  end

end
