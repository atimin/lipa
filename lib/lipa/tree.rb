=begin
Lipa - DSL for description treelike structures in Ruby

Copyright (c) 2011 Aleksey Timin

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

module Lipa 
  # Implementaion of root of description
  # @example
  #
  #   tree = Lipa::Tree.new :tree do 
  #     leaf :object do
  #       param_1 "some_param"
  #       param_2 lambda{1+2}
  #     end
  #   end
  #
  #   tree["object"].param_1 #=> "some_param"
  #   tree["object"].param_2 #=> 3 
  class Tree < Node
    attr_reader :kinds

    # Initialize of kind
    # @see Lipa::Kind
    #
    # @example
    #
    # kind :some_kind do
    #   param1 "some_param"
    # end
    #
    # leaf :some_instance, :kind => :some_kind 
    def kind(name, attrs = {}, &block)
      if block_given?
        @@kinds ||= {}
        @@kinds[name.to_sym] = Lipa::Kind.new(name, attrs, &block)
      end
    end

    alias_method :template, :kind
  end
end
