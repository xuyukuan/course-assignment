package nicestring

fun String.isNice(): Boolean {
    val vowels = listOf('a', 'e', 'i', 'o', 'u')
    fun cond1(): Boolean = listOf("bu", "ba", "be").none {this.contains(it)}
    fun cond2(): Boolean = this.count { c -> vowels.contains(c) } >= 3
    fun cond3(): Boolean {
        var doubleChar = false
        this.forEachIndexed { index, c ->
            if (index != 0) {
                if (this[index - 1] == c) {
                    doubleChar = true
                }
            }
        }
        return doubleChar
    }
    return listOf(cond1(), cond2(), cond3()).count { it } >= 2
}