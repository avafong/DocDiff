use context essentials2021

include my-gdrive("docdiff-common.arr")
include my-gdrive("docdiff-code.arr")
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# Write your examples and tests in here. These should not be tests of implementation-specific details (e.g., helper functions).

# overlap :: List<String> List<String> -> Number

d1 = [list: "abe", "bog", "cat", "dog"]
d2 = [list: "elf", "fir"]
d3 = [list: "elf", "fir"]
d4 = [list: "a", "b", "c", "d"]
d5 = [list: "b", "c", "b", "b", "e"]
d6 = [list: "z", "q", "x", "b"]
d7 = [list: "this", "fire", "is", "going", "solo", "cat"]
d8 = [list: "this", "fire", "going", "dog"]
d9 = [list: "Abe", "Cat", "Dog", "bog", "xyz"]

check "no overlap, also checks commutative prop. of overlap":
  overlap(d1, d2) is 0
  overlap(d2,d1) is 0
  overlap(d1, d6) is 0
  overlap(d1, d6) is 0
end
check "all overlap":
  overlap(d2, d3) is-roughly 1
  overlap(d3,d2) is-roughly 1
end
check "some overlap":
  overlap(d7, d8) is-roughly 1/2
end
check "repeated elements in some lists":
  overlap(d4, d5) is-roughly 4/11
  overlap(d5, d4) is-roughly 4/11
  overlap(d5,d6) is-roughly 3/11
end
check "master-vector list ends up having length = 1":
  l1 = [list: "a", "a"]
  l2 = [list: "a", "a", "a"]
  overlap(l1, l2) is 2/3
end
check "making sure the program treats capitalized versions as identical":
  l1 = [list: "Cat", "Babe", "OK"]
  l2 = [list: "baby", "ok", "cat", "say"]
  l3 = [list: "babe", "cat", "ok"]
  overlap(l1, l3) is-roughly 1
  overlap(l1, l2) is-roughly 1/2
end
check "quartermaster test":
  1 satisfies overlap-out-ok 
  0 satisfies overlap-out-ok
  1/3 satisfies overlap-out-ok
  {d1;d2} satisfies overlap-in-ok 
  {d2;d3} satisfies overlap-in-ok 
  {d1;d2} satisfies overlap-in-ok 
end
