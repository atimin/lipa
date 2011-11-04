$:.unshift File.join(File.dirname(__FILE__),'../lib')
require "lipa"

store = root :store do 
  kind :category do
    unit_count run{
      count = 0
      children.values.each do |child|  
        case child.kind
        when :unit
          count += child.count
        when :category
          count += child.unit_count
        end 
      end

      count
    }

    total_cost  run{
      cost = 0
      children.values.each do |child|  
        case child.kind
        when :unit
          cost += child.cost * child.count
        when :category
          cost += child.total_cost
        end 
      end

      cost
    }

  end

  kind :unit do
    count 0
    cost 0.0
  end

  category :electorinics do 
    category :video do 
      with :label => "Sony" do
        unit :tv_1 do 
          count       231
          part_number "123-567-a"
          cost         100.0
        end

        unit :tv_2 do 
          count       27
          part_number "123-567-b"
          cost        199.0
        end
      end

      unit :tv_3 do 
        count       98
        part_number "123-567-c"
        cost        299.0
        label       "Samsung"
      end
    end

    category :audio do 
      unit :player_1 do 
        count       193
        part_number "123-567-d"
        cost        99.0
        label       "Apple"
      end
    end
  end
end

puts store.electorinics.video.unit_count
puts store.electorinics.video.total_cost
