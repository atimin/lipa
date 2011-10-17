require "lipa"

TREE ||= Lipa::Tree.new "lipa" do
    node :group_1 do 
      any_attr "any attr"

      node :obj_1, :attr_1 => 5 do
        attr_2 3
        attr_3 lambda{attr_1 + attr_2}

        node :obj_2 
        node :obj_3 
      end
    end

    with :attr_1 => 100, :attr_2 => "attr_2" do 
      node :obj_4
      node :obj_5
      node :obj_6, :attr_1 => 200, :attr_2 => ""
    end

    # Template
    kind :kind_group do 
      node :obj_x
      node :obj_y do
        attr_1 "from_kind"
      end
    end

    node :group_3, :kind => :kind_group do 
      node :obj_x do 
        attr_1 "from_instance"
      end
    end
    #or
    kind :folder, :for => :node
    kind :file, :for => :node do 
      size 1024
      ext "jpg"
    end

    folder :folder_1 do 
      file :some_file, :ext => "txt"
    end
  end

def tree
  TREE
end
