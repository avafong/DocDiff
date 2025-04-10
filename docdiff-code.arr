use context essentials2021

provide: overlap end

include my-gdrive("docdiff-common.arr")
import gdrive-js("docdiff_qtm-validation.js", "11H5gJQtW9TJaiFkWw51fR4_oIibmLr7X") as Validation
provide from Validation: overlap-in-ok, overlap-out-ok end
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions) in this file.


#make sure to update this file with the testing_doc diff file stuff. 
import lists as L

fun overlap(doc1 :: List<String>, doc2 :: List<String>) -> Number:
  doc: "computes the overlap of two lists of strings and returns a number. Assumes that the inputted lists are not empty"
  overlap-operation(
    vectorize(make-set(doc1, doc2), map(string-to-lower, doc1)),
    vectorize(make-set(doc1, doc2), map(string-to-lower, doc2)))
end

check:
  d1 = [list: "abe", "bog", "cat", "dog"]
  d2 = [list: "elf", "fir"]
  d3 = [list: "elf", "fir"]
  d4 = [list: "a", "b", "c", "d"]
  d5 = [list: "b", "c", "b", "b", "e"]
  d6 = [list: "z", "q", "x", "b"]
  d7 = [list: "this", "fire", "is", "going", "solo", "cat"]
  d8 = [list: "Abe", "Cat", "Dog", "bog", "xyz"]
  make-set(d1, d8) is [list: "abe", "bog", "cat", "dog", "xyz"]
  make-set(d2, d3) is [list: "elf", "fir"]
  make-set(d4, d5) is [list: "a", "b", "c", "d", "e"]
  make-set(d6, d3) is [list: "b", "elf", "fir", "q", "x", "z"]
end
fun make-set(doc1 :: List<String>, doc2 :: List<String>) -> List<String>:
  doc: "converts all words to lowercase in doc1 and doc2, combines list of strings doc1 and doc2, and then sorts them in lexicographic order and produces a sorted list with no repeats"
  L.sort(unique(L.append(map(string-to-lower, doc1), map(string-to-lower, doc2))))
end

check: 
  unique([list: "hello", "a", "dog", "hello"]) is [list: "hello", "a", "dog"]
  unique([list: "a", "a", "a"]) is [list: "a"]
  unique([list: "a", "b", "c", "c", "a"]) is [list: "a", "b", "c"]
  unique(empty) is empty
end
fun unique(a-list :: List<String>) -> List<String>: 
  doc: "Given a list of strings, produces a list of the same values in the same order excluding duplicates."
  cases (List) a-list:
    | empty => empty
    | link(f, r) =>
      if r.member(f):
        link(f, L.remove(unique(r), f))
      else: link(f, unique(r))
      end 
  end
end

check "general examples":
  vl1 = [list: "a", "b", "c", "d"]
  vl2 = [list: "b", "c", "d"]
  vl3 = [list: "b", "b", "d", "a", "a"]
  vl4 = [list: "b", "c", "d", "a"]
  vectorize(vl1, vl2) is [list: 0, 1, 1, 1]
  vectorize(vl1, vl3) is [list: 2, 2, 0, 1]
  vectorize(vl1, vl4) is [list: 1, 1, 1, 1]
end
check "testing branches with errors":
  vl2 = [list: "b", "c", "d"]
  vectorize(empty, vl2) raises "error: first inputted list cannot be empty"
  vectorize(empty, empty) raises "error: first inputted list cannot be empty"
end
check "testing when list2 is empty, list1 is link":
  vl5 = [list: "b"]
  vl2 = [list: "b", "c", "d"]
  vectorize(vl2, empty) is [list: 0, 0, 0]
  vectorize(vl5, empty) is [list: 0]
end
check "testing when list2 is link, list1 is link":
  vl1 = [list: "a", "b", "c", "d"]
  vl2 = [list: "b", "c", "d"]
  vl5 = [list: "b"]
  vectorize(vl5, vl1) is [list: 1]
  vectorize(vl1, vl2) is [list: 0, 1, 1, 1]
end
fun vectorize(list1 :: List<String>, list2 :: List<String>) -> List<Number>:
  doc: "takes in two lists of strings, and outputs a list of numbers with the length of the first list of strings that represents a vector that indicates how many words in list2 are in list1. Assume that list1 cannot be empty and has no repeated strings"
  cases (List) list1:
    | empty => 
      cases (List) list2:
        | empty => raise("error: first inputted list cannot be empty")
        | link(f2, r2) => raise("error: first inputted list cannot be empty")
      end
    | link(f1, r1) =>
      cases (List) list2:
        | empty => 
          ask: 
            | L.length(list1) == 1 then: link(0, empty)
            | L.length(list1) > 1 then: link(0, vectorize(r1, list2)) 
          end
        | link(f2, r2) => 
          ask: 
            | L.length(list1) == 1 then: link(amount(f1, list2), empty)
            | L.length(list1) > 1 then: link(amount(f1, list2), vectorize(r1, list2))
          end
      end
  end
end

check:
  l1 = [list: "a", "b", "b", "e"]
  amount("a", l1) is 1
  amount("b", l1) is 2
  amount("e", l1) is 1
  amount("x", l1) is 0
end
fun amount(str :: String, a-list :: List<String>) -> Number:
  doc: "counts the number of times the inputted string appears in the inputted list"
  cases (List) a-list:
    | empty => 0
    | link(f, r) => 
      ask: 
        | f == str then: 1 + amount(str, r)
        | otherwise: 0 + amount(str, r)
      end
  end
end

check:
  l1 = [list: 0, 1, 1]
  l2 = [list: 2, 3, 4]
  l3 = [list: 1]
  overlap-operation(l1, l2) is-roughly 7/29
  overlap-operation(l2, l1) is-roughly 7/29
  overlap-operation(l1, l3) raises "error: inputted lists should be the same length"
end
fun overlap-operation(d1 :: List<Number>, d2 :: List<Number>) -> Number:
  doc: "treats the two inputted lists as vectors and performs the 'overlap-operation' on them; specifically, it performs the dot product on the two 'vectors' and divides by the squared magnitude of the vector with the larger magnitude."
  dot(d1, d2) / num-max(num-sqr(magn(d1)), num-sqr(magn(d2)))
end

check: 
  l1 = [list: 1, 0, 0, 1]
  l2 = [list: 1, 3, 2, 1]
  l3 = [list: 1, 4, 5]
  l4 = [list: 6, 4, 3]
  dot(l1, l2) is 2
  dot(l1, l3) raises "error: inputted lists should be the same length"
  dot(l3, l4) is 37
  dot(empty, empty) is 0
end
fun dot(l1 :: List<Number>, l2 :: List<Number>) -> Number:
  doc: "treats l1 and l2 as vectors and computes the dot product of the two. Assumes that l1 and l2 are the same length."
  cases (List) l1:
    | empty => 
      cases (List) l2:
        | empty => 0
        | link(f2, r2) => raise("error: inputted lists should be the same length")
      end
    | link(f1, r1) =>
      cases (List) l2:
        | empty => raise("error: inputted lists should be the same length")
        | link(f2, r2) =>
          ask: 
            | L.length(l1) == L.length(l2) then: (f1 * f2) + dot(r1, r2)
            | otherwise: raise("error: inputted lists should be the same length")
          end
      end
  end
end

check:
  l1 = [list: 0, 1, 3]
  l2 = empty
  l3 = [list: 1, 1, 1, 1]
  magn(l1) is-roughly num-sqrt(10)
  magn(l2) is 0
  magn(l3) is 2
end
fun magn(lst :: List<Number>) -> Number:
  doc: "treats the list as a vector and computes the magnitude of said vector"
  num-sqrt(dot(lst, lst))
end