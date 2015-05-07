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
    value = record
    for i in range(5):
        if 'a' in record[0]:     
            key = (record[1],i)
            mr.emit_intermediate(key,value)
        if 'b' in record[0]:     
            key = (i,record[2])
            mr.emit_intermediate(key,value)


def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    total=0
    for i in range(5):
        a=0
        b=0
        for v in list_of_values:            
            if 'a' in v[0] and v[1]==key[0] and v[2]==i :
                a=v[3]
            if 'b' in v[0] and v[2]==key[1] and v[1]==i :
                b=v[3]
        total+=a*b
    mr.emit((key[0],key[1], total))
            
# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
