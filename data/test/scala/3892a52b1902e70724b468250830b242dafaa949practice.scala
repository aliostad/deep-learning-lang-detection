// Set up type aliases
type Row = Array[Int]
type Matrix = Array[Row]

// Read in the parameters of the matrix
print("How many rows? ")
val h: Int = readInt
print("How many columns? ")
val w: Int = readInt
print("How many negative positions? ")
val n: Int = readInt

// Create the array of empty rows
val grid: Matrix = new Matrix(h)

// Make the rows
for (r <- 0 until h)
  grid(r) = new Row(w)

// Function to print out the matrix
def dumpMatrix(grid: Matrix) = {
  println
  var r: Int = 0
  while (r < h) {
    var c: Int = 0
    while (c < w) {
      // Separate the items with a tab
      print("\t" + grid(r)(c))
      c += 1
    }
    println
    r += 1
  }
}

// Start by printing the empty matrix (all zeros)
dumpMatrix(grid)

// Set the values in the matrix (multiplication table)
for (r <- 0 until h)
  for (c <- 0 until w)
    grid(r)(c) = (r+1) * (c+1)

// Dump the table to the screen
dumpMatrix(grid)

// Define a simple function to generate a random Int in a particular range
def getRand(v: Int): Int = (math.random * v).toInt

// Recursive function to make <count> positions of the matrix negative
def makeNegative(count: Int): Unit = {
  if (count > 0) {
    // Recursive case
    
    // Randomly choose a spot in the table
    val r: Int = getRand(h)
    val c: Int = getRand(w)
    // Only change the sign if it is positive!
    if (grid(r)(c) > 0) {
      grid(r)(c) *= -1
      makeNegative(count-1)
    } else {
      makeNegative(count)
    }
  }
} 

// Call the makeNegative function
makeNegative(n)

// Dump the resulting function
dumpMatrix(grid)