import numpy as np
import array
import random
np.__version__


result = 0
for i in range(100):
    result += i
x = 4
x = 'four'

l = list(range(10))
l
type(l[0])

l2 = [str(c) for c in l]
l2
type(l2[0])

l3 = [True, "2", 3.0, 4]
l3
[type(item) for item in l3]

a = array.array('i', l)
a

np.array([1.22,2,3,4,5], dtype="float32")

np.array([range(i, i + 3) for i in [2, 4, 6]])

np.array([range(i, i + 4) for i in [2, 6, 8]])

np.array([range(i, i + 1) for i in [1,2,3]])

## Create a length-10 integer array filled with zeros
np.zeros(10, dtype="int")

## Create a 3x5 floating array filled with ones
np.ones((3,5), dtype="float32")

## Create a 3x5 array filled with 3.14 (using the np.full will take any number that it is given in its second argument)
np.full((3,5), 3.14)

## Create an array with a linear sequence
## Starting at 0, ending at 20, stepping by 2
## (this is similar to the built-in range() function)
np.arange(0,20,2)

## Create an array of five values evenly spaced between 0 and 1
np.linspace(0,1,5)

## Create a 3x3 array of uniformly distributed
## random values between 0 and 1
np.random.random((3,3))

## Create a 3x3 array of normally distributed random values
## with mean 0 and standard deviation 1
np.random.normal(0,1,(3,3))

## Create a 3x3 array of random integers in the interval [0,10]
np.random.randint(0,10,(3,3))

## Create a 3x3 indentity matrix
np.eye(3)

## Create an uninitialized array of three integers
## The values will be whatever happens to already exist in that memory location
np.empty(3)