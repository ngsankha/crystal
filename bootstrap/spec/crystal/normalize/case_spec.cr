#!/usr/bin/env bin/crystal -run
require "../../spec_helper"

describe "Normalize: case" do
  it "normalizes case with call" do
    assert_normalize "case x; when 1; 'b'; when 2; 'c'; else; 'd'; end", "#temp_1 = x()\nif 1 === #temp_1\n  'b'\nelse\n  if 2 === #temp_1\n    'c'\n  else\n    'd'\n  end\nend"
  end

  it "normalizes case with var in cond" do
    assert_normalize "x = 1; case x; when 1; 'b'; end", "x = 1\nif 1 === x\n  'b'\nend"
  end

  it "normalizes case with Ident to is_a?" do
    assert_normalize "x = 1; case x; when Foo; 'b'; end", "x = 1\nif x.is_a?(Foo)\n  'b'\nend"
  end

  it "normalizes case with many expressions in when" do
    assert_normalize "x = 1; case x; when 1, 2; 'b'; end", "x = 1\nif 1 === x or 2 === x\n  'b'\nend"
  end
end
