import MapReduce
import sys

"""
Word Count Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: document identifier
    # value: document contents
    key = record[1]
    value = record[:]
    mr.emit_intermediate(key,value)

def reducer(key, list_of_values):
    # key: id
    # value: list of occurrence counts
    #for i in range(len(list_of_values)-1):
    for v in list_of_values[1:]:
        total = list_of_values[0]
        total=total+v
        mr.emit(total)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
