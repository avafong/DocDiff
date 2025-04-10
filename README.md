# DocDiff
A program that computes the content-overlap of two documents (a list of strings) using a similarity measure that underlies plagiarism checker and search engine systems.

We define the overlap between two documents, represented this way, to be proportional to the dot product of these two document vectors:

overlap(d1,d2)∝d1⋅d2

To obtain a formula, we normalize this dot-product. We will choose a simple method, which is to divide by the squared magnitude of the vector with the larger magnitude:

overlap(d1,d2)=d1⋅d2/max(‖d1‖^2,‖d2‖^2)

where the magnitude of a vector x
, denoted as ‖x‖
, is given by sqrt((x)(x))
. Observe that this means every document will have an overlap of 1 with itself, and any two documents that have no words in common will have overlaps of 0 with each other.

Credit: Project Created for Fall 2024 CSCI 0190 Assignment, Course Taught & Designed by Shriram Krishnamurthi
