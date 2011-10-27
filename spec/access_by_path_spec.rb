require 'lipa'

describe "access to object by path in Unix style" do
  before :all do
    @tree =  Lipa::Tree.new "lipa" do
      node :obj_1 do 
        node :obj_2 do
          node :obj_3 do 
            node :obj_4
          end
        end
      end
    end

    @node = @tree.obj_1.obj_2
  end

  it 'should have access by relative path' do
    @node["obj_3/obj_4"].should eql(@tree.obj_1.obj_2.obj_3.obj_4)
  end

  it 'should have access by parent path with "./"' do
    @node["./obj_3/obj_4"].should eql(@tree.obj_1.obj_2.obj_3.obj_4)
  end

  it 'should have access to parent by  "../"' do
    @node[".."].should eql(@tree.obj_1)
  end

  it 'should have access by "../obj_2/obj_3"' do 
    @node["../obj_2/obj_3"].should eql(@tree.obj_1.obj_2.obj_3)
  end

  it 'should have access by absolute path' do
    @node["/obj_1/obj_2/obj_3"].should eql(@tree.obj_1.obj_2.obj_3)
  end
end
