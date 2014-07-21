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
    key = record[0]
    value = record[1]
    words = value.split()
    for w in words:
        mr.emit_intermediate(w,key)

def reducer(key, list_of_values):
    # key: word
    # fileNames: list_of_values  
    names = []
    for name in list_of_values:
        if name in names: continue ##to avoid repetitions
        names.append(name)
    mr.emit((key, names))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
