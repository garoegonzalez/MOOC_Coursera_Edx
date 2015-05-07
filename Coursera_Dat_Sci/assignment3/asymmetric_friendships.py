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
    record=sorted(record)
    key   = record[0]
    value = record[1]
    mr.emit_intermediate(key,value)

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts    
    newlist=[]
    for v in list_of_values:
        if v in newlist: newlist.remove(v);continue
        newlist.append(v)
    for v in newlist:
        mr.emit((key, v))
        mr.emit((v, key))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
