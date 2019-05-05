package games.game2048

/*
 * This function moves all the non-null elements to the beginning of the list
 * (by removing nulls) and merges equal elements.
 * The parameter 'merge' specifies the way how to merge equal elements:
 * it returns a new element that should be present in the resulting list
 * instead of two merged elements.
 *
 * If the function 'merge("a")' returns "aa",
 * then the function 'moveAndMergeEqual' transforms the input in the following way:
 *   a, a, b -> aa, b
 *   a, null -> a
 *   b, null, a, a -> b, aa
 *   a, a, null, a -> aa, a
 *   a, null, a, a -> aa, a
 *
 * You can find more examples in 'TestGame2048Helper'.
*/
fun <T : Any> List<T?>.moveAndMergeEqual(merge: (T) -> T): List<T> {
    with(this.filterNotNull()) {
        val result: MutableList<T> = mutableListOf()
        var p1 = 0
        var p2 = 1
        while (true) {
            if (p1 > this.size - 1) {
                break
            } else if (p2 > this.size - 1) {
                result += this[p1]
                break
            }
            val p1v = this[p1]
            val p2v = this[p2]
            if (p1v == p2v) {
                result += merge(p1v)
                p1 += 2
                p2 += 2
            } else {
                result += p1v
                p1++
                p2++
            }
        }
        return result.toList()
    }
}

