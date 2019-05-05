package mastermind

data class Evaluation(val rightPosition: Int, val wrongPosition: Int)

fun evaluateGuess(secret: String, guess: String): Evaluation {
    fun String.analysisMap() = this.fold(mutableMapOf<Char, Int>()) { acc, c ->
        if (acc.containsKey(c)) {
            acc[c] = 1 + acc[c]!!
        } else {
            acc[c] = 1
        }
        acc
    }
    val m1 = secret.analysisMap()
    val m2 = guess.analysisMap()
    var total = 0
    var rightPosition = 0
    for ((k, v) in m1) {
        if (m2.containsKey(k)) {
            total += Math.min(v, m2[k]!!)
        }
    }
    for ((i, c) in guess.withIndex()) {
        if (c == secret[i]) {
            rightPosition++
        }
    }

    return Evaluation(rightPosition, total - rightPosition)
}
