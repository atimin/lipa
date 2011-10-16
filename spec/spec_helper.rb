require "lipa"

TREE ||= Lipa::Tree.new "lipa" do
    branch :group_1 do 
      any_attr "any attr"

      leaf :obj_1, :attr_1 => 5 do
        attr_2 3
        attr_3 lambda{attr_1 + attr_2}
      end

      leaf :obj_2 

      branch :group_2 do
        leaf :obj_3
      end
    end

    bunch :attr_1 => 100, :attr_2 => "attr_2" do 
      leaf :obj_4
      leaf :obj_5
      leaf :obj_6, :attr_1 => 200, :attr_2 => ""
    end

    kind :kind_group do 
      leaf :obj_x
      leaf :obj_y do
        attr_1 "from_kind"
      end
    end

    branch :group_3, :kind => :kind_group do 
      leaf :obj_x do 
        attr_1 "from_instance"
      end
    end
  end

def tree
  TREE
end
