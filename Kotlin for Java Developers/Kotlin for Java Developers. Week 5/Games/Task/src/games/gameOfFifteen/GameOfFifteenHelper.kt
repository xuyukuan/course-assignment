package games.gameOfFifteen

/*
 * This function should return the parity of the permutation.
 * true - the permutation is even
 * false - the permutation is odd
 * https://en.wikipedia.org/wiki/Parity_of_a_permutation

 * If the game of fifteen is started with the wrong parity, you can't get the correct result
 *   (numbers sorted in the right order, empty cell at last).
 * Thus the initial permutation should be correct.
 */
fun isEven(permutation: List<Int>): Boolean {
    var i = 0
    var li = permutation.toMutableList()
    with(li) {
        var end = size
        while (end > 1) {
            for (j in 1 until end) {
                if (this[j - 1] > this[j]) {
                    // swap
                    this[j - 1] = this[j].also { this[j] = this[j - 1] }
                    i++
                }
            }
            end--
        }
    }
    return i % 2 == 0
}
